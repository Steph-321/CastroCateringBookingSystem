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
        string ConnStr = ConfigurationManager.ConnectionStrings["CastroCatering_DB"].ConnectionString;
        

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
                        (P.RatePerGuest  * B.NoOfGuests) AS Total,
                        B.Status
                    FROM Bookings B
                    JOIN Users U ON B.UserID = U.UserID
                    JOIN Packages P ON B.PackageID = P.PackageID
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
                    message = "Your booking has been APPROVED 🎉";
                else if (newStatus == "Completed")
                    message = "Your booking is COMPLETED ✔";
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

                lblTotalBookings.Text = "Total Bookings: " + total;


            }
        }
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
