using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CastroCateringBookingSystem.Pages
{
    [Serializable]
    public class ReviewData
    {
        public string Name      { get; set; }
        public string EventType { get; set; }
        public string ReviewText{ get; set; }
        public int    Rating    { get; set; }
        public DateTime Date    { get; set; }
    }

    public partial class Reviews : Page
    {
        // ── In-memory store (lives for the page's ViewState lifetime) ──────────
        private List<ReviewData> ReviewList
        {
            get
            {
                if (ViewState["ReviewList"] == null)
                    ViewState["ReviewList"] = SeedReviews();
                return (List<ReviewData>)ViewState["ReviewList"];
            }
            set { ViewState["ReviewList"] = value; }
        }

        // Three pre-loaded reviews so the page never looks empty
        private static List<ReviewData> SeedReviews()
        {
            return new List<ReviewData>
            {
                new ReviewData
                {
                    Name       = "Maria Santos",
                    EventType  = "Wedding",
                    ReviewText = "Castro Catering made our wedding day absolutely perfect. The food was exquisite, the service was seamless, and every guest kept complimenting the spread. We couldn't have asked for more.",
                    Rating     = 5,
                    Date       = new DateTime(2026, 3, 15)
                },
                new ReviewData
                {
                    Name       = "Jose Reyes",
                    EventType  = "Corporate",
                    ReviewText = "We hired Castro Catering for our annual company dinner and they exceeded every expectation. Professional, punctual, and the food quality was outstanding. Will definitely book again.",
                    Rating     = 5,
                    Date       = new DateTime(2026, 2, 28)
                }
            };
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) BindReviews();
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtName.Text) ||
                string.IsNullOrWhiteSpace(txtReview.Text))
            {
                lblStatus.Text      = "Please fill in your name and review.";
                lblStatus.ForeColor = System.Drawing.Color.Red;
                return;
            }

            var list = ReviewList;
            list.Insert(0, new ReviewData
            {
                Name       = txtName.Text.Trim(),
                EventType  = ddlEventType.SelectedValue,
                ReviewText = txtReview.Text.Trim(),
                Rating     = GetRating(),
                Date       = DateTime.Now
            });
            ReviewList = list;

            BindReviews();
            ClearForm();
            lblStatus.Text      = "Thank you! Your review has been submitted.";
            lblStatus.ForeColor = System.Drawing.Color.Green;
        }

        private void BindReviews()
        {
            rptReviews.DataSource = ReviewList;
            rptReviews.DataBind();
            phEmpty.Visible = !ReviewList.Any();
        }

        // Must be public so <%# RenderStars(...) %> in the ItemTemplate can call it
        public string RenderStars(int rating)
        {
            string html = "";
            for (int i = 1; i <= 5; i++)
            {
                string color = i <= rating ? "var(--primary-gold)" : "#dbd3c9";
                html += $"<svg class='svg-gold-star' style='fill:{color}'><use href='#icon-star'/></svg>";
            }
            return html;
        }

        // Reads the hidden field that the JS syncs from the plain HTML radio buttons
        private int GetRating()
        {
            if (int.TryParse(hfRating.Value, out int r) && r >= 1 && r <= 5)
                return r;
            return 1;
        }

        private void ClearForm()
        {
            txtName.Text             = string.Empty;
            txtReview.Text           = string.Empty;
            ddlEventType.SelectedIndex = 0;
            hfRating.Value           = "1";
        }
    }
}
