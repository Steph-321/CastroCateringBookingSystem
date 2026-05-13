using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Threading;
using System.Windows.Forms;
using Microsoft.Web.WebView2.WinForms;
using Microsoft.Web.WebView2.Core;

namespace CastroCateringLauncher
{
    public class MainForm : Form
    {
        // ── Configuration ────────────────────────────────────────────────────
        private const int    Port      = 8080;
        private const string StartPage = "Pages/LoginSignup.aspx";
        private const string AppTitle  = "Castro Catering Booking System";

        private static readonly string[] IisExpressPaths =
        {
            @"C:\Program Files\IIS Express\iisexpress.exe",
            @"C:\Program Files (x86)\IIS Express\iisexpress.exe"
        };

        // ── Fields ───────────────────────────────────────────────────────────
        private WebView2 _webView;
        private Process  _iisProcess;
        private Panel    _loadingPanel;
        private Label    _loadingLabel;

        // ── Constructor ──────────────────────────────────────────────────────
        public MainForm()
        {
            InitializeComponent();
            StartIisAndLoad();
        }

        // ── UI Setup ─────────────────────────────────────────────────────────
        private void InitializeComponent()
        {
            this.Text          = AppTitle;
            this.Width         = 1280;
            this.Height        = 800;
            this.MinimumSize   = new System.Drawing.Size(900, 600);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.WindowState   = FormWindowState.Maximized;

            // Try to load icon
            try
            {
                string iconPath = Path.Combine(
                    AppDomain.CurrentDomain.BaseDirectory, "icon.ico");
                if (File.Exists(iconPath))
                    this.Icon = new System.Drawing.Icon(iconPath);
            }
            catch { }

            // Loading panel
            _loadingPanel = new Panel
            {
                Dock      = DockStyle.Fill,
                BackColor = System.Drawing.Color.FromArgb(250, 248, 243)
            };
            _loadingLabel = new Label
            {
                Text      = "Starting Castro Catering Booking System...\nPlease wait.",
                Font      = new System.Drawing.Font("Segoe UI", 14f),
                ForeColor = System.Drawing.Color.FromArgb(74, 63, 53),
                AutoSize  = false,
                TextAlign = System.Drawing.ContentAlignment.MiddleCenter,
                Dock      = DockStyle.Fill
            };
            _loadingPanel.Controls.Add(_loadingLabel);

            // WebView2 — renders with Edge (full modern CSS support)
            _webView = new WebView2
            {
                Dock    = DockStyle.Fill,
                Visible = false
            };

            this.Controls.Add(_webView);
            this.Controls.Add(_loadingPanel);

            this.FormClosing += MainForm_FormClosing;
        }

        // ── Start IIS Express then navigate ──────────────────────────────────
        private async void StartIisAndLoad()
        {
            // Find IIS Express
            string iisPath = null;
            foreach (var p in IisExpressPaths)
                if (File.Exists(p)) { iisPath = p; break; }

            if (iisPath == null)
            {
                MessageBox.Show(
                    "IIS Express was not found.\nPlease install Visual Studio or IIS Express.",
                    AppTitle, MessageBoxButtons.OK, MessageBoxIcon.Error);
                Application.Exit();
                return;
            }

            // Find the web project folder
            string projectDir = FindProjectDir();
            if (projectDir == null)
            {
                using (var dlg = new FolderBrowserDialog())
                {
                    dlg.Description = "Select the CastroCateringBookingSystem folder (the one with Web.config).";
                    if (dlg.ShowDialog() == DialogResult.OK)
                        projectDir = dlg.SelectedPath;
                    else { Application.Exit(); return; }
                }
            }

            // Kill any leftover iisexpress
            KillExistingIis();

            // Start IIS Express
            var psi = new ProcessStartInfo
            {
                FileName        = iisPath,
                Arguments       = $"/path:\"{projectDir}\" /port:{Port} /clr:v4.0",
                CreateNoWindow  = true,
                UseShellExecute = false
            };
            try { _iisProcess = Process.Start(psi); }
            catch (Exception ex)
            {
                MessageBox.Show("Failed to start IIS Express:\n" + ex.Message,
                    AppTitle, MessageBoxButtons.OK, MessageBoxIcon.Error);
                Application.Exit();
                return;
            }

            // Initialize WebView2
            try
            {
                await _webView.EnsureCoreWebView2Async(null);
                // Disable context menu and dev tools for cleaner app feel
                _webView.CoreWebView2.Settings.AreDefaultContextMenusEnabled  = false;
                _webView.CoreWebView2.Settings.AreDevToolsEnabled             = false;
                _webView.CoreWebView2.Settings.IsStatusBarEnabled             = false;
            }
            catch (Exception ex)
            {
                // WebView2 failed — show exact error so we know what's wrong
                MessageBox.Show(
                    "WebView2 failed to initialize.\n\nError:\n" + ex.GetType().Name + "\n" + ex.Message + "\n\nInner: " + (ex.InnerException?.Message ?? "none"),
                    AppTitle, MessageBoxButtons.OK, MessageBoxIcon.Error);
                Application.Exit();
                return;
            }

            // Wait for IIS Express to be ready
            await System.Threading.Tasks.Task.Run(() => WaitForServer(Port, 15));

            // Navigate
            string url = $"http://localhost:{Port}/{StartPage}";
            _webView.CoreWebView2.NavigationCompleted += (s, e) =>
            {
                if (_loadingPanel.Visible)
                {
                    _loadingPanel.Visible = false;
                    _webView.Visible      = true;
                }
            };
            _webView.CoreWebView2.Navigate(url);
        }

        // ── Find the web project folder ───────────────────────────────────────
        private string FindProjectDir()
        {
            string exeDir = AppDomain.CurrentDomain.BaseDirectory;

            string[] candidates =
            {
                Path.GetFullPath(Path.Combine(exeDir, @"..\..\..\CastroCateringBookingSystem")),
                Path.GetFullPath(Path.Combine(exeDir, @"..\..\CastroCateringBookingSystem")),
                Path.GetFullPath(Path.Combine(exeDir, @"..\CastroCateringBookingSystem")),
                Path.GetFullPath(Path.Combine(exeDir, @"CastroCateringBookingSystem")),
            };

            foreach (var c in candidates)
                if (Directory.Exists(c) && File.Exists(Path.Combine(c, "Web.config")))
                    return c;

            return null;
        }

        // ── Poll until server responds ────────────────────────────────────────
        private static void WaitForServer(int port, int waitSeconds)
        {
            Thread.Sleep(2000); // always wait 2s minimum
            string url     = $"http://localhost:{port}/";
            var    deadline = DateTime.Now.AddSeconds(waitSeconds);

            while (DateTime.Now < deadline)
            {
                try
                {
                    var req = (HttpWebRequest)WebRequest.Create(url);
                    req.Timeout = 800;
                    req.Method  = "HEAD";
                    using (req.GetResponse()) { }
                    return;
                }
                catch { Thread.Sleep(400); }
            }
        }

        // ── Cleanup on close ─────────────────────────────────────────────────
        private void MainForm_FormClosing(object sender, FormClosingEventArgs e)
        {
            KillExistingIis();
        }

        private void KillExistingIis()
        {
            try { if (_iisProcess != null && !_iisProcess.HasExited) _iisProcess.Kill(); }
            catch { }
            try
            {
                foreach (var p in Process.GetProcessesByName("iisexpress"))
                    try { p.Kill(); } catch { }
            }
            catch { }
        }
    }
}
