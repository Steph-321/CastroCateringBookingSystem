using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace CastroCateringBookingSystem.Admin
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        string ConnStr = ConfigurationManager.ConnectionStrings["conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["IsAdmin"] == null || !(bool)Session["IsAdmin"])
            {
                Response.Redirect("~/Admin/AdminLogin.aspx");
                return;
            }

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
                    SELECT P.PackageName, COUNT(*) AS TotalBookings
                    FROM Bookings B
                    LEFT JOIN Packages P ON B.PackageID = P.PackageID
                    GROUP BY P.PackageName
                    ORDER BY TotalBookings DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count == 0)
                {
                    lblPackageStats.Text = "<p class='pkg-empty'>No package data yet.</p>";
                    return;
                }

                int total = 0;
                foreach (DataRow row in dt.Rows)
                    total += Convert.ToInt32(row["TotalBookings"]);
                if (total == 0) total = 1;

                int max = 1;
                foreach (DataRow row in dt.Rows)
                {
                    int v = Convert.ToInt32(row["TotalBookings"]);
                    if (v > max) max = v;
                }

                // Colour palette cycling
                string[] barColors    = { "#C9A961", "#4A8FA8", "#6FCF97", "#F2994A", "#9B59B6", "#E74C3C" };
                string[] circleColors = { "#C9A961", "#4A8FA8", "#6FCF97", "#F2994A", "#9B59B6", "#E74C3C" };

                // ── BAR CHART ──
                string bars = "";
                int ci = 0;
                foreach (DataRow row in dt.Rows)
                {
                    int    count   = Convert.ToInt32(row["TotalBookings"]);
                    int    heightPct = (int)Math.Round((double)count / max * 100);
                    string name    = row["PackageName"] == DBNull.Value ? "Unknown" : row["PackageName"].ToString();
                    string color   = barColors[ci % barColors.Length];
                    string shortName = name.Length > 14 ? name.Substring(0, 12) + "…" : name;

                    bars += $@"
                    <div class='pkg-bar-col'>
                        <span class='pkg-bar-val'>{count}</span>
                        <div class='pkg-bar-outer'>
                            <div class='pkg-bar-inner' style='height:{heightPct}%;background:{color};'></div>
                        </div>
                        <span class='pkg-bar-label' title='{System.Web.HttpUtility.HtmlAttributeEncode(name)}'>{System.Web.HttpUtility.HtmlEncode(shortName)}</span>
                    </div>";
                    ci++;
                }

                // ── CIRCLE INDICATORS ──
                string circles = "";
                ci = 0;
                foreach (DataRow row in dt.Rows)
                {
                    int    count   = Convert.ToInt32(row["TotalBookings"]);
                    int    pct     = (int)Math.Round((double)count / total * 100);
                    string name    = row["PackageName"] == DBNull.Value ? "Unknown" : row["PackageName"].ToString();
                    string color   = circleColors[ci % circleColors.Length];
                    // SVG circle: r=36, circumference=226.2
                    double circ    = 226.2;
                    double dash    = circ * pct / 100.0;
                    string shortName = name.Length > 18 ? name.Substring(0, 16) + "…" : name;

                    circles += $@"
                    <div class='pkg-circle-item'>
                        <div class='pkg-circle-wrap'>
                            <svg viewBox='0 0 80 80' class='pkg-circle-svg'>
                                <circle cx='40' cy='40' r='36' fill='none' stroke='#f0ebe4' stroke-width='7'/>
                                <circle cx='40' cy='40' r='36' fill='none' stroke='{color}' stroke-width='7'
                                    stroke-dasharray='{dash:F1} {circ:F1}'
                                    stroke-dashoffset='56.55'
                                    stroke-linecap='round'/>
                            </svg>
                            <span class='pkg-circle-pct' style='color:{color};'>{pct}%</span>
                        </div>
                        <div class='pkg-circle-badge' style='background:{color};'>{System.Web.HttpUtility.HtmlEncode(shortName)}</div>
                        <div class='pkg-circle-sub'>{count} booking{(count == 1 ? "" : "s")}</div>
                    </div>";
                    ci++;
                }

                lblPackageStats.Text = $@"
                <div class='pkg-chart-wrap'>
                    <div class='pkg-bars'>{bars}</div>
                    <div class='pkg-y-axis'>
                        <span>{max}</span><span>{max/2}</span><span>0</span>
                    </div>
                </div>
                <div class='pkg-circles'>{circles}</div>";
            }
        }
    }
}
