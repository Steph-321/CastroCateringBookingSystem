using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace CastroCateringBookingSystem.Pages
{
    public partial class Booking : Page
    {
        private static string ConnStr =>
            ConfigurationManager.ConnectionStrings["conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Pages/LoginSignup.aspx");
                return;
            }
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            string clientName    = txtClientName.Text.Trim();
            string phoneNumber   = txtPhoneNumber.Text.Trim();
            string eventType     = ddlEventType.SelectedValue;
            string eventDateStr  = txtEventDate.Text.Trim();
            string guestCountStr = txtGuestCount.Text.Trim();
            string paymentMode   = ddlPaymentMode.SelectedValue;
            string venue         = txtVenue.Text.Trim();
            string venueLocation = ddlVenueLocation.SelectedValue;
            string serviceStyle  = hfServiceStyle.Value.Trim();
            string packageName   = hfPackageName.Value.Trim();
            string totalAmtStr   = hfTotalAmount.Value.Trim();

            if (string.IsNullOrWhiteSpace(clientName)    ||
                string.IsNullOrWhiteSpace(phoneNumber)   ||
                string.IsNullOrWhiteSpace(eventType)     ||
                string.IsNullOrWhiteSpace(eventDateStr)  ||
                string.IsNullOrWhiteSpace(guestCountStr) ||
                string.IsNullOrWhiteSpace(paymentMode)   ||
                string.IsNullOrWhiteSpace(venue)         ||
                string.IsNullOrWhiteSpace(venueLocation) ||
                string.IsNullOrWhiteSpace(serviceStyle)  ||
                string.IsNullOrWhiteSpace(packageName))
            {
                ShowError("Please fill in all required fields.");
                return;
            }

            if (!DateTime.TryParse(eventDateStr, out DateTime eventDate))
            {
                ShowError("Please enter a valid event date.");
                return;
            }

            if (!int.TryParse(guestCountStr, out int noOfGuests) || noOfGuests < 10)
            {
                ShowError("Number of guests must be at least 10.");
                return;
            }

            if (!decimal.TryParse(totalAmtStr, out decimal totalAmount))
            {
                ShowError("Could not calculate total amount. Please try again.");
                return;
            }

            bool withinArgao = venueLocation == "within";
            int  userId      = Convert.ToInt32(Session["UserID"]);

            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    int packageId = 0;
                    using (var pkgCmd = new SqlCommand(
                        "SELECT PackageID FROM Packages WHERE PackageName = @Name", conn))
                    {
                        pkgCmd.Parameters.AddWithValue("@Name", packageName);
                        object r = pkgCmd.ExecuteScalar();
                        if (r != null) packageId = Convert.ToInt32(r);
                    }

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

                    int newBookingId;
                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID",        userId);
                        cmd.Parameters.AddWithValue("@PackageID",     packageId);
                        cmd.Parameters.AddWithValue("@ClientName",    clientName);
                        cmd.Parameters.AddWithValue("@EventType",     eventType);
                        cmd.Parameters.AddWithValue("@EventDate",     eventDate);
                        cmd.Parameters.AddWithValue("@NoOfGuests",    noOfGuests);
                        cmd.Parameters.AddWithValue("@Venue",         venue);
                        cmd.Parameters.AddWithValue("@WithinArgao",   withinArgao);
                        cmd.Parameters.AddWithValue("@ServiceStyle",  serviceStyle);
                        cmd.Parameters.AddWithValue("@ModeOfPayment", paymentMode);
                        cmd.Parameters.AddWithValue("@TotalAmount",   totalAmount);
                        cmd.Parameters.AddWithValue("@PhoneNumber",   phoneNumber);
                        newBookingId = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    // ── Store receipt data in hidden server labels so JS can read them ──
                    string bookingRef = "BK-" + newBookingId.ToString("D6");
                    string argaoText  = withinArgao ? "Within Argao" : "Outside Argao (+\u20B12,500)";
                    decimal ppg       = noOfGuests > 0 ? totalAmount / noOfGuests : 0;

                    hfReceiptRef.Value     = bookingRef;
                    hfReceiptName.Value    = clientName;
                    hfReceiptPhone.Value   = phoneNumber;
                    hfReceiptEvent.Value   = eventType;
                    hfReceiptDate.Value    = eventDate.ToString("MMMM dd, yyyy");
                    hfReceiptVenue.Value   = venue + " (" + argaoText + ")";
                    hfReceiptGuests.Value  = noOfGuests.ToString();
                    hfReceiptPkg.Value     = packageName;
                    hfReceiptPPG.Value     = "\u20B1" + ppg.ToString("N0") + "/guest";
                    hfReceiptService.Value = serviceStyle;
                    hfReceiptPayment.Value = paymentMode;
                    hfReceiptTotal.Value   = "\u20B1" + totalAmount.ToString("N0");
                    hfShowReceipt.Value    = "1";   // ← signal JS to open modal
                }
            }
            catch (Exception ex)
            {
                ShowError("A database error occurred: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Booking error: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            lblBookingError.Text    = message;
            lblBookingError.Visible = true;
        }
    }
}
