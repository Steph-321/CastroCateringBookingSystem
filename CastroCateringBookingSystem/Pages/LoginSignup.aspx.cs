using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CastroCateringBookingSystem.Pages
{
    public partial class LoginSignup : Page
    {
        private static string ConnStr =>
            ConfigurationManager.ConnectionStrings["CastroDB"].ConnectionString;

        // ─────────────────────────────────────────────────────────────────────
        // PAGE LOAD
        // ─────────────────────────────────────────────────────────────────────
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) return;
            ClearStatus(lblLoginStatus);
            ClearStatus(lblRegStatus);
        }

        // ─────────────────────────────────────────────────────────────────────
        // LOGIN
        // ─────────────────────────────────────────────────────────────────────
        protected void btnLogin_Click(object sender, EventArgs e)
        {
            hfActivePanel.Value = "login";

            string username = txtLoginUsername.Text.Trim();
            string password = txtLoginPassword.Text;

            if (string.IsNullOrWhiteSpace(username) || string.IsNullOrWhiteSpace(password))
            {
                SetStatus(lblLoginStatus, "Username and password are required.", false);
                return;
            }

            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    const string sql = @"
                        SELECT UserID, Username, Email, PhoneNumber, [Address]
                        FROM   Users
                        WHERE  Username  = @Username
                          AND  [Password] = @Password";

                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Username", username);
                        cmd.Parameters.AddWithValue("@Password", HashPassword(password));

                        using (var reader = cmd.ExecuteReader())
                        {
                            if (!reader.Read())
                            {
                                SetStatus(lblLoginStatus, "Invalid username or password.", false);
                                return;
                            }

                            // Store user data in session
                            Session["Username"] = reader["Username"].ToString();
                            Session["UserID"]   = reader["UserID"].ToString();

                            // Pass to client so localStorage is populated
                            RedirectWithUser(
                                reader["Username"].ToString(),
                                reader["Email"].ToString(),
                                reader["PhoneNumber"].ToString(),
                                reader["Address"].ToString()
                            );
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                SetStatus(lblLoginStatus, "A database error occurred. Please try again.", false);
                System.Diagnostics.Debug.WriteLine("Login error: " + ex.Message);
            }
        }

        // ─────────────────────────────────────────────────────────────────────
        // REGISTER
        // ─────────────────────────────────────────────────────────────────────
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            hfActivePanel.Value = "signup";

            string username = txtRegUsername.Text.Trim();
            string email    = txtRegEmail.Text.Trim();
            string password = txtRegPassword.Text;
            string phone    = txtRegPhone.Text.Trim();
            string address  = txtRegAddress.Text.Trim();

            // Basic required-field check
            if (string.IsNullOrWhiteSpace(username) ||
                string.IsNullOrWhiteSpace(email)    ||
                string.IsNullOrWhiteSpace(password) ||
                string.IsNullOrWhiteSpace(phone)    ||
                string.IsNullOrWhiteSpace(address))
            {
                SetStatus(lblRegStatus, "All fields are required.", false);
                return;
            }

            try
            {
                using (var conn = new SqlConnection(ConnStr))
                {
                    conn.Open();

                    // Check if username or email already exists
                    const string checkSql = @"
                        SELECT COUNT(1) FROM Users
                        WHERE Username = @Username OR Email = @Email";

                    using (var checkCmd = new SqlCommand(checkSql, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@Username", username);
                        checkCmd.Parameters.AddWithValue("@Email",    email);

                        int existing = (int)checkCmd.ExecuteScalar();
                        if (existing > 0)
                        {
                            SetStatus(lblRegStatus, "That username or email is already taken.", false);
                            return;
                        }
                    }

                    // Insert new user and get the new UserID
                    const string insertSql = @"
                        INSERT INTO Users (Username, Email, [Password], PhoneNumber, [Address])
                        VALUES (@Username, @Email, @Password, @Phone, @Address);
                        SELECT SCOPE_IDENTITY();";

                    using (var insertCmd = new SqlCommand(insertSql, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@Username", username);
                        insertCmd.Parameters.AddWithValue("@Email",    email);
                        insertCmd.Parameters.AddWithValue("@Password", HashPassword(password));
                        insertCmd.Parameters.AddWithValue("@Phone",    phone);
                        insertCmd.Parameters.AddWithValue("@Address",  address);

                        int newUserId = Convert.ToInt32(insertCmd.ExecuteScalar());
                        Session["UserID"] = newUserId;
                    }
                }

                Session["Username"] = username;
                RedirectWithUser(username, email, phone, address);
            }
            catch (Exception ex)
            {
                SetStatus(lblRegStatus, "Error: " + ex.Message, false);
                System.Diagnostics.Debug.WriteLine("Register error: " + ex.Message);
            }
        }

        // ─────────────────────────────────────────────────────────────────────
        // HELPERS
        // ─────────────────────────────────────────────────────────────────────

        /// <summary>
        /// Injects a startup script that writes the user object to localStorage
        /// then redirects to Home.aspx — so the client always has the user data.
        /// </summary>
        private void RedirectWithUser(string username, string email, string phone, string address)
        {
            string script = $@"
                var user = {{
                    username: {J(username)},
                    email:    {J(email)},
                    phone:    {J(phone)},
                    address:  {J(address)}
                }};
                localStorage.setItem('castroUser', JSON.stringify(user));
                window.location.href = 'Home.aspx';
            ";
            ClientScript.RegisterStartupScript(GetType(), "authRedirect", script, true);
        }

        private static void SetStatus(Label lbl, string message, bool success)
        {
            lbl.Text     = message;
            lbl.CssClass = success ? "val-msg status-ok" : "val-msg status-err";
        }

        private static void ClearStatus(Label lbl)
        {
            lbl.Text     = string.Empty;
            lbl.CssClass = "val-msg";
        }

        /// <summary>Safely encode a string as a JSON string literal.</summary>
        private static string J(string s)
        {
            if (s == null) return "\"\"";
            return "\"" + s.Replace("\\", "\\\\")
                           .Replace("\"", "\\\"")
                           .Replace("\n", "\\n")
                           .Replace("\r", "\\r") + "\"";
        }

        /// <summary>
        /// SHA-256 hash stored as Base64 (88 chars max, fits NVARCHAR(88)).
        /// Use BCrypt in production for proper password hashing.
        /// </summary>
        private static string HashPassword(string password)
        {
            using (var sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(
                    Encoding.UTF8.GetBytes(password + "_CASTRO_SALT"));
                return Convert.ToBase64String(bytes);
            }
        }
    }
}
