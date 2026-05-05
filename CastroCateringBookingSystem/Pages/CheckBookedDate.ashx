<%@ WebHandler Language="C#" Class="CastroCateringBookingSystem.Pages.CheckBookedDate" %>

using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;

namespace CastroCateringBookingSystem.Pages
{
    /// <summary>
    /// Returns {"booked": true/false} for a given date.
    /// A date is considered booked only when an Approved booking exists for it.
    /// Pending bookings do NOT block the date.
    /// </summary>
    public class CheckBookedDate : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            string dateStr = context.Request.QueryString["date"];
            if (string.IsNullOrWhiteSpace(dateStr))
            {
                context.Response.Write("{\"booked\":false}");
                return;
            }

            if (!DateTime.TryParse(dateStr, out DateTime eventDate))
            {
                context.Response.Write("{\"booked\":false}");
                return;
            }

            bool isBooked = false;

            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["conn"].ConnectionString;

                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // Only Approved bookings block the date
                    const string sql = @"
                        SELECT COUNT(1)
                        FROM   Bookings
                        WHERE  CAST(EventDate AS DATE) = @EventDate
                          AND  [Status] = 'Approved'";

                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@EventDate", eventDate.Date);
                        int count = (int)cmd.ExecuteScalar();
                        isBooked = count > 0;
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("CheckBookedDate error: " + ex.Message);
            }

            context.Response.Write(new JavaScriptSerializer()
                .Serialize(new { booked = isBooked }));
        }

        public bool IsReusable => false;
    }
}
