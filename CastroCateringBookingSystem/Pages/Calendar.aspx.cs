using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;

namespace CastroCateringBookingSystem.Pages
{
    public partial class CalendarPage : System.Web.UI.Page
    {
        // Which month/year the calendar is currently showing
        public DateTime ViewDate
        {
            get => ViewState["ViewDate"] == null
                       ? new DateTime(DateTime.Today.Year, DateTime.Today.Month, 1)
                       : (DateTime)ViewState["ViewDate"];
            set => ViewState["ViewDate"] = value;
        }

        // The date the user has highlighted (tan/gold)
        public DateTime? SelectedDate
        {
            get  => (DateTime?)ViewState["SelectedDate"];
            set  => ViewState["SelectedDate"] = value;
        }

        // Simulated booked-dates store — replace with a DB query in production
        public List<DateTime> BookedDates
        {
            get
            {
                if (ViewState["BookedDates"] == null)
                    ViewState["BookedDates"] = new List<DateTime>();
                return (List<DateTime>)ViewState["BookedDates"];
            }
            set => ViewState["BookedDates"] = value;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) RenderCalendar();
        }

        // "Book This Date" clicked
        protected void btnBook_Click(object sender, EventArgs e)
        {
            if (!SelectedDate.HasValue) return;

            var dates = BookedDates;
            if (!dates.Contains(SelectedDate.Value.Date))
            {
                dates.Add(SelectedDate.Value.Date);
                BookedDates = dates;
            }

            SelectedDate       = null;
            pnlBooking.Visible = false;
            RenderCalendar();
        }

        // A day cell was clicked
        protected void rptCalendar_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "SelectDay") return;

            if (!int.TryParse(e.CommandArgument.ToString(), out int day)) return;

            DateTime clicked = new DateTime(ViewDate.Year, ViewDate.Month, day);

            // Ignore past dates and already-booked dates
            if (clicked.Date < DateTime.Today) return;
            if (BookedDates.Contains(clicked.Date)) return;

            SelectedDate          = clicked;
            lblSelection.Text     = "Selected: " + clicked.ToString("MMMM dd, yyyy");
            pnlBooking.Visible    = true;
            RenderCalendar();
        }

        protected void btnPrev_Click(object sender, EventArgs e)
        {
            // Don't navigate before the current month
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

        private void RenderCalendar()
        {
            lblMonthYear.Text = ViewDate.ToString("MMMM yyyy");

            var days = new List<CalendarDay>();
            var firstOfMonth = new DateTime(ViewDate.Year, ViewDate.Month, 1);
            int startOffset  = (int)firstOfMonth.DayOfWeek;
            int daysInMonth  = DateTime.DaysInMonth(ViewDate.Year, ViewDate.Month);

            // Empty cells before the 1st
            for (int i = 0; i < startOffset; i++)
                days.Add(new CalendarDay { DayNumber = "", CssClass = "day-cell empty", IsAvailable = false });

            for (int d = 1; d <= daysInMonth; d++)
                days.Add(GetDayDetails(new DateTime(ViewDate.Year, ViewDate.Month, d), d));

            rptCalendar.DataSource = days;
            rptCalendar.DataBind();
        }

        private CalendarDay GetDayDetails(DateTime date, int dayNum)
        {
            string css    = "day-cell";
            string status = "";
            bool canSelect = true;

            if (BookedDates.Contains(date.Date))
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

            if (date.Date == DateTime.Today)
                css += " today";

            if (SelectedDate.HasValue && date.Date == SelectedDate.Value.Date)
                css += " selected";

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
