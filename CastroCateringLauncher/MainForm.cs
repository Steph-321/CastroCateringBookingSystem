using System;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Threading;
using System.Windows.Forms;
using Microsoft.Web.WebView2.WinForms;

namespace CastroCateringLauncher
{
    public class MainForm : Form
    {
        private const string AppTitle  = "Castro Catering Booking System";
        private const string StartPage = "Pages/LoginSignup.aspx";
        private const string SiteName  = "CastroCateringBookingSystem";

        // HTTP port from applicationhost.config
        private const int HttpPort  = 65499;
        private const int HttpsPort = 44373;

        private WebView2 _webView;
        private Process  _iisProcess;
        private Panel    _loadingPanel;
        private Label    _loadingLabel;

        public MainForm()
        {
            InitializeComponent();
            StartApp();
        }

        private void InitializeComponent()
        {
            this.Text          = AppTitle;
            this.Width         = 1280;
            this.Height        = 800;
            this.MinimumSize   = new System.Drawing.Size(900, 600);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.WindowState   = FormWindowState.Maximized;

            try
            {
                string ico = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "logo.ico");
                if (File.Exists(ico)) this.Icon = new System.Drawing.Icon(ico);
            }
            catch { }

            _loadingPanel = new Panel
            {
                Dock      = DockStyle.Fill,
                BackColor = System.Drawing.Color.FromArgb(250, 248, 243)
            };
            _loadingLabel = new Label
            {
                Text      = "Starting...",
                Font      = new System.Drawing.Font("Segoe UI", 13f),
                ForeColor = System.Drawing.Color.FromArgb(74, 63, 53),
                AutoSize  = false,
                TextAlign = System.Drawing.ContentAlignment.MiddleCenter,
                Dock      = DockStyle.Fill
            };
            _loadingPanel.Controls.Add(_loadingLabel);

            _webView = new WebView2 { Dock = DockStyle.Fill, Visible = false };

            this.Controls.Add(_webView);
            this.Controls.Add(_loadingPanel);
            this.FormClosing += (s, e) => KillIis();
        }

        private async void StartApp()
        {
            // ── Step 1: Find IIS Express (prefer 64-bit) ─────────────────
            SetStatus("Finding IIS Express...");
            string iisPath = null;
            string[] iisCandidates = {
                @"C:\Program Files\IIS Express\iisexpress.exe",
                @"C:\Program Files (x86)\IIS Express\iisexpress.exe"
            };
            foreach (var p in iisCandidates)
                if (File.Exists(p)) { iisPath = p; break; }

            if (iisPath == null)
            {
                MessageBox.Show("IIS Express not found. Please install Visual Studio.",
                    AppTitle, MessageBoxButtons.OK, MessageBoxIcon.Error);
                Application.Exit(); return;
            }

            // ── Step 2: Find the .vs config ───────────────────────────────
            SetStatus("Finding configuration...");
            string vsConfig = FindVsConfig();
            if (vsConfig == null)
            {
                MessageBox.Show(
                    "Could not find the project configuration.\n\n" +
                    "Please open the solution in Visual Studio and press F5 once\n" +
                    "to generate the configuration, then try again.",
                    AppTitle, MessageBoxButtons.OK, MessageBoxIcon.Warning);
                Application.Exit(); return;
            }

            // ── Step 3: Kill any leftover iisexpress processes ────────────
            foreach (var proc in Process.GetProcessesByName("iisexpress"))
                try { proc.Kill(); } catch { }
            Thread.Sleep(1500);

            // ── Step 4: Start IIS Express ─────────────────────────────────
            SetStatus("Starting server, please wait...");

            var psi = new ProcessStartInfo
            {
                FileName        = iisPath,
                Arguments       = $"/config:\"{vsConfig}\" /site:\"{SiteName}\" /apppool:\"Clr4IntegratedAppPool\"",
                CreateNoWindow  = true,
                UseShellExecute = false
            };

            try { _iisProcess = Process.Start(psi); }
            catch (Exception ex)
            {
                MessageBox.Show("Failed to start server:\n" + ex.Message,
                    AppTitle, MessageBoxButtons.OK, MessageBoxIcon.Error);
                Application.Exit(); return;
            }

            // ── Step 5: Wait up to 45 seconds for server ──────────────────
            SetStatus("Waiting for server to start...\n\nThis may take up to 30 seconds.");
            bool ready = await System.Threading.Tasks.Task.Run(() => WaitForServer(60));

            if (!ready)
            {
                MessageBox.Show(
                    "Server did not start in time.\n\n" +
                    "Try running as Administrator, or open Visual Studio\n" +
                    "and press F5 first to initialize the project.",
                    AppTitle, MessageBoxButtons.OK, MessageBoxIcon.Warning);
                Application.Exit(); return;
            }

            // ── Step 6: Init WebView2 ─────────────────────────────────────
            SetStatus("Initializing display...");
            try
            {
                await _webView.EnsureCoreWebView2Async(null);
                _webView.CoreWebView2.Settings.AreDefaultContextMenusEnabled = false;
                _webView.CoreWebView2.Settings.AreDevToolsEnabled            = false;
                _webView.CoreWebView2.Settings.IsStatusBarEnabled            = false;
            }
            catch (Exception ex)
            {
                MessageBox.Show("Display error:\n" + ex.Message,
                    AppTitle, MessageBoxButtons.OK, MessageBoxIcon.Error);
                Application.Exit(); return;
            }

            // ── Step 7: Navigate — HTTP first (most reliable) ─────────────
            string url = $"http://localhost:{HttpPort}/{StartPage}";

            SetStatus("Loading...");
            _webView.CoreWebView2.NavigationCompleted += (s, e) =>
            {
                _loadingPanel.Visible = false;
                _webView.Visible      = true;
            };
            _webView.CoreWebView2.Navigate(url);
        }

        private string FindVsConfig()
        {
            // Search from exe location upward for .vs folder
            string dir = AppDomain.CurrentDomain.BaseDirectory;
            for (int i = 0; i < 8; i++)
            {
                string parent = Path.GetFullPath(Path.Combine(dir, ".."));
                if (parent == dir) break;
                dir = parent;

                string candidate = Path.Combine(dir, ".vs", SiteName, "config", "applicationhost.config");
                if (File.Exists(candidate)) return candidate;
            }
            return null;
        }

        private static bool WaitForServer(int timeoutSeconds)
        {
            // Give IIS a moment to initialize
            Thread.Sleep(3000);

            ServicePointManager.ServerCertificateValidationCallback = (a, b, c, d) => true;
            var deadline = DateTime.Now.AddSeconds(timeoutSeconds);

            while (DateTime.Now < deadline)
            {
                // Try HTTP first (port 65499)
                if (IsPortUp(HttpPort)) return true;
                // Also try HTTPS (port 44373)
                if (IsPortUp(HttpsPort)) return true;
                Thread.Sleep(1000);
            }
            return false;
        }

        private static bool IsPortUp(int port)
        {
            try
            {
                using (var client = new System.Net.Sockets.TcpClient())
                {
                    var result = client.BeginConnect("localhost", port, null, null);
                    bool success = result.AsyncWaitHandle.WaitOne(TimeSpan.FromSeconds(1));
                    if (success) { client.EndConnect(result); return true; }
                    return false;
                }
            }
            catch { return false; }
        }

        private static bool IsServerUp(string url, int timeoutSeconds)
        {
            try
            {
                ServicePointManager.ServerCertificateValidationCallback = (a, b, c, d) => true;
                var req = (HttpWebRequest)WebRequest.Create(url);
                req.Timeout = timeoutSeconds * 1000;
                req.Method  = "GET";
                req.ServerCertificateValidationCallback = (a, b, c, d) => true;
                using (var resp = (HttpWebResponse)req.GetResponse())
                    return true;
            }
            catch (WebException ex) when (ex.Response != null)
            {
                return true;
            }
            catch { return false; }
        }

        private void SetStatus(string msg)
        {
            if (this.InvokeRequired)
                this.Invoke(new Action(() => _loadingLabel.Text = msg));
            else
                _loadingLabel.Text = msg;
        }

        private void KillIis()
        {
            try { if (_iisProcess != null && !_iisProcess.HasExited) _iisProcess.Kill(); }
            catch { }
        }
    }
}
