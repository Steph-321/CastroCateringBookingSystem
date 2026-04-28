using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CastroCateringBookingSystem.Pages
{
    public partial class Reviews : Page
    {
        private static string ConnStr =>
            ConfigurationManager.ConnectionStrings["CastroDB"].ConnectionString;

        // ─────────────────────────────────────────────────────────────────────
        // PAGE LOAD
        // ─────────────────────────────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) BindReviews();
        }

        // ─────────────────────────────────────────────────────────────────────
        // SUBMIT REVIEW
        // ─────────────────────────────────────────────────────────────────────
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtReview.Text))
            {
                lblStatus.Text      = "Please write your review before submitting.";
                lblStatus.ForeColor = System.Drawing.Color.Red;
                return;
            }

            if (ddlEventType.SelectedValue == "")
            {
                lblStatus.Text      = "Please select an event type.";
                lblStatus.ForeColor = System.Drawing.Color.Red;
                return;
            }

            int rating = GetRating();

            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    // Get UserID from session if logged in (nullable — reviews can be anonymous)
                    object userId = Session["UserID"] != null
                        ? (object)Convert.ToInt32(Session["UserID"])
                        : DBNull.Value;

                    const string sql = @"
                        INSERT INTO Reviews (UserID, EventType, Rating, [Comment], DateCreated)
                        VALUES (@UserID, @EventType, @Rating, @Comment, GETDATE())";

                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@UserID",    userId);
                        cmd.Parameters.AddWithValue("@EventType", ddlEventType.SelectedValue);
                        cmd.Parameters.AddWithValue("@Comment",   txtReview.Text.Trim());
                        cmd.Parameters.AddWithValue("@Rating",    rating);

                        cmd.ExecuteNonQuery();
                    }
                }

                BindReviews();
                ClearForm();
                lblStatus.Text      = "Thank you! Your review has been submitted.";
                lblStatus.ForeColor = System.Drawing.Color.Green;
            }
            catch (Exception ex)
            {
                lblStatus.Text      = "Error saving review: " + ex.Message;
                lblStatus.ForeColor = System.Drawing.Color.Red;
                System.Diagnostics.Debug.WriteLine("Review error: " + ex.Message);
            }
        }

        // ─────────────────────────────────────────────────────────────────────
        // BIND REVIEWS FROM DATABASE
        // ─────────────────────────────────────────────────────────────────────
        private void BindReviews()
        {
            var reviews = new List<ReviewData>();

            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    const string sql = @"
                        SELECT TOP 50
                            u.Username  AS [Name],
                            r.EventType,
                            r.[Comment] AS ReviewText,
                            r.Rating,
                            r.DateCreated AS [Date]
                        FROM   Reviews r
                        LEFT JOIN Users u ON r.UserID = u.UserID
                        ORDER  BY r.DateCreated DESC";

                    using (var cmd = new SqlCommand(sql, conn))
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            reviews.Add(new ReviewData
                            {
                                Name       = reader["Name"].ToString(),
                                EventType  = reader["EventType"].ToString(),
                                ReviewText = reader["ReviewText"].ToString(),
                                Rating     = Convert.ToInt32(reader["Rating"]),
                                Date       = Convert.ToDateTime(reader["Date"])
                            });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("BindReviews error: " + ex.Message);
                // Fall back to seed data if DB not available
                reviews = GetSeedReviews();
            }

            // If DB is empty, show seed reviews
            if (reviews.Count == 0) reviews = GetSeedReviews();

            rptReviews.DataSource = reviews;
            rptReviews.DataBind();
            phEmpty.Visible = (reviews.Count == 0);
        }

        // ─────────────────────────────────────────────────────────────────────
        // HELPERS
        // ─────────────────────────────────────────────────────────────────────

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

        private int GetRating()
        {
            if (int.TryParse(hfRating.Value, out int r) && r >= 1 && r <= 5)
                return r;
            return 1;
        }

        private void ClearForm()
        {
            txtName.Text               = string.Empty;
            txtReview.Text             = string.Empty;
            ddlEventType.SelectedIndex = 0;
            hfRating.Value             = "1";
        }

        private static List<ReviewData> GetSeedReviews()
        {
            return new List<ReviewData>
            {
                new ReviewData { Name = "Maria Santos",    EventType = "Wedding",   ReviewText = "Castro Catering made our wedding day absolutely perfect. The food was exquisite, the service was seamless, and every guest kept complimenting the spread.", Rating = 5, Date = new DateTime(2026, 3, 15) },
                new ReviewData { Name = "Jose Reyes",      EventType = "Corporate", ReviewText = "We hired Castro Catering for our annual company dinner and they exceeded every expectation. Professional, punctual, and the food quality was outstanding.", Rating = 5, Date = new DateTime(2026, 2, 28) },
            };
        }
    }

    [Serializable]
    public class ReviewData
    {
        public string   Name       { get; set; }
        public string   EventType  { get; set; }
        public string   ReviewText { get; set; }
        public int      Rating     { get; set; }
        public DateTime Date       { get; set; }
    }
}
