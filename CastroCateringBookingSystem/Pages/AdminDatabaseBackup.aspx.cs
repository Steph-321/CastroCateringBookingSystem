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

        // Default SQL Server Express backup folder
        private const string BackupFolder =
            @"C:\Program Files\Microsoft SQL Server\MSSQL17.SQLEXPRESS\MSSQL\Backup\";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadBackupHistory();
                LoadDbInfo();
            }
        }

        // ── LOAD DB SIZE / LAST BACKUP INFO ──────────────────────
        private void LoadDbInfo()
        {
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    // DB size
                    using (var cmd = new SqlCommand(
                        "SELECT SUM(size) * 8.0 / 1024 FROM sys.database_files", conn))
                    {
                        object r = cmd.ExecuteScalar();
                        lblDbSize.Text = r != null && r != DBNull.Value
                            ? string.Format("{0:N2} MB", Convert.ToDouble(r))
                            : "—";
                    }

                    // Last backup time from msdb
                    using (var cmd = new SqlCommand(@"
                        SELECT TOP 1 backup_finish_date
                        FROM   msdb.dbo.backupset
                        WHERE  database_name = DB_NAME()
                          AND  type = 'D'
                        ORDER  BY backup_finish_date DESC", conn))
                    {
                        object r = cmd.ExecuteScalar();
                        lblLastBackup.Text = r != null && r != DBNull.Value
                            ? Convert.ToDateTime(r).ToString("MMM dd, yyyy  h:mm tt")
                            : "Never";
                    }

                    // Total bookings
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Bookings", conn))
                    {
                        lblTotalRecords.Text = cmd.ExecuteScalar().ToString() + " bookings";
                    }

                    // Total users
                    using (var cmd = new SqlCommand("SELECT COUNT(*) FROM Users", conn))
                    {
                        lblTotalUsers.Text = cmd.ExecuteScalar().ToString() + " users";
                    }
                }
            }
            catch (Exception ex)
            {
                lblStatus.Text = "⚠ Could not load DB info: " + ex.Message;
                lblStatus.CssClass = "status-msg error";
                lblStatus.Visible = true;
            }
        }

        // ── TRIGGER BACKUP ───────────────────────────────────────
        protected void btnBackup_Click(object sender, EventArgs e)
        {
            try
            {
                // Build timestamped filename
                string timestamp  = DateTime.Now.ToString("yyyyMMdd_HHmmss");
                string fileName   = $"CastroCatering_DB_{timestamp}.bak";
                string fullPath   = Path.Combine(BackupFolder, fileName);

                // Ensure folder exists (SQL Server service account must have write access)
                if (!Directory.Exists(BackupFolder))
                    Directory.CreateDirectory(BackupFolder);

                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    string sql = $@"
                        BACKUP DATABASE [{conn.Database}]
                        TO DISK = N'{fullPath.Replace("'", "''")}'
                        WITH FORMAT,
                             MEDIANAME = N'CastroCateringBackup',
                             NAME      = N'CastroCatering_DB Full Backup {timestamp}',
                             STATS     = 10;";

                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        cmd.CommandTimeout = 300; // 5 minutes
                        cmd.ExecuteNonQuery();
                    }
                }

                lblStatus.Text     = $"✔ Backup created successfully: {fileName}";
                lblStatus.CssClass = "status-msg success";
                lblStatus.Visible  = true;

                LoadBackupHistory();
                LoadDbInfo();
            }
            catch (Exception ex)
            {
                lblStatus.Text     = "✘ Backup failed: " + ex.Message;
                lblStatus.CssClass = "status-msg error";
                lblStatus.Visible  = true;
            }
        }

        // ── LOAD BACKUP HISTORY FROM MSDB ────────────────────────
        private void LoadBackupHistory()
        {
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    const string sql = @"
                        SELECT TOP 20
                            bs.backup_finish_date                          AS BackupDate,
                            bmf.physical_device_name                       AS FilePath,
                            CAST(bs.backup_size / 1048576.0 AS DECIMAL(10,2)) AS SizeMB,
                            bs.name                                        AS BackupName
                        FROM   msdb.dbo.backupset        bs
                        JOIN   msdb.dbo.backupmediafamily bmf
                               ON bs.media_set_id = bmf.media_set_id
                        WHERE  bs.database_name = DB_NAME()
                          AND  bs.type          = 'D'
                        ORDER  BY bs.backup_finish_date DESC";

                    var da = new SqlDataAdapter(sql, conn);
                    var dt = new DataTable();
                    da.Fill(dt);

                    gvBackupHistory.DataSource = dt;
                    gvBackupHistory.DataBind();

                    phNoHistory.Visible = (dt.Rows.Count == 0);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadBackupHistory error: " + ex.Message);
                phNoHistory.Visible = true;
            }
        }
    }
}
