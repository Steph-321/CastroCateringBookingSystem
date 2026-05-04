using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI.WebControls;

namespace CastroCateringBookingSystem.Pages
{
    public partial class AdminAddPackage : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Admin"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadPackages();
            }
        }

        void LoadPackages()
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

                gvPackages.DataSource = dt;
                gvPackages.DataBind();
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (txtPackageName.Text.Trim() == "" ||
                txtDescription.Text.Trim() == "" ||
                txtRatePerGuest.Text.Trim() == "")
            {
                lblMsg.Text = "⚠ Please fill required fields.";
                return;
            }

            decimal rate;
            if (!decimal.TryParse(txtRatePerGuest.Text, out rate))
            {
                lblMsg.Text = "⚠ Invalid rate format.";
                return;
            }

            int minGuests = 0;
            int maxGuests = 0;

            int.TryParse(txtMinGuests.Text, out minGuests);
            int.TryParse(txtMaxGuests.Text, out maxGuests);

            string imagePath = "";

            // IMAGE UPLOAD
            if (fuImage.HasFile)
            {
                string ext = Path.GetExtension(fuImage.FileName).ToLower();

                if (ext != ".jpg" && ext != ".png" && ext != ".jpeg")
                {
                    lblMsg.Text = "⚠ Only JPG/PNG allowed.";
                    return;
                }

                string fileName = Guid.NewGuid().ToString() + ext;
                string folder = Server.MapPath("~/Assets/Packages/");

                if (!Directory.Exists(folder))
                {
                    Directory.CreateDirectory(folder);
                }

                string savePath = Path.Combine(folder, fileName);
                fuImage.SaveAs(savePath);

                imagePath = "/Assets/Packages/" + fileName;
            }
            else
            {
                lblMsg.Text = "⚠ Please upload an image.";
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // CHECK DUPLICATE
                string checkQuery = "SELECT COUNT(*) FROM Packages WHERE PackageName = @PackageName";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@PackageName", txtPackageName.Text.Trim());

                int exists = (int)checkCmd.ExecuteScalar();

                if (exists > 0)
                {
                    lblMsg.Text = "⚠ Package already exists!";
                    return;
                }

                // INSERT
                string query = @"
                    INSERT INTO Packages
                    (PackageName, Description, RatePerGuest, MinGuests, MaxGuests, Category, Inclusions, ImagePath)
                    VALUES
                    (@PackageName, @Description, @RatePerGuest, @MinGuests, @MaxGuests, @Category, @Inclusions, @ImagePath)";

                SqlCommand cmd = new SqlCommand(query, conn);

                cmd.Parameters.AddWithValue("@PackageName", txtPackageName.Text.Trim());
                cmd.Parameters.AddWithValue("@Description", txtDescription.Text.Trim());
                cmd.Parameters.AddWithValue("@RatePerGuest", rate);
                cmd.Parameters.AddWithValue("@MinGuests", minGuests);
                cmd.Parameters.AddWithValue("@MaxGuests", maxGuests);
                cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@Inclusions", txtInclusions.Text.Trim());
                cmd.Parameters.AddWithValue("@ImagePath", imagePath);

                cmd.ExecuteNonQuery();
            }

            // ✅ IMPORTANT: refresh grid AFTER insert
            LoadPackages();

            // optional: clear fields
            txtPackageName.Text = "";
            txtDescription.Text = "";
            txtRatePerGuest.Text = "";
            txtMinGuests.Text = "";
            txtMaxGuests.Text = "";
            txtInclusions.Text = "";

            lblMsg.Text = "✔ Package added successfully!";
        }

        protected void gvPackages_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeletePackage")
            {
                int packageId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "DELETE FROM Packages WHERE PackageID = @id";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@id", packageId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadPackages();
            }
        }
    }
}
