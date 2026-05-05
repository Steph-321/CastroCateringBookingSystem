using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;

namespace CastroCateringBookingSystem.Pages
{
    public partial class AdminDatabaseBackup : Page
    {
        private static string ConnStr =>
            ConfigurationManager.ConnectionStrings["conn"].ConnectionString;

        private string BackupFolder =>
            Server.MapPath("~/App_Data/Backups/");

        protected void Page_Load(object sender, EventArgs e)
        {
            // Handle download request via query string: ?download=filename.bak
            string dlFile = Request.QueryString["download"];
            if (!string.IsNullOrEmpty(dlFile))
            {
                ServeDownload(dlFile);
                return;
            }

            if (!IsPostBack)
            {
                LoadBackupHistory();
                LoadDbInfo();
            }
        }

        // ── SERVE FILE DOWNLOAD ───────────────────────────────────
        private void ServeDownload(string fileName)
        {
            // Sanitise — strip any path separators to prevent directory traversal
            fileName = Path.GetFileName(fileName);
            if (!fileName.EndsWith(".bak", StringComparison.OrdinalIgnoreCase)) return;

            string fullPath = Path.Combine(BackupFolder, fileName);
            if (!File.Exists(fullPath)) return;

            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Disposition", $"attachment; filename=\"{fileName}\"");
            Response.AddHeader("Content-Length", new FileInfo(fullPath).Length.ToString());
            Response.TransmitFile(fullPath);
            Response.Flush();
            Response.End();
        }

        // ── LOAD DB INFO ─────────────────────────────────────────
        private void LoadDbInfo()
        {
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    using (var cmd = new SqlCommand(
                        "SELECT SUM(size) * 8.0 / 1024 FROM sys.database_files", conn))
                    {
                        object r = cmd.ExecuteScalar();
                        lblDbSize.Text = r != null && r != DBNull.Value
                            ? string.Format("{0:N2} MB", Convert.ToDouble(r)) : "—";
                    }

                    using (var cmd = new SqlCommand(@"
                        SELECT TOP 1 backup_finish_date
                        FROM   msdb.dbo.backupset
                        WHERE  database_name = DB_NAME() AND type = 'D'
                        ORDER  BY backup_finish_date DESC", conn))
                    {
                        object r = cmd.ExecuteScalar();
                        lblLastBackup.Text = r != null && r != DBNull.Value
                            ? Convert.ToDateTime(r).ToString("MMM dd, yyyy  h:mm tt") : "Never";
                    }

                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Bookings", conn))
                        lblTotalRecords.Text = cmd.ExecuteScalar() + " bookings";

                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Users", conn))
                        lblTotalUsers.Text = cmd.ExecuteScalar() + " users";
                }
            }
            catch (Exception ex)
            {
                ShowStatus("⚠ Could not load DB info: " + ex.Message, false);
            }
        }

        // ── CREATE BACKUP ────────────────────────────────────────
        protected void btnBackup_Click(object sender, EventArgs e)
        {
            try
            {
                if (!Directory.Exists(BackupFolder))
                    Directory.CreateDirectory(BackupFolder);

                string timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
                string fileName  = $"CastroCatering_DB_{timestamp}.bak";
                string fullPath  = Path.Combine(BackupFolder, fileName);

                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    string safePath = fullPath.Replace("'", "''");
                    string sql = $@"
                        BACKUP DATABASE [{conn.Database}]
                        TO DISK = N'{safePath}'
                        WITH FORMAT,
                             MEDIANAME = N'CastroCateringBackup',
                             NAME      = N'CastroCatering_DB Full Backup {timestamp}',
                             STATS     = 10;";

                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        cmd.CommandTimeout = 300;
                        cmd.ExecuteNonQuery();
                    }
                }

                // Verify file was actually created
                if (!File.Exists(fullPath))
                    throw new Exception("Backup command ran but file was not found on disk.");

                long sizeKb = new FileInfo(fullPath).Length / 1024;
                ShowStatus(
                    $"✔ Backup created: <strong>{fileName}</strong> ({sizeKb:N0} KB) — " +
                    $"<a href='AdminDatabaseBackup.aspx?download={Uri.EscapeDataString(fileName)}' " +
                    $"style='color:inherit;font-weight:700;text-decoration:underline;'>⬇ Download</a>",
                    true);

                LoadBackupHistory();
                LoadDbInfo();
            }
            catch (Exception ex)
            {
                ShowStatus("✘ Backup failed: " + ex.Message, false);
            }
        }

        // ── LOAD BACKUP HISTORY ──────────────────────────────────
        private void LoadBackupHistory()
        {
            var dt = new DataTable();
            dt.Columns.Add("FileName");
            dt.Columns.Add("FilePath");
            dt.Columns.Add("SizeKB");
            dt.Columns.Add("CreatedDate");

            try
            {
                if (Directory.Exists(BackupFolder))
                {
                    var files = new DirectoryInfo(BackupFolder).GetFiles("*.bak");
                    Array.Sort(files, (a, b) => b.CreationTime.CompareTo(a.CreationTime));

                    foreach (var f in files)
                    {
                        dt.Rows.Add(
                            f.Name,
                            f.FullName,
                            (f.Length / 1024).ToString("N0") + " KB",
                            f.CreationTime.ToString("MMM dd, yyyy  h:mm tt")
                        );
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadBackupHistory: " + ex.Message);
            }

            gvBackupHistory.DataSource = dt;
            gvBackupHistory.DataBind();
            phNoHistory.Visible = (dt.Rows.Count == 0);
        }

        private void ShowStatus(string message, bool success)
        {
            lblStatus.Text     = message;
            lblStatus.CssClass = "status-msg " + (success ? "success" : "error");
            lblStatus.Visible  = true;
        }
    }
}
