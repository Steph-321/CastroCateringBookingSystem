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
    }
}
