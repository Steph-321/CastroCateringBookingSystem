using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace CastroCateringBookingSystem.Pages
{
    public partial class Booking : Page
    {
        private static string ConnStr =>
            ConfigurationManager.ConnectionStrings["CastroDB"].ConnectionString;

        // ─────────────────────────────────────────────────────────────────────
        // PAGE LOAD
        // ─────────────────────────────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect to login if not authenticated
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Pages/LoginSignup.aspx");
                return;
            }
        }

        // ─────────────────────────────────────────────────────────────────────
        // CONFIRM BOOKING — triggered by asp:Button btnConfirm
        // ─────────────────────────────────────────────────────────────────────
        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            // ── Read ASP.NET server controls ──────────────────────────────────
            string clientName    = txtClientName.Text.Trim();
            string phoneNumber   = txtPhoneNumber.Text.Trim();
            string eventType     = ddlEventType.SelectedValue;
            string eventDateStr  = txtEventDate.Text.Trim();
            string guestCountStr = txtGuestCount.Text.Trim();
            string paymentMode   = ddlPaymentMode.SelectedValue;
            string venue         = txtVenue.Text.Trim();
            string venueLocation = ddlVenueLocation.SelectedValue;

            // ── Read hidden fields (set by JavaScript) ────────────────────────
            string serviceStyle  = hfServiceStyle.Value.Trim();
            string packageName   = hfPackageName.Value.Trim();
            string totalAmtStr   = hfTotalAmount.Value.Trim();

            // ── Server-side validation ────────────────────────────────────────
            if (string.IsNullOrWhiteSpace(clientName)   ||
                string.IsNullOrWhiteSpace(phoneNumber)  ||
                string.IsNullOrWhiteSpace(eventType)    ||
                string.IsNullOrWhiteSpace(eventDateStr) ||
                string.IsNullOrWhiteSpace(guestCountStr)||
                string.IsNullOrWhiteSpace(paymentMode)  ||
                string.IsNullOrWhiteSpace(venue)        ||
                string.IsNullOrWhiteSpace(venueLocation)||
                string.IsNullOrWhiteSpace(serviceStyle) ||
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

                    // Look up PackageID by name
                    int packageId = 0;
                    using (var pkgCmd = new SqlCommand(
                        "SELECT PackageID FROM Packages WHERE PackageName = @Name", conn))
                    {
                        pkgCmd.Parameters.AddWithValue("@Name", packageName);
                        object result = pkgCmd.ExecuteScalar();
                        if (result != null) packageId = Convert.ToInt32(result);
                    }

                    // Insert booking
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

                    // Pass booking ID and all receipt data to JS to show in the confirmation modal
                    string bookingRef      = "BK-" + newBookingId.ToString("D6");
                    string withinArgaoText = withinArgao ? "Yes - Within Argao" : "No - Outside Argao (+P2,500)";
                    string script = string.Format(@"
                        showConfirmationModal({{
                            bookingRef:    '{0}',
                            name:          {1},
                            phone:         {2},
                            eventType:     {3},
                            date:          {4},
                            venue:         {5},
                            guests:        {6},
                            packageName:   {7},
                            pricePerGuest: {8},
                            service:       {9},
                            payment:       {10},
                            total:         {11}
                        }});
                    ",
                        bookingRef,
                        J(clientName),
                        J(phoneNumber),
                        J(eventType),
                        J(eventDate.ToString("MMMM dd, yyyy")),
                        J(venue + " (" + withinArgaoText + ")"),
                        noOfGuests,
                        J(packageName),
                        J("\u20B1" + (totalAmount / noOfGuests).ToString("N0") + "/guest"),
                        J(serviceStyle),
                        J(paymentMode),
                        J("\u20B1" + totalAmount.ToString("N0"))
                    );
                    ClientScript.RegisterStartupScript(GetType(), "showModal", script, true);
                }
            }
            catch (Exception ex)
            {
                ShowError("A database error occurred: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Booking error: " + ex.Message);
            }
        }

        // ─────────────────────────────────────────────────────────────────────
        // HELPERS
        // ─────────────────────────────────────────────────────────────────────
        private void ShowError(string message)
        {
            lblBookingError.Text    = message;
            lblBookingError.Visible = true;
        }

        /// <summary>Wraps a C# string as a safe JavaScript string literal.</summary>
        private static string J(string s)
        {
            if (s == null) return "\"\"";
            return "\"" + s.Replace("\\", "\\\\")
                           .Replace("\"", "\\\"")
                           .Replace("\n", "\\n")
                           .Replace("\r", "\\r") + "\"";
        }
    }
}
