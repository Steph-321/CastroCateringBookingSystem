<%@ WebHandler Language="C#" Class="CastroCateringBookingSystem.Pages.SaveBooking" %>

using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;

namespace CastroCateringBookingSystem.Pages
{
    public class SaveBooking : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";

            try
            {
                // Read JSON body
                string body = new System.IO.StreamReader(context.Request.InputStream).ReadToEnd();
                var json = new JavaScriptSerializer();
                dynamic data = json.DeserializeObject(body);

                // Pull values from the JSON payload
                string clientName    = (string)data["clientName"];
                string phoneNumber   = (string)data["phoneNumber"];
                string eventType     = (string)data["eventType"];
                string eventDate     = (string)data["eventDate"];
                int    noOfGuests    = Convert.ToInt32(data["noOfGuests"]);
                string venue         = (string)data["venue"];
                bool   withinArgao   = Convert.ToBoolean(data["withinArgao"]);
                string serviceStyle  = (string)data["serviceStyle"];
                string packageName   = (string)data["packageName"];
                string modeOfPayment = (string)data["modeOfPayment"];
                decimal totalAmount  = Convert.ToDecimal(data["totalAmount"]);

                // Get UserID from session (set during login)
                int userId = 0;
                if (context.Session["UserID"] != null)
                    userId = Convert.ToInt32(context.Session["UserID"]);

                // Look up PackageID from Packages table by name
                int packageId = GetPackageId(packageName);

                string connStr = ConfigurationManager.ConnectionStrings["CastroDB"].ConnectionString;

                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    const string sql = @"
                        INSERT INTO Bookings 
                            (UserID, PackageID, ClientName, EventType, EventDate,
                             NoOfGuests, Venue, WithinArgao, ServiceStyle,
                             ModeOfPayment, TotalAmount, PhoneNumber, DateCreated, [Status])
                        VALUES
                            (@UserID, @PackageID, @ClientName, @EventType, @EventDate,
                             @NoOfGuests, @Venue, @WithinArgao, @ServiceStyle,
                             @ModeOfPayment, @TotalAmount, @PhoneNumber, GETDATE(), 'Upcoming');
                        SELECT SCOPE_IDENTITY();";

                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID",        userId);
                        cmd.Parameters.AddWithValue("@PackageID",     packageId);
                        cmd.Parameters.AddWithValue("@ClientName",    clientName);
                        cmd.Parameters.AddWithValue("@EventType",     eventType);
                        cmd.Parameters.AddWithValue("@EventDate",     DateTime.Parse(eventDate));
                        cmd.Parameters.AddWithValue("@NoOfGuests",    noOfGuests);
                        cmd.Parameters.AddWithValue("@Venue",         venue);
                        cmd.Parameters.AddWithValue("@WithinArgao",   withinArgao);
                        cmd.Parameters.AddWithValue("@ServiceStyle",  serviceStyle);
                        cmd.Parameters.AddWithValue("@ModeOfPayment", modeOfPayment);
                        cmd.Parameters.AddWithValue("@TotalAmount",   totalAmount);
                        cmd.Parameters.AddWithValue("@PhoneNumber",   phoneNumber);

                        int newBookingId = Convert.ToInt32(cmd.ExecuteScalar());

                        context.Response.Write(
                            json.Serialize(new { success = true, bookingId = newBookingId }));
                    }
                }
            }
            catch (Exception ex)
            {
                context.Response.Write(
                    new JavaScriptSerializer().Serialize(
                        new { success = false, error = ex.Message }));
            }
        }

        private int GetPackageId(string packageName)
        {
            string connStr = ConfigurationManager.ConnectionStrings["CastroDB"].ConnectionString;
            using (var conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (var cmd = new SqlCommand(
                    "SELECT PackageID FROM Packages WHERE PackageName = @Name", conn))
                {
                    cmd.Parameters.AddWithValue("@Name", packageName);
                    object result = cmd.ExecuteScalar();
                    return result != null ? Convert.ToInt32(result) : 0;
                }
            }
        }

        public bool IsReusable => false;
    }
}
