using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace CastroCateringBookingSystem
{
    public partial class Home : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        /// <summary>
        /// Returns the average rating from the Reviews table, formatted to 1 decimal place.
        /// Falls back to "—" if there are no reviews or the DB is unavailable.
        /// </summary>
        public string GetAverageRating()
        {
            try
            {
                string connStr = ConfigurationManager.ConnectionStrings["conn"].ConnectionString;

                using (var conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    const string sql = "SELECT AVG(CAST(Rating AS FLOAT)) FROM Reviews";

                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        object result = cmd.ExecuteScalar();

                        if (result == null || result == DBNull.Value)
                            return "—";

                        double avg = Convert.ToDouble(result);
                        return avg.ToString("0.0");
                    }
                }
            }
            catch
            {
                return "—";
            }
        }
    }
}
