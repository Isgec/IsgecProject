using forQueryExecution;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Web.Services;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls.WebParts;

public partial class PODetailList : System.Web.UI.Page
{
    int j = 1;
    int i = 0;
    int sno = 1;
    protected void Page_Load(object sender, EventArgs e)
    {
        DataSet ds1 = new DataSet();
        dateformat.Value = "dd/mm/yyyy";
        DataSet objDataSetbu = new DataSet();
        objDataSetbu.ReadXml(Server.MapPath("XML/button.xml"));
        hdnuserid.Value = Request.QueryString["us"].ToString();
        hdnusername.Value = Request.QueryString["us"].ToString();
        Ajax.Utility.RegisterTypeForAjax(typeof(PODetailList));
        
        if (!Page.IsPostBack)
        {
            string formname = "PODetailList";
            //search1.Attributes.Add("onclick", "javascript:return fillcostcentercode(event);");
            txtsuppname.Attributes.Add("onkeyup", "javascript:return bindsupliercodef2(event)");
            lstsuplircode.Attributes.Add("onclick", "javascript:return fillsupliercode(event);");
            lstsuplircode.Attributes.Add("onkeydown", "javascript:return fillsupliercode(event);");
        }

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

    }
    [Ajax.AjaxMethod]
    public DataSet hdr_savedet(string PPONo, string revision, string pextra1, string pextra2, string pextra3, string pextra4, string pextra5, string connstring)
    {
        DataSet ds1 = new DataSet();

        forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), connstring);
        objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

        string[] parval = new string[7] { PPONo, revision, pextra1, "", "", "", "" };
        string[] par = new string[7] { "@PPONo", "@PRevisionNo", "@pextra1", "@pextra2", "@pextra3", "@pextra4", "@pextra5" };
        ds1 = objconnectip.getDataAdapter("Pur_podetail", "PUR_TaxCodes", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

        return ds1;
    }


    [Ajax.AjaxMethod] // FETCH DATA
    public DataSet Bindsuppcode(string ptaxtypcd, string extra1, string extra2, string extra3, string extra4, string extra5, string connstring)
    {
        DataSet ds = new DataSet();
        forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), connstring);
        objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

        string[] parval = new string[6] { ptaxtypcd, extra1, extra2, extra3, extra4, extra5 };
        string[] par = new string[6] { "@pBPCode", "@pextra1", "@pextra2", "@pextra3", "@pextra4", "@pextra5" };
        //objconnectip.getExecuteNonQuery("tax_typemastsave", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        ds = objconnectip.getDataAdapter("bind_Bpgstin", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        return ds;
    }

}