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
            string withinArgaoVal = withinArgao ? "Yes" : "No";

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
                        cmd.Parameters.AddWithValue("@WithinArgao",   withinArgaoVal);
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

                    // Escape strings for safe JS embedding
                    string script = string.Format(@"
                        (function() {{
                            document.getElementById('modalBookingId').textContent = {0};
                            document.getElementById('rcptName').textContent       = {1};
                            document.getElementById('rcptPhone').textContent      = {2};
                            document.getElementById('rcptEventType').textContent  = {3};
                            document.getElementById('rcptDate').textContent       = {4};
                            document.getElementById('rcptVenue').textContent      = {5};
                            document.getElementById('rcptGuests').textContent     = {6} + ' guests';
                            document.getElementById('rcptPackage').textContent    = {7};
                            document.getElementById('rcptPricePerGuest').textContent = {8};
                            document.getElementById('rcptService').textContent   = {9};
                            document.getElementById('rcptPayment').textContent   = {10};
                            document.getElementById('rcptStatus').textContent    = 'Pending Approval';
                            document.getElementById('rcptTimestamp').textContent = {11};
                            document.getElementById('rcptSubtotal').textContent  = {12};
                            document.getElementById('rcptServiceFee').textContent  = 'Included';
                            document.getElementById('rcptLocationFee').textContent = 'Included';
                            document.getElementById('rcptTotal').textContent     = {12};
                            document.getElementById('rcptRowWeekend').style.display = 'none';
                            document.getElementById('rcptRowRush').style.display    = 'none';
                            document.getElementById('modalOverlay').classList.add('open');
                            document.body.style.overflow = 'hidden';
                        }})();",
                        JsStr(bookingRef),
                        JsStr(clientName),
                        JsStr(phoneNumber),
                        JsStr(eventType),
                        JsStr(eventDate.ToString("MMMM dd, yyyy")),
                        JsStr(venue + " (" + argaoText + ")"),
                        JsStr(noOfGuests.ToString()),
                        JsStr(packageName),
                        JsStr(ppgFmt),
                        JsStr(serviceStyle),
                        JsStr(paymentMode),
                        JsStr(issuedAt),
                        JsStr(totalFmt)
                    );

                    ScriptManager.RegisterStartupScript(this, GetType(), "showReceipt", script, true);
                }
            }
            catch (Exception ex)
            {
                ShowError("A database error occurred: " + ex.Message);
                System.Diagnostics.Debug.WriteLine("Booking error: " + ex.Message);
            }
        }

        /// <summary>Encodes a string as a safe JS string literal (double-quoted).</summary>
        private static string JsStr(string s)
        {
            if (s == null) return "\"\"";
            return "\"" + s.Replace("\\", "\\\\")
                           .Replace("\"", "\\\"")
                           .Replace("\r", "")
                           .Replace("\n", "\\n") + "\"";
        }

        private void ShowError(string message)
        {
            lblBookingError.Text    = "⚠ " + message;
            lblBookingError.Visible = true;
            lblBookingError.ForeColor = System.Drawing.Color.FromArgb(0xD9, 0x26, 0x26);
        }
    }
}
