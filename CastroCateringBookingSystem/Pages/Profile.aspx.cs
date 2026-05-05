using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CastroCateringBookingSystem.Pages
{
    public partial class Profile : Page
    {
        private static string ConnStr =>
            ConfigurationManager.ConnectionStrings["conn"].ConnectionString;

        // ─────────────────────────────────────────────────────────────────────
        // PAGE LOAD
        // ─────────────────────────────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Pages/LoginSignup.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserProfile();
                LoadBookingHistory();
                LoadNotifications();
            }
        }

        // ─────────────────────────────────────────────────────────────────────
        // LOAD PROFILE FROM DATABASE
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
                        SELECT Username, Email, PhoneNumber, [Address],
                               ISNULL(ProfilePicture, '') AS ProfilePicture
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
                                string picPath  = reader["ProfilePicture"].ToString();

                                // Display labels
                                lblProfileAvatar.Text  = username.Substring(0, 1).ToUpper();
                                lblProfileName.Text    = username;
                                lblProfileEmail.Text   = email;
                                lblInfoUsername.Text   = username;
                                lblInfoEmail.Text      = email;
                                lblInfoPhone.Text      = phone;
                                lblInfoAddress.Text    = address;

                                // Pre-fill edit form
                                txtEditUsername.Text = username;
                                txtEditEmail.Text    = email;
                                txtEditPhone.Text    = phone;
                                txtEditAddress.Text  = address;

                                // Profile picture
                                if (!string.IsNullOrEmpty(picPath))
                                {
                                    imgProfilePic.ImageUrl      = ResolveUrl(picPath);
                                    imgProfilePic.Style["display"] = "block";
                                    // Hide the letter avatar server-side — persists across postbacks
                                    avatarCircle.Style["display"] = "none";
                                }
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
        // SAVE PROFILE CHANGES
        // ─────────────────────────────────────────────────────────────────────
        protected void btnSaveProfile_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            string newUsername = txtEditUsername.Text.Trim();
            string email       = txtEditEmail.Text.Trim();
            string phone       = txtEditPhone.Text.Trim();
            string address     = txtEditAddress.Text.Trim();

            if (string.IsNullOrWhiteSpace(newUsername) ||
                string.IsNullOrWhiteSpace(email)       ||
                string.IsNullOrWhiteSpace(phone)       ||
                string.IsNullOrWhiteSpace(address))
            {
                lblEditStatus.Text      = "All fields are required.";
                lblEditStatus.ForeColor = System.Drawing.Color.Red;
                return;
            }

            // ── Handle profile picture upload ─────────────────────────────
            string picturePath = null;
            if (fuProfilePic.HasFile)
            {
                string ext = Path.GetExtension(fuProfilePic.FileName).ToLower();
                if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".gif" && ext != ".webp")
                {
                    lblEditStatus.Text      = "Only JPG, PNG, GIF or WEBP images are allowed.";
                    lblEditStatus.ForeColor = System.Drawing.Color.Red;
                    return;
                }

                // Save to ~/Uploads/Profiles/
                string uploadDir = Server.MapPath("~/Uploads/Profiles/");
                if (!Directory.Exists(uploadDir))
                    Directory.CreateDirectory(uploadDir);

                string fileName = "profile_" + userId + ext;
                string fullPath = Path.Combine(uploadDir, fileName);
                fuProfilePic.SaveAs(fullPath);
                picturePath = "~/Uploads/Profiles/" + fileName;
            }

            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    // Check if new username is already taken by someone else
                    if (!string.IsNullOrEmpty(newUsername))
                    {
                        using (var chk = new SqlCommand(
                            "SELECT COUNT(1) FROM Users WHERE Username=@U AND UserID<>@ID", conn))
                        {
                            chk.Parameters.AddWithValue("@U",  newUsername);
                            chk.Parameters.AddWithValue("@ID", userId);
                            if ((int)chk.ExecuteScalar() > 0)
                            {
                                lblEditStatus.Text      = "That username is already taken.";
                                lblEditStatus.ForeColor = System.Drawing.Color.Red;
                                return;
                            }
                        }
                    }

                    string sql = picturePath != null
                        ? @"UPDATE Users SET Username=@Username, Email=@Email,
                                PhoneNumber=@Phone, [Address]=@Address,
                                ProfilePicture=@Pic
                            WHERE UserID=@UserID"
                        : @"UPDATE Users SET Username=@Username, Email=@Email,
                                PhoneNumber=@Phone, [Address]=@Address
                            WHERE UserID=@UserID";

                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", newUsername);
                        cmd.Parameters.AddWithValue("@Email",    email);
                        cmd.Parameters.AddWithValue("@Phone",    phone);
                        cmd.Parameters.AddWithValue("@Address",  address);
                        cmd.Parameters.AddWithValue("@UserID",   userId);
                        if (picturePath != null)
                            cmd.Parameters.AddWithValue("@Pic", picturePath);

                        cmd.ExecuteNonQuery();
                    }
                }

                // Update session so nav greeting reflects new username immediately
                Session["Username"] = newUsername;

                // Also update localStorage via JS so the client-side greeting updates
                string safeUsername = newUsername.Replace("'", "\\'");
                ClientScript.RegisterStartupScript(GetType(), "updateUser",
                    $@"try{{
                        var u=JSON.parse(localStorage.getItem('castroUser')||'{{}}');
                        u.username='{safeUsername}';
                        localStorage.setItem('castroUser',JSON.stringify(u));
                    }}catch(e){{}}", true);

                // Reload profile display
                LoadUserProfile();
                lblEditStatus.Text      = "Profile updated successfully!";
                lblEditStatus.ForeColor = System.Drawing.Color.Green;

                ClientScript.RegisterStartupScript(GetType(), "closeEdit",
                    "setTimeout(function(){ toggleEdit(false); }, 1500);", true);
            }
            catch (Exception ex)
            {
                lblEditStatus.Text      = "Error saving profile: " + ex.Message;
                lblEditStatus.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine("SaveProfile error: " + ex.Message);
            }
        }

        // ─────────────────────────────────────────────────────────────────────
        // CANCEL BOOKING
        // ─────────────────────────────────────────────────────────────────────
        protected void btnConfirmCancel_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(hfCancelBookingID.Value, out int bookingId) || bookingId <= 0)
                return;

            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    const string sql = @"
                        UPDATE Bookings
                        SET    [Status] = 'Cancelled'
                        WHERE  BookingID = @BookingID
                          AND  UserID    = @UserID
                          AND  [Status]  = 'Approved'
                          AND  ApprovedAt IS NOT NULL
                          AND  GETDATE() <= DATEADD(HOUR, 12, ApprovedAt)";

                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@BookingID", bookingId);
                        cmd.Parameters.AddWithValue("@UserID",    userId);
                        int rows = cmd.ExecuteNonQuery();

                        if (rows == 0)
                        {
                            ClientScript.RegisterStartupScript(GetType(), "cancelDenied",
                                "closeCancelModal(); alert('Cancellation not allowed. This booking can only be cancelled within 12 hours after admin approval.');", true);
                            LoadBookingHistory();
                            return;
                        }
                    }

                    // Insert notification
                    using (var notifCmd = new SqlCommand(@"
                        INSERT INTO Notifications (UserID, BookingID, Message, DateCreated)
                        VALUES (@UserID, @BookingID, @Message, GETDATE())", conn))
                    {
                        notifCmd.Parameters.AddWithValue("@UserID",    userId);
                        notifCmd.Parameters.AddWithValue("@BookingID", bookingId);
                        notifCmd.Parameters.AddWithValue("@Message",   "Your booking has been cancelled.");
                        notifCmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("CancelBooking error: " + ex.Message);
            }

            LoadBookingHistory();
            LoadNotifications();
            ClientScript.RegisterStartupScript(GetType(), "closeCancel", "closeCancelModal();", true);
        }

        // ─────────────────────────────────────────────────────────────────────
        // LOAD BOOKING HISTORY
        // ─────────────────────────────────────────────────────────────────────
        private void LoadBookingHistory()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            var dt = new DataTable();

            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    const string sql = @"
                        SELECT DISTINCT
                               b.BookingID,
                               COALESCE(p.PackageName, '(Package unavailable)') AS PackageName,
                               b.EventType,
                               b.EventDate,
                               b.NoOfGuests,
                               b.ModeOfPayment  AS Payment,
                               b.TotalAmount    AS Amount,
                               b.[Status],
                               b.DateCreated    AS BookedAt,
                               b.ApprovedAt,
                               b.Venue,
                               b.ServiceStyle
                        FROM   Bookings b
                        LEFT JOIN Packages p ON b.PackageID = p.PackageID
                        LEFT JOIN Users u ON u.UserID = @UserID
                        WHERE  b.UserID = @UserID
                           OR  (
                                ISNULL(LTRIM(RTRIM(u.PhoneNumber)), '') <> ''
                                AND
                                ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(b.PhoneNumber, ' ', ''), '-', ''), '(', ''), ')', ''), '')
                                =
                                ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(u.PhoneNumber, ' ', ''), '-', ''), '(', ''), ')', ''), '')
                               )
                           OR  (
                                ISNULL(LTRIM(RTRIM(u.Username)), '') <> ''
                                AND
                                LTRIM(RTRIM(ISNULL(b.ClientName, '')))
                                =
                                LTRIM(RTRIM(ISNULL(u.Username, '')))
                               )
                        ORDER  BY b.DateCreated DESC";

                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        using (var da = new SqlDataAdapter(cmd))
                            da.Fill(dt);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadBookingHistory error: " + ex.Message);
            }

            rptBookings.DataSource = dt;
            rptBookings.DataBind();
            lblBookingCount.Text = dt.Rows.Count + " booking" + (dt.Rows.Count != 1 ? "s" : "");
            phNoBookings.Visible = (dt.Rows.Count == 0);
        }

        // ─────────────────────────────────────────────────────────────────────
        // LOAD NOTIFICATIONS
        // ─────────────────────────────────────────────────────────────────────
        private void LoadNotifications()
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            var notifications = new List<NotificationRecord>();

            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    const string sql = @"
                        SELECT n.NotificationID, n.Message, n.DateCreated,
                               b.EventType, b.EventDate
                        FROM   Notifications n
                        LEFT JOIN Bookings b ON n.BookingID = b.BookingID
                        WHERE  n.UserID = @UserID
                        ORDER  BY n.DateCreated DESC";

                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID", userId);

                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                notifications.Add(new NotificationRecord
                                {
                                    NotificationID = Convert.ToInt32(reader["NotificationID"]),
                                    Message        = reader["Message"].ToString(),
                                    DateCreated    = Convert.ToDateTime(reader["DateCreated"]),
                                    EventType      = reader["EventType"]  == DBNull.Value ? "" : reader["EventType"].ToString(),
                                    EventDate      = reader["EventDate"]  == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["EventDate"])
                                });
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("LoadNotifications error: " + ex.Message);
            }

            rptNotifications.DataSource = notifications;
            rptNotifications.DataBind();

            int count = notifications.Count;
            lblNotifCount.Text    = count.ToString();
            lblNotifBadge.Text    = count.ToString();
            lblNotifBadge.Visible = count > 0;
            phNoNotifs.Visible    = count == 0;
        }

        // ─────────────────────────────────────────────────────────────────────
        // HELPER
        // ─────────────────────────────────────────────────────────────────────
        public string GetStatusClass(string status)
        {
            switch (status)
            {
                case "Approved":  return "status-upcoming";
                case "Pending":   return "status-pending";
                case "Completed": return "status-completed";
                case "Cancelled": return "status-cancelled";
                default:          return "";
            }
        }

        /// <summary>
        /// Returns the cancel button HTML based on 12-hour rule.
        /// </summary>
        public string GetCancelButton(object bookingIdObj, object statusObj, object approvedAtObj)
        {
            string status = statusObj?.ToString() ?? "";
            // Only Approved bookings can be cancelled, and only within 12 hours.
            if (status != "Approved")
                return "";

            DateTime approvedAt = (approvedAtObj != null && approvedAtObj != DBNull.Value)
                ? Convert.ToDateTime(approvedAtObj)
                : DateTime.MinValue;

            if (approvedAt == DateTime.MinValue)
            {
                return "<div class='booking-actions'>"
                     + "<button type='button' class='btn-cancel-booking btn-cancel-expired' disabled title='Approval timestamp is missing'>"
                     + "⛔ Cancellation Unavailable</button></div>";
            }

            double hoursElapsed = (DateTime.Now - approvedAt).TotalHours;
            int bookingId = Convert.ToInt32(bookingIdObj);

            if (hoursElapsed <= 12)
            {
                return $"<div class='booking-actions'>"
                     + $"<button type='button' class='btn-cancel-booking' onclick='openCancelModal({bookingId})'>"
                     + "Cancel Booking</button></div>";
            }

            return "<div class='booking-actions'>"
                 + "<button type='button' class='btn-cancel-booking btn-cancel-expired' disabled title='Cancellation window has expired (12 hours after approval)'>"
                 + "⛔ Cancellation Expired</button></div>";
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
        public DateTime? ApprovedAt { get; set; }
        public bool     CanCancel   =>
            Status == "Approved" &&
            ApprovedAt.HasValue &&
            (DateTime.Now - ApprovedAt.Value).TotalHours <= 12;
    }

    [Serializable]
    public class NotificationRecord
    {
        public int       NotificationID { get; set; }
        public string    Message        { get; set; }
        public DateTime  DateCreated    { get; set; }
        public string    EventType      { get; set; }
        public DateTime? EventDate      { get; set; }
    }
}
