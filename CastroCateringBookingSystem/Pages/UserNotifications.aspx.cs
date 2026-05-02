using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace CastroCateringBookingSystem.Pages
{
    public partial class UserNotifications : System.Web.UI.Page
    {
        string ConnStr = ConfigurationManager.ConnectionStrings["conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadNotifications();
            }
        }

        void LoadNotifications()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                string query = @"
                    SELECT Message, CreatedAt
                    FROM Notifications
                    WHERE UserID=@UserID
                    ORDER BY CreatedAt DESC";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@UserID", userId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvNotifications.DataSource = dt;
                gvNotifications.DataBind();

                // OPTIONAL: show latest notification popup
                if (dt.Rows.Count > 0)
                {
                    string latest = dt.Rows[0]["Message"].ToString();

                    ClientScript.RegisterStartupScript(this.GetType(),
                        "popup",
                        $"showNotification('{latest}');",
                        true);
                }
            }
        }
    }
}
