using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace CastroCateringBookingSystem.Pages
{
    public partial class AdminDashboard : System.Web.UI.Page
    {
        string ConnStr = ConfigurationManager.ConnectionStrings["CastroCatering_DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboard();
            }
        }

        // REAL-TIME TIMER
        protected void Timer1_Tick(object sender, EventArgs e)
        {
            LoadDashboard();
        }

        // MAIN REFRESH METHOD
        void LoadDashboard()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                // TOTAL BOOKINGS
                SqlCommand cmd1 = new SqlCommand("SELECT COUNT(*) FROM Bookings", conn);
                lblTotalBookings.Text = cmd1.ExecuteScalar().ToString();

                // UPCOMING (Pending)
                SqlCommand cmd2 = new SqlCommand(
                    "SELECT COUNT(*) FROM Bookings WHERE Status='Pending'", conn);
                lblUpcoming.Text = cmd2.ExecuteScalar().ToString();

                // COMPLETED
                SqlCommand cmd3 = new SqlCommand(
                    "SELECT COUNT(*) FROM Bookings WHERE Status='Completed'", conn);
                lblCompleted.Text = cmd3.ExecuteScalar().ToString();

                // TOTAL GUESTS
                SqlCommand cmd4 = new SqlCommand(
                    "SELECT ISNULL(SUM(NoOfGuests),0) FROM Bookings", conn);
                lblGuests.Text = cmd4.ExecuteScalar().ToString();

                // RECENT BOOKINGS
                string query = @"
                    SELECT TOP 6
                        B.BookingID,
                        U.Username AS CustomerName,
                        B.EventType,
                        B.EventDate,
                        B.PackageID,
                        (B.NoOfGuests * 1000) AS Total,
                        B.Status
                    FROM Bookings B
                    LEFT JOIN Users U ON B.UserID = U.UserID
                    ORDER BY B.BookingID DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                GridViewRecent.DataSource = dt;
                GridViewRecent.DataBind();
            }
        }
    }
}
