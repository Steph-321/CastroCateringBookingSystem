using System;
using System.Configuration;
using System.Data;
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

            if (!IsPostBack)
            {
                LoadPackageCards();
            }
        }

        // ── LOAD PACKAGES FROM DB INTO CARDS ─────────────────────
        private void LoadPackageCards()
        {
            using (var conn = new SqlConnection(ConnStr))
            {
                const string sql = @"
                    SELECT PackageName, RatePerGuest
                    FROM   Packages
                    ORDER  BY PackageID ASC";

                var da = new SqlDataAdapter(sql, conn);
                var dt = new DataTable();
                da.Fill(dt);

                rptPackageCards.DataSource = dt;
                rptPackageCards.DataBind();
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
            string moaAccepted   = hfMOAAccepted.Value.Trim();

            // ── Debug: surface exactly which field is missing ──
            var missing = new System.Collections.Generic.List<string>();
            if (string.IsNullOrWhiteSpace(clientName))    missing.Add("clientName");
            if (string.IsNullOrWhiteSpace(phoneNumber))   missing.Add("phoneNumber");
            if (string.IsNullOrWhiteSpace(eventType))     missing.Add("eventType");
            if (string.IsNullOrWhiteSpace(eventDateStr))  missing.Add("eventDate");
            if (string.IsNullOrWhiteSpace(guestCountStr)) missing.Add("guestCount");
            if (string.IsNullOrWhiteSpace(paymentMode))   missing.Add("paymentMode");
            if (string.IsNullOrWhiteSpace(venue))         missing.Add("venue");
            if (string.IsNullOrWhiteSpace(venueLocation)) missing.Add("venueLocation");
            if (string.IsNullOrWhiteSpace(serviceStyle))  missing.Add("serviceStyle[hf=" + hfServiceStyle.Value + "]");
            if (string.IsNullOrWhiteSpace(packageName))   missing.Add("packageName[hf=" + hfPackageName.Value + "]");

            if (missing.Count > 0)
            {
                ShowError("Missing fields: " + string.Join(", ", missing));
                return;
            }

            if (!string.Equals(moaAccepted, "1", StringComparison.Ordinal))
            {
                ShowError("You must agree to the Memorandum of Agreement before confirming your booking.");
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

            // Parse total — fall back to 0 if JS didn't write it (shouldn't happen)
            if (!decimal.TryParse(totalAmtStr,
                    System.Globalization.NumberStyles.Any,
                    System.Globalization.CultureInfo.InvariantCulture,
                    out decimal totalAmount))
            {
                totalAmount = 0;
            }

            bool withinArgao  = venueLocation == "within";
            int  userId       = Convert.ToInt32(Session["UserID"]);

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
                    if (packageId <= 0)
                    {
                        ShowError("Selected package is invalid. Please select a package again.");
                        return;
                    }

                    const string sql = @"
                        INSERT INTO Bookings
                            (UserID, PackageID, ClientName, EventType, EventDate,
                             NoOfGuests, Venue, WithinArgao, ServiceStyle,
                             ModeOfPayment, TotalAmount, PhoneNumber, DateCreated, [Status])
                        VALUES
                            (@UserID, @PackageID, @ClientName, @EventType, @EventDate,
                             @NoOfGuests, @Venue, @WithinArgao, @ServiceStyle,
                             @ModeOfPayment, @TotalAmount, @PhoneNumber, GETDATE(), 'Pending');
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

                    // ── Build receipt data and inject directly via startup script ──
                    string bookingRef = "BK-" + newBookingId.ToString("D6");
                    string argaoText  = withinArgao ? "Within Argao" : "Outside Argao (+\u20B12,500)";
                    decimal ppg       = noOfGuests > 0 ? totalAmount / noOfGuests : 0;
                    string totalFmt   = "\u20B1" + totalAmount.ToString("N0");
                    string ppgFmt     = "\u20B1" + ppg.ToString("N0") + "/guest";
                    string issuedAt   = DateTime.Now.ToString("MMM dd, yyyy h:mm tt");

                    // Write receipt data to hidden fields; page JS reads these and opens the modal.
                    hfShowReceipt.Value    = "1";
                    hfReceiptRef.Value     = bookingRef;
                    hfReceiptName.Value    = clientName;
                    hfReceiptPhone.Value   = phoneNumber;
                    hfReceiptEvent.Value   = eventType;
                    hfReceiptDate.Value    = eventDate.ToString("MMMM dd, yyyy");
                    hfReceiptVenue.Value   = venue + " (" + argaoText + ")";
                    hfReceiptGuests.Value  = noOfGuests.ToString();
                    hfReceiptPkg.Value     = packageName;
                    hfReceiptPPG.Value     = ppgFmt;
                    hfReceiptService.Value = serviceStyle;
                    hfReceiptPayment.Value = paymentMode;
                    hfReceiptTotal.Value   = totalFmt;
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
            lblBookingError.Text    = "⚠ " + message;
            lblBookingError.Visible = true;
            lblBookingError.ForeColor = System.Drawing.Color.FromArgb(0xD9, 0x26, 0x26);
        }
    }
}
