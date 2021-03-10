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

public partial class Topbarnew_n : System.Web.UI.UserControl
{

    string branchname;
    protected void Page_Load(object sender, EventArgs e)
    {
        DataSet dsenablelink = new DataSet();
        dsenablelink.ReadXml(Server.MapPath("xml/topbarlink.xml"));
        

        //imglogo.Src = "Images/4c_logo.jpg";// +ConfigurationManager.AppSettings["logoimg"].ToString();
        //imglogo.Width = Convert.ToInt32(ConfigurationManager.AppSettings["logoimgwidth"].ToString());
        ligencd1.InnerText = Session["formname"].ToString();
        string center = ConfigurationSettings.AppSettings["center"].ToString();
        // if (center == "depo")
        //{
        if (System.IO.Path.GetFileName(Page.Request.PhysicalPath) != "cngpassword.aspx")
        {

            DataSet ds = new DataSet();
            if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "sql")
            {
                Collection.Classes.login tab = new Collection.Classes.login();
                ds = tab.getmoduleper(hidcompcode.Value, hiduserid.Value);
            }
            else if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "orcl")
            {
               // Collection.classesoracle.login tab = new Collection.classesoracle.login();
                //ds = tab.getmoduleper(hidcompcode.Value, hiduserid.Value);
            }
            else
            {
              //  Collection.classesoracle.login tab = new Collection.classesoracle.login();
              //  ds = tab.getmoduleper(hidcompcode.Value, hiduserid.Value);
            }
            string adaccount = "0";
            string layoutx = "0";
            string cir = "0";
            string pam = "0";
            string news = "0";
            string pay = "0";
            string finance = "0";
            for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
            {
                if (ds.Tables[0].Rows[i].ItemArray[0].ToString() == "ADB")
                    adaccount = "1";
                else if (ds.Tables[0].Rows[i].ItemArray[0].ToString() == "LAY")
                    layoutx = "1";
                else if (ds.Tables[0].Rows[i].ItemArray[0].ToString() == "CIR")
                    cir = "1";
                else if (ds.Tables[0].Rows[i].ItemArray[0].ToString() == "PAM")
                    pam = "1";
                else if (ds.Tables[0].Rows[i].ItemArray[0].ToString() == "NEW")
                    news = "1";
                else if (ds.Tables[0].Rows[i].ItemArray[0].ToString() == "PAY")
                    pay = "1";
                else if (ds.Tables[0].Rows[i].ItemArray[0].ToString() == "FIN")
                    finance = "1";
            }



            DataSet ds_branch = new DataSet();
            if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "sql")
            {
                Collection.Classes.login tab = new Collection.Classes.login();
                ds_branch = tab.getbranchname(hidcompcode.Value, hiddenreveneue.Value);
            }
            else if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "orcl")
            {
                ////Collection.classesoracle.login tab = new Collection.classesoracle.login();
                ////ds_branch = tab.getbranchname(hidcompcode.Value, hiddenreveneue.Value);
            }


            if (ds.Tables[0].Rows.Count > 0)
            {
            branchname = ds_branch.Tables[0].Rows[0]["Branch_Name"].ToString();
             }
             else
             {
                 branchname = hiddenreveneue.Value;
             }

            if (Session["datetimeNow"] == null)
                Session["datetimeNow"] = System.DateTime.Now.ToString("dd/MM/yyyy HH:mm:ss");
            hiddendatetime.Value = Session["datetimeNow"].ToString();
        }
        else
        {
        }

        if (System.IO.Path.GetFileName(Page.Request.PhysicalPath) != "Default.aspx")
        {
           // _lbuser.Attributes.Add("style", "display:block");
            //_user.Attributes.Add("style", "display:none");
            //_lbcom.Attributes.Add("style", "display:none");
           // _com.Attributes.Add("style", "display:none");
            //_lbadmin.Attributes.Add("style", "display:none");
           // _admin.Attributes.Add("style", "display:none");
        }
        //DataSet ds = new DataSet();
        //ds.ReadXml(Server.MapPath("XML/releaseno.xml"));
        //lbrelease.Text = ds.Tables[0].Rows[0].ItemArray[0].ToString();
        ////}


    }
}
