using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace CastroCateringBookingSystem.Pages
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        string ConnStr = ConfigurationManager.ConnectionStrings["conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboard();
            }
        }

        void LoadDashboard()
        {
            LoadBookings();
            LoadStats();
            LoadPackageStats();
        }

        protected void Timer1_Tick(object sender, EventArgs e)
        {
            LoadDashboard();
        }

        // ── RECENT BOOKINGS GRID ──────────────────────────────────
        void LoadBookings()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string query = @"
                    SELECT TOP 10
                        B.BookingID,
                        ISNULL(U.Username, 'Unknown') AS CustomerName,
                        B.EventType,
                        B.EventDate,
                        B.PackageID,
                        (ISNULL(P.RatePerGuest, 0) * B.NoOfGuests) AS Total,
                        B.Status
                    FROM Bookings B
                    LEFT JOIN Users U ON B.UserID = U.UserID
                    LEFT JOIN Packages P ON B.PackageID = P.PackageID
                    ORDER BY B.BookingID DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                GridViewRecent.DataSource = dt;
                GridViewRecent.DataBind();
            }
        }

        // ── STAT CARDS ───────────────────────────────────────────
        void LoadStats()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string query = @"
                    SELECT
                        COUNT(*)                                                    AS TotalBookings,
                        SUM(CASE WHEN Status = 'Approved'  THEN 1 ELSE 0 END)      AS Upcoming,
                        SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END)      AS Completed,
                        ISNULL(SUM(NoOfGuests), 0)                                 AS TotalGuests
                    FROM Bookings";

                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();

                using (SqlDataReader r = cmd.ExecuteReader())
                {
                    if (r.Read())
                    {
                        lblTotalBookings.Text = r["TotalBookings"].ToString();
                        lblUpcoming.Text      = r["Upcoming"].ToString();
                        lblCompleted.Text     = r["Completed"].ToString();
                        lblGuests.Text        = r["TotalGuests"].ToString();
                    }
                }
            }
        }

        // ── PACKAGE STATISTICS ───────────────────────────────────
        void LoadPackageStats()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string query = @"
                    SELECT PackageID, COUNT(*) AS TotalBookings
                    FROM Bookings
                    GROUP BY PackageID
                    ORDER BY TotalBookings DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();

                // First pass: find max for bar width calculation
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count == 0)
                {
                    lblPackageStats.Text = "<p style='color:#756e64;font-size:0.875rem;'>No package data yet.</p>";
                    return;
                }

                int max = 1;
                foreach (DataRow row in dt.Rows)
                {
                    int val = Convert.ToInt32(row["TotalBookings"]);
                    if (val > max) max = val;
                }

                string html = "";
                foreach (DataRow row in dt.Rows)
                {
                    int count = Convert.ToInt32(row["TotalBookings"]);
                    int pct   = (int)Math.Round((double)count / max * 100);
                    string pkg = "Package " + row["PackageID"];

                    html += $@"
                    <div class='pkg-stat-row'>
                        <span class='pkg-name'>{pkg}</span>
                        <div class='pkg-bar-wrap'>
                            <div class='pkg-bar' style='width:{pct}%'></div>
                        </div>
                        <span class='pkg-count'>{count} booking{(count == 1 ? "" : "s")}</span>
                    </div>";
                }

                lblPackageStats.Text = html;
            }
        }
    }
}
