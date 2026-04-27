using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CastroCateringBookingSystem.Pages
{
    public partial class Profile : Page
    {
        private static string ConnStr =>
            ConfigurationManager.ConnectionStrings["CastroDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect to login if not authenticated
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Pages/LoginSignup.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserProfile();
                LoadBookingHistory();
            }
        }

        // ─────────────────────────────────────────────────────────────────────
        // LOAD USER PROFILE FROM DATABASE
        // ─────────────────────────────────────────────────────────────────────
        private void LoadUserProfile()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    const string sql = @"
                        SELECT Username, Email, PhoneNumber, [Address]
                        FROM   Users
                        WHERE  UserID = @UserID";

                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        using (var reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                string username = reader["Username"].ToString();
                                string email    = reader["Email"].ToString();
                                string phone    = reader["PhoneNumber"].ToString();
                                string address  = reader["Address"].ToString();

                                // Populate profile display labels
                                lblProfileAvatar.Text   = username.Substring(0, 1).ToUpper();
                                lblProfileName.Text     = username;
                                lblProfileEmail.Text    = email;
                                lblInfoUsername.Text    = username;
                                lblInfoEmail.Text       = email;
                                lblInfoPhone.Text       = phone;
                                lblInfoAddress.Text     = address;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadUserProfile error: " + ex.Message);
            }
        }

        // ─────────────────────────────────────────────────────────────────────
        // LOAD BOOKING HISTORY FROM DATABASE
        // ─────────────────────────────────────────────────────────────────────
        private void LoadBookingHistory()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            var bookings = new List<BookingRecord>();

            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    const string sql = @"
                        SELECT b.BookingID, p.PackageName, b.EventType, b.EventDate,
                               b.NoOfGuests, b.ModeOfPayment, b.TotalAmount,
                               b.[Status], b.DateCreated
                        FROM   Bookings b
                        LEFT JOIN Packages p ON b.PackageID = p.PackageID
                        WHERE  b.UserID = @UserID
                        ORDER  BY b.DateCreated DESC";

                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                bookings.Add(new BookingRecord
                                {
                                    BookingID   = Convert.ToInt32(reader["BookingID"]),
                                    PackageName = reader["PackageName"].ToString(),
                                    EventType   = reader["EventType"].ToString(),
                                    EventDate   = Convert.ToDateTime(reader["EventDate"]),
                                    NoOfGuests  = Convert.ToInt32(reader["NoOfGuests"]),
                                    Payment     = reader["ModeOfPayment"].ToString(),
                                    Amount      = Convert.ToDecimal(reader["TotalAmount"]),
                                    Status      = reader["Status"].ToString(),
                                    BookedAt    = Convert.ToDateTime(reader["DateCreated"])
                                });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadBookingHistory error: " + ex.Message);
            }

            rptBookings.DataSource = bookings;
            rptBookings.DataBind();
            lblBookingCount.Text = bookings.Count + " booking" + (bookings.Count != 1 ? "s" : "");
        }

        // ─────────────────────────────────────────────────────────────────────
        // HELPER — called from Repeater ItemTemplate
        // ─────────────────────────────────────────────────────────────────────
        public string GetStatusClass(string status)
        {
            switch (status)
            {
                case "Upcoming":   return "status-upcoming";
                case "Completed":  return "status-completed";
                case "Cancelled":  return "status-cancelled";
                default:           return "";
            }
        }
    }

    [Serializable]
    public class BookingRecord
    {
        public int      BookingID   { get; set; }
        public string   PackageName { get; set; }
        public string   EventType   { get; set; }
        public DateTime EventDate   { get; set; }
        public int      NoOfGuests  { get; set; }
        public string   Payment     { get; set; }
        public decimal  Amount      { get; set; }
        public string   Status      { get; set; }
        public DateTime BookedAt    { get; set; }
    }
}
