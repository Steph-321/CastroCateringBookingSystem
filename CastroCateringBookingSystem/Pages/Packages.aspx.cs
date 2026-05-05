using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace CastroCateringBookingSystem.Pages
{
    public partial class Packages : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadPackages();
            }
        }

        private void LoadPackages()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        PackageID,
                        PackageName,
                        Description,
                        RatePerGuest,
                        MinGuests,
                        MaxGuests,
                        Category,
                        Inclusions,
                        ImagePath
                    FROM Packages
                    ORDER BY PackageID DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptPackages.DataSource = dt;
                rptPackages.DataBind();
            }
        }

        /// <summary>
        /// Splits the Category string by comma and returns one badge span per category.
        /// </summary>
        public string RenderCategories(string category)
        {
            if (string.IsNullOrWhiteSpace(category))
                return "";

            var items = category.Split(new[] { ',', ';' },
                                       StringSplitOptions.RemoveEmptyEntries);
            string html = "";
            foreach (var item in items)
            {
                string trimmed = item.Trim();
                if (!string.IsNullOrEmpty(trimmed))
                    html += "<span class=\"package-category\">"
                            + System.Web.HttpUtility.HtmlEncode(trimmed)
                            + "</span>";
            }
            return html;
        }

        /// <summary>
        /// Splits the Inclusions string by comma or newline and returns one li per item.
        /// </summary>
        public string RenderInclusions(string inclusions)
        {
            if (string.IsNullOrWhiteSpace(inclusions))
                return "<li>—</li>";

            // Support both comma-separated and newline-separated values
            var separators = new[] { ',', '\n', '\r' };
            var items = inclusions.Split(separators, StringSplitOptions.RemoveEmptyEntries);

            var html = "";
            foreach (var item in items)
            {
                string trimmed = item.Trim();
                if (!string.IsNullOrEmpty(trimmed))
                    html += "<li>" + System.Web.HttpUtility.HtmlEncode(trimmed) + "</li>";
            }

            return string.IsNullOrEmpty(html) ? "<li>—</li>" : html;
        }
    }
}
