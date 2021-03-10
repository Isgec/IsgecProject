using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Collections.Generic;
using System.Collections;
using System.Net.Mail;
using System.Net;
using System.IO;
using System.Text;
using System.Net.Mail;
using forQueryExecution;

public partial class Item_Master : System.Web.UI.Page
{
    string branch_alias;
    string branch_new;
    string vouchernostatus;
    protected void Page_Load(object sender, EventArgs e)
    {
        DataSet ds1 = new DataSet();
        ds1.ReadXml(Server.MapPath("XML/Item_Master.xml"));
        lblitemuom.Text = ds1.Tables[0].Rows[0].ItemArray[0].ToString();
        lblitemname.Text = ds1.Tables[0].Rows[0].ItemArray[1].ToString();
        lblitemcode.Text = ds1.Tables[0].Rows[0].ItemArray[2].ToString();
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
        Ajax.Utility.RegisterTypeForAjax(typeof(Item_Master));
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


            txtitemuom.Attributes.Add("onkeyup", "javascript:return binduomcode(event)");
            lstuomcode.Attributes.Add("onclick", "javascript:return filluomcode(event);");
            lstuomcode.Attributes.Add("onkeydown", "javascript:return filluomcode(event);");
            string formname = "Item Master";
            Session["formname"] = formname;
        }
    }



    [Ajax.AjaxMethod]
    public DataSet hdr_save(string txtuomcode, string PItemCode,string Pdescriptions,string flag, string exra1, string extra2, string extra3, string extra4, string extra5, string connstring)
    {

        DataSet ds = new DataSet();
        try
        {

            forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), connstring);
            objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

            string[] parval = new string[9] { txtuomcode, PItemCode,Pdescriptions,flag, exra1, extra2, extra3, extra4, extra5 };
            string[] par = new string[9] { "@PUomCode", "@PItemCode","@Pdescriptions","@flag", "@pextra1", "@pextra2", "@pextra3", "@pextra4", "@pextra5" };
            //objconnectip.getExecuteNonQuery("tax_typemastsave", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
            ds = objconnectip.getDataAdapter("Pur_itemsave", "PUR_ItemMaster", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
            objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());


        }
        catch (Exception ex)
        {
            string msg = ex.Message;
        }
        return ds;

    }



    [Ajax.AjaxMethod] // FETCH DATA
    public DataSet Binduomcode(string txtuomcode, string txtcompanyname, string exra1, string extra2, string extra3, string extra4, string extra5, string connstring)
    {
        DataSet ds = new DataSet();
        forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), connstring);
        objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

        string[] parval = new string[7] { txtuomcode, txtcompanyname, exra1, extra2, extra3, extra4, extra5 };
        string[] par = new string[7] { "@puomcode", "@pcompanycd", "@pextra1", "@pextra2", "@pextra3", "@pextra4", "@pextra5" };
        //objconnectip.getExecuteNonQuery("tax_typemastsave", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        ds = objconnectip.getDataAdapter("bind_uomcode", "SPMT_ERPUnits", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

        return ds;
    }


}