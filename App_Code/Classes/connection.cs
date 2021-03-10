using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;






namespace Collection.Classes
{


    /// <summary>
    /// Summary description for connection
    /// </summary>
    public class connection
    {
        public static string strConnectionString;
        public connection()
        {
            //
            // TODO: Add constructor logic here
            strConnectionString = ConfigurationSettings.AppSettings["sqlConnectionString"];

        }
        public SqlConnection GetConnection()
        {
            SqlConnection objSqlConnection = new SqlConnection(strConnectionString);
            return objSqlConnection;

        }

        public void CloseConnection(ref SqlConnection objconnection)
        {
            if (objconnection.State == ConnectionState.Open)
                objconnection.Close();


        }
        public SqlCommand GetCommand(string SQL, ref SqlConnection objConnection)
        {
            return (new SqlCommand(SQL, objConnection));


        }
        public void CloseDataReader(ref  SqlDataReader objDataReader)
        {

            if (objDataReader != null)
                if (!objDataReader.IsClosed)
                    objDataReader.Close();

        }

        public SqlDataAdapter GetDataAdapter(string SQL, ref SqlConnection objConnection)
        {
            return (new SqlDataAdapter(SQL, objConnection));


        }


    }
}