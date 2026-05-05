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
        private int EditID
        {
            get { return ViewState["EditID"] != null ? (int)ViewState["EditID"] : 0; }
            set { ViewState["EditID"] = value; }
        }

        string connStr = ConfigurationManager.ConnectionStrings["conn"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Admin"] == null)
            {
                Response.Redirect("~/Pages/LoginSignup.aspx");
            }

            if (!IsPostBack)
            {
                LoadPackages();
            }
        }

        // =========================
        // LOAD GRID
        // =========================
        void LoadPackages()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        PackageID,
                        PackageName,
                        RatePerGuest,
                        Category
                    FROM Packages
                    ORDER BY PackageID DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvPackages.DataSource = dt;
                gvPackages.DataBind();
            }
        }

        // =========================
        // HANDLE IMAGE UPLOAD
        // Returns the saved relative path, or null if no file uploaded
        // =========================
        private string SaveUploadedImage()
        {
            if (!fuImage.HasFile) return null;

            string ext = Path.GetExtension(fuImage.FileName).ToLower();
            if (ext != ".jpg" && ext != ".jpeg" && ext != ".png" && ext != ".webp" && ext != ".gif")
            {
                lblMsg.Text = "⚠ Only JPG, PNG, WEBP or GIF images are allowed.";
                return null;
            }

            // Save to ~/Assests/ folder (same folder the existing package images use)
            string uploadDir = Server.MapPath("~/Assests/");
            if (!Directory.Exists(uploadDir))
                Directory.CreateDirectory(uploadDir);

            // Use a unique filename to avoid overwriting existing images
            string fileName  = Path.GetFileNameWithoutExtension(fuImage.FileName)
                               .Replace(" ", "_") + "_" + DateTime.Now.Ticks + ext;
            string fullPath  = Path.Combine(uploadDir, fileName);

            fuImage.SaveAs(fullPath);

            // Return the relative path that matches how other images are stored
            return "~/Assests/" + fileName;
        }

        // =========================
        // ADD / UPDATE PACKAGE
        // =========================
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

            // Try to save the uploaded image — returns null if none uploaded
            string newImagePath = SaveUploadedImage();
            if (lblMsg.Text.StartsWith("⚠")) return; // image validation failed

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // =========================
                // INSERT MODE
                // =========================
                if (EditID == 0)
                {
                    string imagePath = newImagePath ?? "";

                    string query = @"
                        INSERT INTO Packages
                        (PackageName, Description, RatePerGuest, MinGuests, MaxGuests, Category, Inclusions, ImagePath)
                        VALUES
                        (@PackageName, @Description, @RatePerGuest, @MinGuests, @MaxGuests, @Category, @Inclusions, @ImagePath)";

                    SqlCommand cmd = new SqlCommand(query, conn);
                    cmd.Parameters.AddWithValue("@PackageName",  txtPackageName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Description",  txtDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@RatePerGuest", rate);
                    cmd.Parameters.AddWithValue("@MinGuests",    minGuests);
                    cmd.Parameters.AddWithValue("@MaxGuests",    maxGuests);
                    cmd.Parameters.AddWithValue("@Category",     ddlCategory.SelectedValue);
                    cmd.Parameters.AddWithValue("@Inclusions",   txtInclusions.Text.Trim());
                    cmd.Parameters.AddWithValue("@ImagePath",    imagePath);
                    cmd.ExecuteNonQuery();

                    lblMsg.Text = "✔ Package added successfully!";
                }
                // =========================
                // UPDATE MODE
                // =========================
                else
                {
                    // Only update ImagePath if a new image was uploaded;
                    // otherwise keep the existing one
                    string query;
                    SqlCommand cmd;

                    if (newImagePath != null)
                    {
                        query = @"
                            UPDATE Packages SET
                                PackageName  = @PackageName,
                                Description  = @Description,
                                RatePerGuest = @RatePerGuest,
                                MinGuests    = @MinGuests,
                                MaxGuests    = @MaxGuests,
                                Category     = @Category,
                                Inclusions   = @Inclusions,
                                ImagePath    = @ImagePath
                            WHERE PackageID = @id";

                        cmd = new SqlCommand(query, conn);
                        cmd.Parameters.AddWithValue("@ImagePath", newImagePath);
                    }
                    else
                    {
                        // No new image — don't touch ImagePath
                        query = @"
                            UPDATE Packages SET
                                PackageName  = @PackageName,
                                Description  = @Description,
                                RatePerGuest = @RatePerGuest,
                                MinGuests    = @MinGuests,
                                MaxGuests    = @MaxGuests,
                                Category     = @Category,
                                Inclusions   = @Inclusions
                            WHERE PackageID = @id";

                        cmd = new SqlCommand(query, conn);
                    }

                    cmd.Parameters.AddWithValue("@PackageName",  txtPackageName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Description",  txtDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@RatePerGuest", rate);
                    cmd.Parameters.AddWithValue("@MinGuests",    minGuests);
                    cmd.Parameters.AddWithValue("@MaxGuests",    maxGuests);
                    cmd.Parameters.AddWithValue("@Category",     ddlCategory.SelectedValue);
                    cmd.Parameters.AddWithValue("@Inclusions",   txtInclusions.Text.Trim());
                    cmd.Parameters.AddWithValue("@id",           EditID);
                    cmd.ExecuteNonQuery();

                    lblMsg.Text = "✔ Package updated successfully!";
                }
            }

            // Reset form
            EditID = 0;
            btnAdd.Text = "Add Package";
            txtPackageName.Text  = "";
            txtDescription.Text  = "";
            txtRatePerGuest.Text = "";
            txtMinGuests.Text    = "";
            txtMaxGuests.Text    = "";
            txtInclusions.Text   = "";

            LoadPackages();
        }

        // =========================
        // DELETE
        // =========================
        private void DeletePackage(int id)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "DELETE FROM Packages WHERE PackageID = @id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        // =========================
        // LOAD DATA TO FORM (EDIT)
        // =========================
        private void LoadPackageToForm(int id)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT * FROM Packages WHERE PackageID = @id";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    txtPackageName.Text        = dr["PackageName"].ToString();
                    txtDescription.Text        = dr["Description"].ToString();
                    txtRatePerGuest.Text       = dr["RatePerGuest"].ToString();
                    txtMinGuests.Text          = dr["MinGuests"].ToString();
                    txtMaxGuests.Text          = dr["MaxGuests"].ToString();
                    ddlCategory.SelectedValue  = dr["Category"].ToString();
                    txtInclusions.Text         = dr["Inclusions"].ToString();

                    EditID       = id;
                    btnAdd.Text  = "Update Package";
                }
            }
        }

        // =========================
        // GRID COMMANDS
        // =========================
        protected void gvPackages_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "DeletePackage")
            {
                DeletePackage(id);
                LoadPackages();
            }
            else if (e.CommandName == "EditPackage")
            {
                LoadPackageToForm(id);
            }
        }
    }
}