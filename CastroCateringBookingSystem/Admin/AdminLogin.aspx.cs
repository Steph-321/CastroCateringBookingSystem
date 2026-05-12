using System;
using System.Web.UI;

namespace CastroCateringBookingSystem.Admin
{
    public partial class AdminLogin : Page
    {
        // ── Hardcoded admin credentials ──────────────────────────
        private const string AdminUsername = "admin";
        private const string AdminPassword = "admin123";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Handle sign out
            if (Request.QueryString["signout"] == "1")
            {
                Session.Clear();
                Session.Abandon();
                Response.Redirect("~/Admin/AdminLogin.aspx");
                return;
            }

            // If already logged in as admin, go straight to dashboard
            if (Session["IsAdmin"] != null && (bool)Session["IsAdmin"])
                Response.Redirect("~/Admin/AdminDashboard.aspx");
        }

        protected void btnAdminLogin_Click(object sender, EventArgs e)
        {
            string username = txtAdminUsername.Text.Trim();
            string password = txtAdminPassword.Text;

            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
            {
                ShowError("Username and password are required.");
                return;
            }

            if (username == AdminUsername && password == AdminPassword)
            {
                // Set admin session
                Session["IsAdmin"]       = true;
                Session["AdminUsername"] = username;

                Response.Redirect("~/Admin/AdminDashboard.aspx");
            }
            else
            {
                ShowError("Invalid admin credentials.");
            }
        }

        private void ShowError(string message)
        {
            lblStatus.Text    = message;
            lblStatus.CssClass = "val-msg status-err";
            lblStatus.Visible  = true;
        }
    }
}
