using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Security.Cryptography;
public partial class loginxml : System.Web.UI.Page
{
    const string passphrase = "password";
    protected void Page_Load(object sender, EventArgs e)
    {


        Response.Expires = -1;

        string flag = "0";
        string username = Request.QueryString["username"].ToString();
        string password = Request.QueryString["password"].ToString();
        string qbc = Request.QueryString["qbc"].ToString();
        string printingcentercode = Request.QueryString["printingcentercode"].ToString();
        string centername = Request.QueryString["centerval"].ToString();
        DataSet ds = new DataSet(); ;
        if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "sql")
        {
            string pwddecrypt = EncryptData(password);
            Collection.Classes.login logindetail = new Collection.Classes.login();
            ds = logindetail.chklogin(username, pwddecrypt, qbc);
        }
        else
            if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "orcl")
            {
                string pwddecrypt = EncryptData(password);
                // string pwddecrypt = (password);
                Collection.classesoracle.login logindetail = new Collection.classesoracle.login();
                ds = logindetail.chklogin(username, pwddecrypt, qbc);
            }


        if (ds.Tables[0].Rows.Count > 0)
        {
            flag = "1";
            Session["printingcentercode"] = printingcentercode;
            Session["revenue"] = qbc;
            Session["centername"] = centername;
            Session["Username"] = ds.Tables[0].Rows[0].ItemArray[0].ToString();
            Session["userid"] = ds.Tables[0].Rows[0].ItemArray[2].ToString();
            Session["compcode"] = ds.Tables[0].Rows[0].ItemArray[4].ToString();
            Session["compname"] = ds.Tables[0].Rows[0]["comp_name"].ToString();
            Session["revenuename"] = ds.Tables[0].Rows[0]["branch_nm"].ToString();
            if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "sql")
            {
                Session["revenue_add"] = ds.Tables[0].Rows[0].ItemArray[8].ToString();
            }
            Session["dateformat"] = ds.Tables[1].Rows[0].ItemArray[3].ToString();
            //UserLabel.Value = Session["Username"].ToString();
            Session["autogenerated"] = ds.Tables[1].Rows[0].ItemArray[1].ToString();
            Session["currency"] = ds.Tables[1].Rows[0].ItemArray[2].ToString();
            Session["ratecode"] = ds.Tables[1].Rows[0].ItemArray[0].ToString();
            Session["solorate"] = ds.Tables[1].Rows[0].ItemArray[4].ToString();
            Session["decimal"] = ds.Tables[1].Rows[0].ItemArray[5].ToString();
            Session["breakup"] = ds.Tables[1].Rows[0].ItemArray[6].ToString();
            Session["bwcode"] = ds.Tables[1].Rows[0].ItemArray[7].ToString();
            Session["uom"] = ds.Tables[1].Rows[0].ItemArray[8].ToString();
            Session["rostatus"] = ds.Tables[1].Rows[0].ItemArray[9].ToString();
            Session["tfn"] = ds.Tables[1].Rows[0].ItemArray[10].ToString();
            Session["insertsbreakup"] = ds.Tables[1].Rows[0].ItemArray[11].ToString();
            Session["premtype"] = ds.Tables[1].Rows[0].ItemArray[12].ToString();
            Session["dealtype"] = ds.Tables[1].Rows[0].ItemArray[13].ToString();
            Session["print_center"] = ds.Tables[0].Rows[0]["PUB_CENT"].ToString();


            Session["prefix"] = ds.Tables[1].Rows[0].ItemArray[14].ToString();
            Session["suffix"] = ds.Tables[1].Rows[0].ItemArray[15].ToString();
            Session["financestatus"] = ds.Tables[1].Rows[0].ItemArray[16].ToString();
            Session["voucherst"] = ds.Tables[1].Rows[0].ItemArray[17].ToString();

            Session["barcode"] = ds.Tables[1].Rows[0].ItemArray[60].ToString();
            //Session["allowPDC"] = ds.Tables[1].Rows[0].ItemArray[61].ToString();
            //Session["allowBarcode"] = ds.Tables[1].Rows[0].ItemArray[62].ToString();

            Session["allowPDC"] = ds.Tables[1].Rows[0]["PDC_DAY"].ToString();
            Session["allowBarcode"] = "NO";
            Session["backDayRecpt"] = ds.Tables[1].Rows[0]["BACK_DATE_RCPT"].ToString();

            Session["FA_LEDGER_ALLOW"] = ds.Tables[1].Rows[0]["FA_LEDGER_ALLOW"].ToString();
            Session["CLEARANCE_TYPE_ALLOW"] = ds.Tables[1].Rows[0]["CLEARANCE_TYPE_ALLOW"].ToString();

            Session["ROLEID"] = ds.Tables[0].Rows[0]["ROLEID"].ToString();
            //Session["AD_COLL_AUTO_TFR_FIN"] = ds.Tables[1].Rows[0]["AD_COLL_AUTO_TFR_FIN"].ToString();







            //Response.Redirect("EnterPage.aspx");
            //Response.Redirect("Adsize_master.aspx");
            //Response.Redirect("Agent_master.aspx");
            //Response.Redirect("Revenue_master.aspx");
            //Response.Redirect("CombinationMaster.aspx");
            //Response.Redirect("Bullet_master.aspx");
            //Response.Redirect("Premium_typ_master.aspx");
            //Response.Redirect("RepMast.aspx");
            //Response.Redirect("Pageparametermaster.aspx");
            //Response.Redirect("Adv_booking.aspx");
            //Response.Redirect("UOM.aspx");
            //Response.Redirect("Currencymaster.aspx");
            //Response.Redirect("Contractmaster.aspx");
            //Response.Redirect("Default.aspx");
            //Response.Redirect("ProductMaster.aspx");
            //Response.Redirect("Clientrolemaster.aspx");
            // Response.Redirect("AgencyTypeMaster.aspx");
            //Response.Redirect("ClientMaster.aspx");
            //Response.Redirect("updateprefer.aspx");
        }
        else
        {
            flag = "0";
        }
        // return ;

        Response.Write(flag);
        Response.End();

    }

    public static string DecryptString(string Message)
    {
        byte[] Results;
        System.Text.UTF8Encoding UTF8 = new System.Text.UTF8Encoding();
        MD5CryptoServiceProvider HashProvider = new MD5CryptoServiceProvider();
        byte[] TDESKey = HashProvider.ComputeHash(UTF8.GetBytes(passphrase));
        TripleDESCryptoServiceProvider TDESAlgorithm = new TripleDESCryptoServiceProvider();
        TDESAlgorithm.Key = TDESKey;
        TDESAlgorithm.Mode = CipherMode.ECB;
        TDESAlgorithm.Padding = PaddingMode.PKCS7;
        byte[] DataToDecrypt = Convert.FromBase64String(Message);
        try
        {
            ICryptoTransform Decryptor = TDESAlgorithm.CreateDecryptor();
            Results = Decryptor.TransformFinalBlock(DataToDecrypt, 0, DataToDecrypt.Length);
        }
        finally
        {
            TDESAlgorithm.Clear();
            HashProvider.Clear();
        }
        return UTF8.GetString(Results);
    }
    private string EncryptData(string Message)
    {
        byte[] Results;
        System.Text.UTF8Encoding UTF8 = new System.Text.UTF8Encoding();
        MD5CryptoServiceProvider HashProvider = new MD5CryptoServiceProvider();
        byte[] TDESKey = HashProvider.ComputeHash(UTF8.GetBytes(passphrase));
        TripleDESCryptoServiceProvider TDESAlgorithm = new TripleDESCryptoServiceProvider();
        TDESAlgorithm.Key = TDESKey;
        TDESAlgorithm.Mode = CipherMode.ECB;
        TDESAlgorithm.Padding = PaddingMode.PKCS7;
        byte[] DataToEncrypt = UTF8.GetBytes(Message);
        try
        {
            ICryptoTransform Encryptor = TDESAlgorithm.CreateEncryptor();
            Results = Encryptor.TransformFinalBlock(DataToEncrypt, 0, DataToEncrypt.Length);
        }
        finally
        {
            TDESAlgorithm.Clear();
            HashProvider.Clear();
        }
        return Convert.ToBase64String(Results);
    }

}