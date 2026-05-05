<%@ WebHandler Language="C#" Class="CastroCateringBookingSystem.Pages.CancelBooking" %>

using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.SessionState;

namespace CastroCateringBookingSystem.Pages
{
    public class CancelBooking : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            var json = new JavaScriptSerializer();

            try
            {
                // Must be logged in
                if (context.Session["UserID"] == null)
                {
                    context.Response.Write(json.Serialize(new { success = false, message = "Not logged in." }));
                    return;
                }

                int userId    = Convert.ToInt32(context.Session["UserID"]);
                int bookingId = Convert.ToInt32(context.Request.Form["bookingId"]);

                if (bookingId <= 0)
                {
                    context.Response.Write(json.Serialize(new { success = false, message = "Invalid booking ID." }));
                    return;
                }

                string connStr = ConfigurationManager.ConnectionStrings["conn"].ConnectionString;

                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Read current status and ownership
                    string currentStatus = null;
                    DateTime? approvedAt = null;

                    using (var cmd = new SqlCommand(
                        "SELECT [Status], ApprovedAt FROM Bookings WHERE BookingID=@BID AND UserID=@UID", conn))
                    {
                        cmd.Parameters.AddWithValue("@BID", bookingId);
                        cmd.Parameters.AddWithValue("@UID", userId);
                        using (var r = cmd.ExecuteReader())
                        {
                            if (r.Read())
                            {
                                currentStatus = r["Status"].ToString();
                                approvedAt    = r["ApprovedAt"] == DBNull.Value
                                    ? (DateTime?)null
                                    : Convert.ToDateTime(r["ApprovedAt"]);
                            }
                        }
                    }

                    if (currentStatus == null)
                    {
                        context.Response.Write(json.Serialize(new { success = false, message = "Booking not found or does not belong to you." }));
                        return;
                    }

                    if (currentStatus == "Cancelled" || currentStatus == "Completed")
                    {
                        context.Response.Write(json.Serialize(new { success = false, message = "This booking cannot be cancelled." }));
                        return;
                    }

                    // Approved — enforce 12-hour window
                    if (currentStatus == "Approved" && approvedAt.HasValue)
                    {
                        double hours = (DateTime.Now - approvedAt.Value).TotalHours;
                        if (hours > 12)
                        {
                            context.Response.Write(json.Serialize(new { success = false, message = "Cancellation window has expired. You can only cancel within 12 hours of approval." }));
                            return;
                        }
                    }

                    // Cancel it
                    using (var cmd = new SqlCommand(
                        "UPDATE Bookings SET [Status]='Cancelled' WHERE BookingID=@BID AND UserID=@UID", conn))
                    {
                        cmd.Parameters.AddWithValue("@BID", bookingId);
                        cmd.Parameters.AddWithValue("@UID", userId);
                        cmd.ExecuteNonQuery();
                    }

                    // Insert notification
                    using (var cmd = new SqlCommand(@"
                        INSERT INTO Notifications (UserID, BookingID, Message, DateCreated)
                        VALUES (@UID, @BID, @MSG, GETDATE())", conn))
                    {
                        cmd.Parameters.AddWithValue("@UID", userId);
                        cmd.Parameters.AddWithValue("@BID", bookingId);
                        cmd.Parameters.AddWithValue("@MSG", "Your booking #BK-" + bookingId.ToString("D6") + " has been cancelled.");
                        cmd.ExecuteNonQuery();
                    }
                }

                context.Response.Write(json.Serialize(new { success = true }));
            }
            catch (Exception ex)
            {
                context.Response.Write(json.Serialize(new { success = false, message = ex.Message }));
            }
        }

        public bool IsReusable => false;
    }
}
