using forQueryExecution;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class new_page : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DataSet ds1 = new DataSet();
        ds1.ReadXml(Server.MapPath("XML/new_page.xml"));
        lblpo.Text = ds1.Tables[0].Rows[0].ItemArray[0].ToString();
        lblsupcode.Text = ds1.Tables[0].Rows[0].ItemArray[1].ToString();
        lblrreason.Text = ds1.Tables[0].Rows[0].ItemArray[2].ToString();
        lblpodate.Text = ds1.Tables[0].Rows[0].ItemArray[3].ToString();
        lblgstin.Text = ds1.Tables[0].Rows[0].ItemArray[4].ToString();
        lblreject.Text = ds1.Tables[0].Rows[0].ItemArray[5].ToString();
        lblrevision.Text = ds1.Tables[0].Rows[0].ItemArray[6].ToString();
        lblerpno.Text = ds1.Tables[0].Rows[0].ItemArray[7].ToString();
        lblstatus.Text = ds1.Tables[0].Rows[0].ItemArray[8].ToString();
        lblisgecgstin.Text = ds1.Tables[0].Rows[0].ItemArray[9].ToString();
        lblquationno.Text = ds1.Tables[0].Rows[0].ItemArray[11].ToString();
        lblqudt.Text = ds1.Tables[0].Rows[0].ItemArray[12].ToString();
        lblaprvdt.Text = ds1.Tables[0].Rows[0].ItemArray[13].ToString();
        lblcrtdby.Text = ds1.Tables[0].Rows[0].ItemArray[14].ToString();
        lblpymntterm.Text = ds1.Tables[0].Rows[0].ItemArray[15].ToString();
        lblcrtdon.Text = ds1.Tables[0].Rows[0].ItemArray[16].ToString();
        lbldelveryon.Text = ds1.Tables[0].Rows[0].ItemArray[17].ToString();
        lblsentaprv.Text = ds1.Tables[0].Rows[0].ItemArray[18].ToString();
        lbldispatch.Text = ds1.Tables[0].Rows[0].ItemArray[19].ToString();
        lblaprvon.Text = ds1.Tables[0].Rows[0].ItemArray[20].ToString();
        lbldes.Text = ds1.Tables[0].Rows[0].ItemArray[21].ToString();
        lblaprovedby.Text = ds1.Tables[0].Rows[0].ItemArray[22].ToString();
        lblinsurance.Text = ds1.Tables[0].Rows[0].ItemArray[23].ToString();
        lblapprovedon.Text = ds1.Tables[0].Rows[0].ItemArray[24].ToString();
        lblremrks.Text = ds1.Tables[0].Rows[0].ItemArray[25].ToString();

        txtpodat.Text = DateTime.Now.ToString("dd/MM/yyyy");
        txtcrtdon.Text = DateTime.Now.ToString("dd/MM/yyyy");
        txtrevision.Text = "0";
        dateformat.Value = "dd/mm/yyyy";
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
        btnExit.ImageUrl = objDataSetbu.Tables[0].Rows[0].ItemArray[11].ToString();
       // dateformat.Value = "dd/mm/yyyy";
        Ajax.Utility.RegisterTypeForAjax(typeof(new_page));
        if (!Page.IsPostBack)
        {
            btnNew.Attributes.Add("onClick", "javascript:return EnabledOnNew()");
            btnSave.Attributes.Add("onclick", "javascript:return onsaveclick();");
            btnCancel.Attributes.Add("onclick", "javascript:return clearclick();");
            btnExit.Attributes.Add("onclick", "javascript:return Exit();");
            btnQuery.Attributes.Add("onclick", "javascript:return EnabledOnQuery();");
            btnnext.Attributes.Add("onclick", "javascript:return OnClickNext();");
            btnprevious.Attributes.Add("onclick", "javascript:return OnClickPrevious();");
            btnfirst.Attributes.Add("onclick", "javascript:return OnClickFirst();");
            btnlast.Attributes.Add("onclick", "javascript:return OnClickLast();");
            btnModify.Attributes.Add("onclick", "javascript:return OnClickModify();");
            btnExecute.Attributes.Add("onclick", "javascript:return EnableExecute();");
            lsttaxtypcdgrid.Attributes.Add("onclick", "javascript:return filltaxtypecode(event);");
            lsttaxtypcdgrid.Attributes.Add("onkeydown", "javascript:return filltaxtypecode(event);");

            txtsupcode.Attributes.Add("onkeyup", "javascript:return bindsupliercodef2(event)");
            lstsuplircode.Attributes.Add("onclick", "javascript:return fillsupliercode(event);");
            lstsuplircode.Attributes.Add("onkeydown", "javascript:return fillsupliercode(event);");

            lstitemcode.Attributes.Add("onclick", "javascript:return fillitemcode(event);");
            lstitemcode.Attributes.Add("onkeydown", "javascript:return fillitemcode(event);");
            string formname = "new_page";
        }
    
    }


    [Ajax.AjaxMethod]
    public DataSet hdr_save(string PPONo, string PPoDate, string PRevisionNo, string Pstatus, string PQuatationNo, string PQuotationDate, string PBPCode, string PBPGSTIN, string PERPCompany,
  string  PIsgecGSTIN,string PPaymentTerm,string PDeliveryTerm,string PModeofDispatch,string PDestination,string PInsurance,string PRemarks,string PApproverType,string PCreatedby,
  string  PCreatedOn,string PSentforapprovalBy,string PSentforApprovalon,string PApprovedBy,string PApprovedOn,string PReasonofRevision,string PApproval_RejectionRemarks,
   string flag,string pextra1,string pextra2,string pextra3,string pextra4,string pextra5)
    {
        string dateformat = "dd/mm/yyyy";

        if (dateformat == "dd/mm/yyyy")
        {
            string[] arr = PPoDate.Split('/');
            string dd = arr[0];
            string mm = arr[1];
            string yyyy = arr[2];
            PPoDate = mm + "/" + dd + "/" + yyyy;
        }
        if (dateformat == "dd/mm/yyyy")
        {
            if (PApprovedOn != "")
            {
                string[] arr = PApprovedOn.Split('/');
                string dd = arr[0];
                string mm = arr[1];
                string yyyy = arr[2];
                PApprovedOn = mm + "/" + dd + "/" + yyyy;
            }
            else {
                PApprovedOn = "";
            }
        }
        if (dateformat == "dd/mm/yyyy")
        {
            if (PQuotationDate != "")
            {
                string[] arr = PQuotationDate.Split('/');
                string dd = arr[0];
                string mm = arr[1];
                string yyyy = arr[2];
                PQuotationDate = mm + "/" + dd + "/" + yyyy;
            }
            else {
                PQuotationDate = "";
            }
        }
        if (dateformat == "dd/mm/yyyy")
        {
            if (PCreatedOn != "")
            {
                string[] arr = PCreatedOn.Split('/');
                string dd = arr[0];
                string mm = arr[1];
                string yyyy = arr[2];
                PCreatedOn = mm + "/" + dd + "/" + yyyy;
            }
            else {
                PCreatedOn = "";
            }
        }

        DataSet ds = new DataSet();
        try
        {
            
            forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), ConfigurationSettings.AppSettings["ConnectionString"].ToString());
            objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

            string[] parval = new string[31] {PPONo, PPoDate, PRevisionNo, Pstatus, PQuatationNo, PQuotationDate, PBPCode, PBPGSTIN, PERPCompany,
    PIsgecGSTIN, PPaymentTerm, PDeliveryTerm, PModeofDispatch, PDestination, PInsurance, PRemarks, PApproverType, PCreatedby,
    PCreatedOn, PSentforapprovalBy, PSentforApprovalon, PApprovedBy, PApprovedOn, PReasonofRevision, PApproval_RejectionRemarks,
    flag, pextra1, pextra2, pextra3, pextra4, pextra5};
            string[] par = new string[31] {"@PPONo","@PPoDate","@PRevisionNo","@Pstatus","@PQuatationNo","@PQuotationDate","@PBPCode","@PBPGSTIN","@PERPCompany","@PIsgecGSTIN","@PPaymentTerm","@PDeliveryTerm" ,"@PModeofDispatch",
"@PDestination","@PInsurance","@PRemarks" ,"@PApproverType" ,"@PCreatedby","@PCreatedOn","@PSentforapprovalBy","@PSentforApprovalon" ,"@PApprovedBy","@PApprovedOn","@PReasonofRevision",
"@PApproval_RejectionRemarks","@flag","@pextra1","@pextra2","@pextra3","@pextra4","@pextra5"};
            //objconnectip.getExecuteNonQuery("tax_typemastsave", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
            ds = objconnectip.getDataAdapter("Pur_poheadersave", "PUR_TaxCodes", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
            objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());


        }
        catch (Exception ex)
        {
            string msg = ex.Message;
        }
        return ds;

    }



    [Ajax.AjaxMethod] // FETCH DATA
    public DataSet Binditemcode(string ptaxtypcd, string extra1, string extra2, string extra3, string extra4, string extra5)
    {
        DataSet ds = new DataSet();
        forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), ConfigurationSettings.AppSettings["ConnectionString"].ToString());
        objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

        string[] parval = new string[6] { ptaxtypcd, extra1, extra2, extra3, extra4, extra5 };
        string[] par = new string[6] { "@pITEMCode", "@pextra1", "@pextra2", "@pextra3", "@pextra4", "@pextra5" };
        //objconnectip.getExecuteNonQuery("tax_typemastsave", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        ds = objconnectip.getDataAdapter("bind_ITEMCode", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        return ds;
    }
    [Ajax.AjaxMethod] // FETCH DATA
    public DataSet Bindsuppcode(string ptaxtypcd, string extra1, string extra2, string extra3, string extra4, string extra5)
    {
        DataSet ds = new DataSet();
        forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), ConfigurationSettings.AppSettings["ConnectionString"].ToString());
        objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

        string[] parval = new string[6] { ptaxtypcd, extra1, extra2, extra3, extra4, extra5 };
        string[] par = new string[6] { "@pBPCode", "@pextra1", "@pextra2", "@pextra3", "@pextra4", "@pextra5" };
        //objconnectip.getExecuteNonQuery("tax_typemastsave", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        ds = objconnectip.getDataAdapter("bind_Bpgstin", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        return ds;
    }
    [Ajax.AjaxMethod] // FETCH DATA
    public DataSet BindTaxtype(string ptaxtypcd, string extra1, string extra2, string extra3, string extra4, string extra5)
    {
        DataSet ds = new DataSet();
        forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), ConfigurationSettings.AppSettings["ConnectionString"].ToString());
        objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

        string[] parval = new string[6] { ptaxtypcd, extra1, extra2, extra3, extra4, extra5 };
        string[] par = new string[6] { "@taxcode", "@pextra1", "@pextra2", "@pextra3", "@pextra4", "@pextra5" };
        //objconnectip.getExecuteNonQuery("tax_typemastsave", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        ds = objconnectip.getDataAdapter("bind_taxcode", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        return ds;
    }


    [Ajax.AjaxMethod] // FETCH DATA
    public DataSet BindTaxratetype(string podate,string ptaxtypcd, string extra1, string extra2, string extra3, string extra4, string extra5)
    {
        DataSet ds = new DataSet();
        forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), ConfigurationSettings.AppSettings["ConnectionString"].ToString());
        objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

        string[] parval = new string[7] { podate,ptaxtypcd, extra1, extra2, extra3, extra4, extra5 };
        string[] par = new string[7] { "@podate", "@taxcode", "@pextra1", "@pextra2", "@pextra3", "@pextra4", "@pextra5" };
        //objconnectip.getExecuteNonQuery("tax_typemastsave", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        ds = objconnectip.getDataAdapter("bind_taxratetype", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        return ds;
    }

    //[Ajax.AjaxMethod]
    //public DataSet hdr_savedet(string ponosave, string rivision_no, string line_no, string Item_Code, string Quantity, string Unit, string currency, string Price_per_unit, string Assessable_Value, string Tax_Code, string SGST_rate, string CGST_rate,
    //    string IGST_rate, string CESS_rate, string TCS_rate, string SGST_Amount, string CGST_Amount, string IGST_Amount, string CESS_Amount, string TCS_Amount, string flag, string pextra1, string pextra2, string pextra3, string pextra4, string pextra5)
    //{

    //    DataSet ds = new DataSet();
    //    try
    //    {
          
    //        forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), ConfigurationSettings.AppSettings["ConnectionString"].ToString());
    //        objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

    //        string[] parval = new string[26] { ponosave,rivision_no, line_no, Item_Code, Quantity, Unit,currency, Price_per_unit, Assessable_Value, Tax_Code, SGST_rate, CGST_rate,
    //       IGST_rate, CESS_rate, TCS_rate, SGST_Amount, CGST_Amount, IGST_Amount, CESS_Amount, TCS_Amount, flag, pextra1, pextra2, pextra3, pextra4, pextra5};
    //        string[] par = new string[26] { "@PPONo", "@PRevisionNo", "@PPOLine", "@PItemCode", "@PQuantity", "@PUnit", "@PCurrency", "@PPrice",
    //         "@PAssessableValue","@PTaxCode","@PSGSTrate ","@PCGSTrate","@PIGSTrate","@PCESSrate","@PTCSrate","@PSGSTAmount","@PCGSTAmount", "@PIGSTAmount",
    //         "@PCESSAmount","@PTCSAmount","@flag", "@pextra1", "@pextra2", "@pextra3", "@pextra4", "@pextra5" };
    //        //objconnectip.getExecuteNonQuery("tax_typemastsave", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
    //        ds = objconnectip.getDataAdapter("Pur_polinesave", "PUR_TaxCodes", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
    //        objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());


    //    }
    //    catch (Exception ex)
    //    {
    //        string msg = ex.Message;
    //    }
    //    return ds;

    //}
    ////copy of po



    [Ajax.AjaxMethod]
    public DataSet hdr_savedet(string ponosave, string rivision_no, string line_no, string Item_Code, string Quantity, string Unit, string currency, string Price_per_unit, string Assessable_Value, string Tax_Code, string SGST_rate, string CGST_rate,
        string IGST_rate, string CESS_rate, string TCS_rate, string SGST_Amount, string CGST_Amount, string IGST_Amount, string CESS_Amount, string TCS_Amount, string flag, string pextra1, string pextra2, string pextra3, string pextra4, string pextra5)
    {

        DataSet ds = new DataSet();
        try
        {

            forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), ConfigurationSettings.AppSettings["ConnectionString"].ToString());
            objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

            string[] parval = new string[26] { ponosave,rivision_no, line_no, Item_Code, Quantity, Unit,currency, Price_per_unit, Assessable_Value, Tax_Code, SGST_rate, CGST_rate,
           IGST_rate, CESS_rate, TCS_rate, SGST_Amount, CGST_Amount, IGST_Amount, CESS_Amount, TCS_Amount, flag, pextra1, pextra2, pextra3, pextra4, pextra5};
            string[] par = new string[26] { "@PPONo", "@PRevisionNo", "@PPOLine", "@PItemCode", "@PQuantity", "@PUnit", "@PCurrency", "@PPrice",
             "@PAssessableValue","@PTaxCode","@PSGSTrate ","@PCGSTrate","@PIGSTrate","@PCESSrate","@PTCSrate","@PSGSTAmount","@PCGSTAmount", "@PIGSTAmount",
             "@PCESSAmount","@PTCSAmount","@flag", "@pextra1", "@pextra2", "@pextra3", "@pextra4", "@pextra5" };
            //objconnectip.getExecuteNonQuery("tax_typemastsave", "PUR_Taxtype", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
            ds = objconnectip.getDataAdapter("Pur_polinesave", "PUR_TaxCodes", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
            objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());


        }
        catch (Exception ex)
        {
            string msg = ex.Message;
        }
        return ds;

    }

}