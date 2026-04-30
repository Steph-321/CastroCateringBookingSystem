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
                    B.Status
                FROM Bookings B
                JOIN Users U ON B.UserID = U.UserID
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

            Response.Write("COMMAND: [" + cmdName + "]<br/>");

            if (cmdName == "Approve")
            {
                newStatus = "Approved";
            }
            else if (cmdName == "Done")
            {
                newStatus = "Done";
            }
            else if (cmdName == "Pending")
            {
                newStatus = "Pending";
            }

            Response.Write("STATUS: [" + newStatus + "]<br/>");

            if (string.IsNullOrWhiteSpace(newStatus))
                return;

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string query = "UPDATE Bookings SET Status=@Status WHERE BookingID=@ID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Status", newStatus.Trim());
                cmd.Parameters.AddWithValue("@ID", bookingId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            LoadBookings();
        }





        protected void GridViewBookings_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
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

            LoadBookings();
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
