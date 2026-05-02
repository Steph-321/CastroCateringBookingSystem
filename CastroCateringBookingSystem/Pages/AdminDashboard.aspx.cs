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

        // ✅ MASTER LOADER (replaces LoadDashboard error)
        void LoadDashboard()
        {
            LoadBookings();
            LoadCount();
            LoadPackageStats();
        }

        // ✅ TIMER FIX (THIS FIXES YOUR ERROR)
        protected void Timer1_Tick(object sender, EventArgs e)
        {
            LoadDashboard();
        }

        // ===================== BOOKINGS GRID =====================
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
                        (ISNULL(P.RatePerGuest,0) * B.NoOfGuests) AS Total,
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

        // ===================== TOTAL BOOKINGS =====================
        void LoadCount()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string query = "SELECT COUNT(*) FROM Bookings";

                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();

                int total = Convert.ToInt32(cmd.ExecuteScalar());

                lblTotalBookings.Text = total.ToString();
            }
        }

        // ===================== PACKAGE STATS =====================
        void LoadPackageStats()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string query = @"
                    SELECT PackageID, COUNT(*) AS TotalBookings
                    FROM Bookings
                    GROUP BY PackageID";

                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();

                string result = "";

                while (reader.Read())
                {
                    result += "Package " + reader["PackageID"] +
                              " = " + reader["TotalBookings"] + " bookings<br/>";
                }

                lblPackageStats.Text = result;
            }
        }
    }
}
