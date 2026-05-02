using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace CastroCateringBookingSystem.Pages
{
    public partial class CalendarPage : System.Web.UI.Page
    {
        private static string ConnStr =>
            ConfigurationManager.ConnectionStrings["conn"].ConnectionString;

        // Which month/year the calendar is currently showing
        public DateTime ViewDate
        {
            get => ViewState["ViewDate"] == null
                       ? new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1)
                       : (DateTime)ViewState["ViewDate"];
            set => ViewState["ViewDate"] = value;
        }

        // The date the user has highlighted
        public DateTime? SelectedDate
        {
            get  => (DateTime?)ViewState["SelectedDate"];
            set  => ViewState["SelectedDate"] = value;
        }

        // ─────────────────────────────────────────────────────────────────────
        // PAGE LOAD
        // ─────────────────────────────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) RenderCalendar();
        }

        // ─────────────────────────────────────────────────────────────────────
        // LOAD BOOKED DATES FROM DATABASE
        // ─────────────────────────────────────────────────────────────────────
        private List<DateTime> GetBookedDates()
        {
            var dates = new List<DateTime>();
            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();
                    // Get all upcoming/confirmed event dates from Bookings table
                    const string sql = @"
                        SELECT DISTINCT CAST(EventDate AS DATE)
                        FROM   Bookings
                        WHERE  [Status] IN ('Upcoming')";

                    using (var cmd = new SqlCommand(sql, conn))
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                            dates.Add(Convert.ToDateTime(reader[0]).Date);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("GetBookedDates error: " + ex.Message);
            }
            return dates;
        }

        // ─────────────────────────────────────────────────────────────────────
        // "Book This Date" clicked — redirect to Booking page with date pre-filled
        // ─────────────────────────────────────────────────────────────────────
        protected void btnBook_Click(object sender, EventArgs e)
        {
            if (!SelectedDate.HasValue) return;

            // Redirect to Booking page with the selected date as a query param
            string dateStr = SelectedDate.Value.ToString("yyyy-MM-dd");
            Response.Redirect("~/Pages/Booking.aspx?date=" + dateStr);
        }

        // ─────────────────────────────────────────────────────────────────────
        // DAY CELL CLICKED
        // ─────────────────────────────────────────────────────────────────────
        protected void rptCalendar_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "SelectDay") return;
            if (!int.TryParse(e.CommandArgument.ToString(), out int day)) return;

            DateTime clicked = new DateTime(ViewDate.Year, ViewDate.Month, day);

            if (clicked.Date < DateTime.Today) return;

            var bookedDates = GetBookedDates();
            if (bookedDates.Contains(clicked.Date)) return;

            SelectedDate          = clicked;
            lblSelection.Text     = "Selected: " + clicked.ToString("MMMM dd, yyyy");
            pnlBooking.Visible    = true;
            RenderCalendar();
        }

        protected void btnPrev_Click(object sender, EventArgs e)
        {
            DateTime prev = ViewDate.AddMonths(-1);
            if (prev >= new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1))
                ViewDate = prev;
            RenderCalendar();
        }

        protected void btnNext_Click(object sender, EventArgs e)
        {
            ViewDate = ViewDate.AddMonths(1);
            RenderCalendar();
        }

        // ─────────────────────────────────────────────────────────────────────
        // RENDER CALENDAR GRID
        // ─────────────────────────────────────────────────────────────────────
        private void RenderCalendar()
        {
            lblMonthYear.Text = ViewDate.ToString("MMMM yyyy");

            var bookedDates  = GetBookedDates();
            var days         = new List<CalendarDay>();
            var firstOfMonth = new DateTime(ViewDate.Year, ViewDate.Month, 1);
            int startOffset  = (int)firstOfMonth.DayOfWeek;
            int daysInMonth  = DateTime.DaysInMonth(ViewDate.Year, ViewDate.Month);

            for (int i = 0; i < startOffset; i++)
                days.Add(new CalendarDay { DayNumber = "", CssClass = "day-cell empty", IsAvailable = false });

            for (int d = 1; d <= daysInMonth; d++)
                days.Add(GetDayDetails(new DateTime(ViewDate.Year, ViewDate.Month, d), d, bookedDates));

            rptCalendar.DataSource = days;
            rptCalendar.DataBind();
        }

        private CalendarDay GetDayDetails(DateTime date, int dayNum, List<DateTime> bookedDates)
        {
            string css    = "day-cell";
            string status = "";
            bool canSelect = true;

            if (bookedDates.Contains(date.Date))
            {
                css       += " booked";
                status     = "BOOKED";
                canSelect  = false;
            }
            else if (date.Date < DateTime.Today)
            {
                css       += " past";
                canSelect  = false;
            }
            else
            {
                css += " available";
            }

            if (date.Date == DateTime.Today) css += " today";
            if (SelectedDate.HasValue && date.Date == SelectedDate.Value.Date) css += " selected";

            return new CalendarDay
            {
                DayNumber   = dayNum.ToString(),
                CssClass    = css,
                Status      = status,
                IsAvailable = canSelect
            };
        }
    }

    [Serializable]
    public class CalendarDay
    {
        public string DayNumber   { get; set; }
        public string CssClass    { get; set; }
        public string Status      { get; set; }
        public bool   IsAvailable { get; set; }
    }
}
