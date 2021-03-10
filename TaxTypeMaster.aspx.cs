using System;
using System.Collections;
using System.Configuration;
using System.Data;
//using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
//using System.Xml.Linq;
using System.Collections.Generic;
using System.Collections;
//using System.Data.OracleClient;
using System.Net.Mail;
using System.Net;
using System.IO;
using System.Text;
using System.Net.Mail;
using forQueryExecution;

public partial class TaxTypeMaster : System.Web.UI.Page
{
    string branch_alias;
    string branch_new;
    string vouchernostatus;
    protected void Page_Load(object sender, EventArgs e)
    {

        DataSet ds1 = new DataSet();
        ds1.ReadXml(Server.MapPath("XML/TaxTypeMaster.xml"));
        lbltaxtypcd.Text = ds1.Tables[0].Rows[0].ItemArray[0].ToString();
        lbldescription.Text = ds1.Tables[0].Rows[0].ItemArray[1].ToString();
        lbldrop.Text = ds1.Tables[0].Rows[0].ItemArray[2].ToString();
        DataSet objDataSetbu = new DataSet();
        objDataSetbu.ReadXml(Server.MapPath("XML/button.xml"));
        btnNew.ImageUrl = objDataSetbu.Tables[0].Rows[0].ItemArray[0].ToString();
        btnSave.ImageUrl = objDataSetbu.Tables[0].Rows[0].ItemArray[1].ToString();
        btnModify.ImageUrl = objDataSetbu.Tables[0].Rows[0].ItemArray[2].ToString();
        btnQuery.ImageUrl = objDataSetbu.Tables[0].Rows[0].ItemArray[3].ToString();
        btnExecute.ImageUrl = objDataSetbu.Tables[0].Rows[0].ItemArray[4].ToString();
        btnCancel.ImageUrl = objDataSetbu.Tables[0].Rows[0].ItemArray[5].ToString();
        btnfirst.ImageUrl = objDataSetbu.Tables[0].Rows[0].ItemArray[6].ToString();
        btnprevious.ImageUrl = objDataSetbu.Tables[0].Rows[0].ItemArray[7].ToString();
        btnnext.ImageUrl = objDataSetbu.Tables[0].Rows[0].ItemArray[8].ToString();
        btnlast.ImageUrl = objDataSetbu.Tables[0].Rows[0].ItemArray[9].ToString();
        btnDelete.ImageUrl = objDataSetbu.Tables[0].Rows[0].ItemArray[10].ToString();
        btnExit.ImageUrl = objDataSetbu.Tables[0].Rows[0].ItemArray[11].ToString();
        dateformat.Value = "dd/mm/yyyy";
        Ajax.Utility.RegisterTypeForAjax(typeof(TaxTypeMaster));
        if (!Page.IsPostBack)
        {
            hdncompname.Value = Request.QueryString["cm"].ToString();
            Session["comp_name"] = Request.QueryString["cm"].ToString();
            if (hdncompname.Value == "200")
            {
                hdnconnectionstring.Value = ConfigurationSettings.AppSettings["ConnectionStringijtperks"].ToString();
            }
            else if (hdncompname.Value == "651")
            {
                hdnconnectionstring.Value = ConfigurationSettings.AppSettings["ConnectionStringicl"].ToString();
            }
            else if (hdncompname.Value == "700")
            {
                hdnconnectionstring.Value = ConfigurationSettings.AppSettings["ConnectionStringredecam"].ToString();
            }
            else
            {
                hdnconnectionstring.Value = ConfigurationSettings.AppSettings["ConnectionString"].ToString();
            }
            btnNew.Attributes.Add("onClick", "javascript:return EnabledOnNew()");
            btnSave.Attributes.Add("onclick", "javascript:return onsaveclick();");
            btnCancel.Attributes.Add("onclick", "javascript:return clearclick();");
            btnExit.Attributes.Add("onclick", "javascript:return Exit();");
            btnQuery.Attributes.Add("onclick", "javascript:return EnabledOnQuery();");
            btnnext.Attributes.Add("onclick", "javascript:return OnClickNext();");
            btnprevious.Attributes.Add("onclick", "javascript:return OnClickPrevious();");
            btnfirst.Attributes.Add("onclick", "javascript:return OnClickFirst();");
            btnlast.Attributes.Add("onclick", "javascript:return OnClickLast();");
            btnDelete.Attributes.Add("onclick", "javascript:return delete_data();");
            btnModify.Attributes.Add("onclick", "javascript:return OnClickModify();");
            btnExecute.Attributes.Add("onclick", "javascript:return EnableExecute();");
            string formname = "TaxTypeMaster";
        }

    }

    [Ajax.AjaxMethod]
    public DataSet hdr_save(string txttaxtypcd, string txtdescription, string flag, string exra1, string extra2, string extra3, string extra4, string extra5, string connstring)
    {

        DataSet ds = new DataSet();
        try
        {

            forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), connstring);
            objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

            string[] parval = new string[8] { txttaxtypcd, txtdescription, flag, exra1, extra2, extra3, extra4, extra5 };
            string[] par = new string[8] { "@ptaxtypecode", "@pdescription", "@flag", "@pextra1", "@pextra2", "@pextra3", "@pextra4", "@pextra5" };
            //objconnectip.getExecuteNonQuery("tax_typemastsave", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
            ds = objconnectip.getDataAdapter("tax_typemastsave", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
            objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());


        }
        catch (Exception ex)
        {
            string msg = ex.Message;
        }
        return ds;

    }


    [Ajax.AjaxMethod]
    public DataSet hdr_savedet(string txttaxtypcd, string txtdescription, string effectivedate, string rate, string flag, string exra1, string extra2, string extra3, string extra4, string extra5, string connstring)
    {
        string dateformat = "dd/mm/yyyy";
        if (flag == "U" || flag == "D" || flag == "I")
        {
        if (dateformat == "dd/mm/yyyy")
        {
            string[] arr = effectivedate.Split('/');
            string dd = arr[0];
            string mm = arr[1];
            string yyyy = arr[2];
            effectivedate = mm + "/" + dd + "/" + yyyy;
        }
        }
        DataSet ds = new DataSet();
        forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(),connstring);
        objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

        string[] parval = new string[10] { txttaxtypcd, txtdescription, effectivedate, rate, flag, exra1, extra2, extra3, extra4, extra5 };
        string[] par = new string[10] { "@ptaxtypecode", "@pdescription","@peffectivedate","@pRATE", "@flag", "@pextra1", "@pextra2", "@pextra3", "@pextra4", "@pextra5" };
       ds = objconnectip.getDataAdapter("tax_typemastdetsave", "PUR_TaxRates", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

        return ds;

    }



}