using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CastroCateringBookingSystem.Pages
{
    public partial class AdminBookingManagement : System.Web.UI.Page
    {
        string ConnStr = ConfigurationManager.ConnectionStrings["conn"].ConnectionString;
        

        protected void Page_Load(object sender, EventArgs e)
        {
       
            if (!IsPostBack)
            {
                LoadBookings();
                LoadCount();
                LoadPackageStats();
            }
        }

        void LoadBookings()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string query = @"
                SELECT 
                    B.BookingID,
                    U.Username AS CustomerName,
                    B.EventType,
                    B.EventDate,
                    B.NoOfGuests,
                    B.PackageID,
                    (ISNULL(P.RatePerGuest,0) * B.NoOfGuests) AS Total,
                    B.Status
                FROM Bookings B
                LEFT JOIN Users U ON B.UserID = U.UserID
                LEFT JOIN Packages P ON B.PackageID = P.PackageID
                ORDER BY B.EventDate DESC";



                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                GridViewBookings.DataSource = dt;
                GridViewBookings.DataBind();
            }
        }
        protected void GridViewBookings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int bookingId = Convert.ToInt32(e.CommandArgument);

            string cmdName = e.CommandName.Trim();
            string newStatus = null;

            if (cmdName == "Approve")
                newStatus = "Approved";
            else if (cmdName == "Done")
                newStatus = "Completed";
            else if (cmdName == "Pending")
                newStatus = "Pending";

            if (string.IsNullOrWhiteSpace(newStatus))
                return;

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                // UPDATE STATUS
                string updateQuery = "UPDATE Bookings SET Status=@Status WHERE BookingID=@ID";
                SqlCommand cmd = new SqlCommand(updateQuery, conn);
                cmd.Parameters.AddWithValue("@Status", newStatus);
                cmd.Parameters.AddWithValue("@ID", bookingId);
                cmd.ExecuteNonQuery();

                // GET USERID
                string getUser = "SELECT UserID FROM Bookings WHERE BookingID=@ID";
                SqlCommand cmdUser = new SqlCommand(getUser, conn);
                cmdUser.Parameters.AddWithValue("@ID", bookingId);

                object resultUser = cmdUser.ExecuteScalar();
                if (resultUser == null) return;

                int userId = Convert.ToInt32(resultUser);

                // MESSAGE
                string message = "";

                if (newStatus == "Approved")
                    message = "Your booking has been APPROVED";
                else if (newStatus == "Completed")
                    message = "Your booking is COMPLETED";
                else
                    message = "Your booking status was updated.";

                // INSERT NOTIFICATION
                string notifQuery = @"
                INSERT INTO Notifications (UserID, Message)
                VALUES (@UserID, @Message)";

                SqlCommand cmdNotif = new SqlCommand(notifQuery, conn);
                cmdNotif.Parameters.AddWithValue("@UserID", userId);
                cmdNotif.Parameters.AddWithValue("@Message", message);

                cmdNotif.ExecuteNonQuery();


                LoadBookings();
                LoadCount();
                LoadPackageStats();
            }
        }




        protected void GridViewBookings_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int id = Convert.ToInt32(GridViewBookings.DataKeys[e.RowIndex].Value);

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string query = "DELETE FROM Bookings WHERE BookingID=@id";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", id);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            // 🔥 REFRESH UI AFTER DELETE
            LoadBookings();
            LoadCount();
            LoadPackageStats();
        }


        void LoadCount()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string query = "SELECT COUNT(*) FROM Bookings";
                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                int total = (int)cmd.ExecuteScalar();
                lblTotalBookings.Text = "📅 " + total + " Total Booking" + (total == 1 ? "" : "s");
            }
        }

        void LoadPackageStats()
        {
            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string query = @"
                    SELECT PackageID, COUNT(*) AS TotalBookings
                    FROM Bookings
                    GROUP BY PackageID
                    ORDER BY TotalBookings DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
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
