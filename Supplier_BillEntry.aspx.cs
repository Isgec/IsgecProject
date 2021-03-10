using forQueryExecution;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Supplier_BillEntry : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DataSet ds1 = new DataSet();
        ds1.ReadXml(Server.MapPath("XML/Supplier_BillEntry.xml"));
        lblirno.Text = ds1.Tables[0].Rows[0].ItemArray[0].ToString();
        lblpurtype.Text = ds1.Tables[0].Rows[0].ItemArray[1].ToString();
        lbltrantype.Text = ds1.Tables[0].Rows[0].ItemArray[2].ToString();
        lblshiptostate.Text = ds1.Tables[0].Rows[0].ItemArray[3].ToString();
        lblpo.Text = ds1.Tables[0].Rows[0].ItemArray[4].ToString();
        lblsupname.Text = ds1.Tables[0].Rows[0].ItemArray[5].ToString();
        lblgstin.Text = ds1.Tables[0].Rows[0].ItemArray[6].ToString();
        lblisgecgstin.Text = ds1.Tables[0].Rows[0].ItemArray[7].ToString();
        lblbillno.Text = ds1.Tables[0].Rows[0].ItemArray[8].ToString();
        lblbilldate.Text = ds1.Tables[0].Rows[0].ItemArray[9].ToString();
        lblbillremark.Text = ds1.Tables[0].Rows[0].ItemArray[10].ToString();
        lblbilltotamt.Text = ds1.Tables[0].Rows[0].ItemArray[11].ToString();
        lbladviseno.Text = ds1.Tables[0].Rows[0].ItemArray[12].ToString();
        lblemployeeid.Text = ds1.Tables[0].Rows[0].ItemArray[13].ToString();
        lblcrtdby.Text = ds1.Tables[0].Rows[0].ItemArray[14].ToString();
        lblcrtdon.Text = ds1.Tables[0].Rows[0].ItemArray[15].ToString();

        //txtpodat.Text = DateTime.Now.ToString("dd/MM/yyyy");
        txtcrtdon.Text = DateTime.Now.ToString("dd/MM/yyyy");
        //txtrevision.Text = "0";
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
        hdnuserid.Value = Request.QueryString["us"].ToString();
        txtcrtdby.Text = Request.QueryString["us"].ToString();
        hdnusername.Value = Request.QueryString["us"].ToString();
        // dateformat.Value = "dd/mm/yyyy";
        Ajax.Utility.RegisterTypeForAjax(typeof(Supplier_BillEntry));
        if (!Page.IsPostBack)
        {
           
            hdncompname.Value = Request.QueryString["cm"].ToString();
            Session["comp_name"] = Request.QueryString["cm"].ToString();
            txtisgecgstin.Text = "09AAACT5540K2Z4";
            //txterpno.SelectedValue = Request.QueryString["cm"].ToString();
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


            if (Request.QueryString["irno"] != null)
            {
                btnExecute.Enabled = true;
                hdnirno.Value = Request.QueryString["irno"].ToString();
                // ScriptManager.RegisterClientScriptBlock(this, typeof(PurchasesOrder), "gettdscheck", "getrdncheck('" + pono12 + "')", true);
            }

            btnNew.Attributes.Add("onClick", "javascript:return EnabledOnNew()");
            btnSave.Attributes.Add("onclick", "javascript:return onsaveclick();");
            //btnsentfrapproval.Attributes.Add("onclick", "javascript:return onsaveclick();");
            btnCancel.Attributes.Add("onclick", "javascript:return clearclick1();");
            btnExit.Attributes.Add("onclick", "javascript:return Exit();");
            btnQuery.Attributes.Add("onclick", "javascript:return EnabledOnQuery();");
            btnnext.Attributes.Add("onclick", "javascript:return OnClickNext();");
            btnprevious.Attributes.Add("onclick", "javascript:return OnClickPrevious();");
            btnfirst.Attributes.Add("onclick", "javascript:return OnClickFirst();");
            btnlast.Attributes.Add("onclick", "javascript:return OnClickLast();");
            btnModify.Attributes.Add("onclick", "javascript:return OnClickModify();");
            btnExecute.Attributes.Add("onclick", "javascript:return EnableExecute();");

            txttrantype.Attributes.Add("onkeyup", "javascript:return bindbilltypecodef2(event)");
            lstbilltype.Attributes.Add("onclick", "javascript:return fillbilltypecode(event);");
            lstbilltype.Attributes.Add("onkeydown", "javascript:return fillbilltypecode(event);");

            txtshiptostate.Attributes.Add("onkeyup", "javascript:return bindhsnsaccodef2(event)");
            lsthsnsaccd.Attributes.Add("onclick", "javascript:return fillhsnsaccode(event);");
            lsthsnsaccd.Attributes.Add("onkeydown", "javascript:return fillhsnsaccode(event);");

            txtpo.Attributes.Add("onkeyup", "javascript:return bindemployeef2(event);");
            lstemployee.Attributes.Add("onclick", "javascript:return fillemployeecode(event);");
            lstemployee.Attributes.Add("onkeydown", "javascript:return fillemployeecode(event);");


            lstitemcode.Attributes.Add("onclick", "javascript:return fillitemcode(event);");
            lstitemcode.Attributes.Add("onkeydown", "javascript:return fillitemcode(event);");

            //drpcurrency.Attributes.Add("onchange", "javascript:return ConversionFactorChamge();");

            string formname = "IRN Entry";
            Session["formname"] = formname;
        }
    }
    string CheckValue(string value)
    {
        if (string.IsNullOrEmpty(value))
        {
            value = null;
        }
        return value;
    }
    [Ajax.AjaxMethod] // FETCH DATA
    public DataSet Bindbilltypecode(string billtype,  string extra1, string extra2, string extra3, string extra4, string extra5, string connstring)
    {
        DataSet ds = new DataSet();
        forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), connstring);
        objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

        string[] parval = new string[6] { billtype,  extra1, extra2, extra3, extra4, extra5 };
        string[] par = new string[6] { "@ptranCode", "@pextra1", "@pextra2", "@pextra3", "@pextra4", "@pextra5" };
        ds = objconnectip.getDataAdapter("bind_TransactionType", "pur_BillType", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        return ds;
    }

    [Ajax.AjaxMethod] // FETCH DATA
    public DataSet Bindhsnsaccode(string hsnsaccd, string extra1, string extra2, string extra3, string extra4, string extra5, string connstring)
    {
        DataSet ds = new DataSet();
        forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), connstring);
        objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

        string[] parval = new string[6] {  hsnsaccd, extra1, extra2, extra3, extra4, extra5 };
        string[] par = new string[6] { "@pstateCode", "@pextra1", "@pextra2", "@pextra3", "@pextra4", "@pextra5" };
        ds = objconnectip.getDataAdapter("bind_ShiptoState", "SPMT_HSNSACCodes", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        return ds;
    }

    [Ajax.AjaxMethod] // FETCH DATA
    public DataSet Bindemployeecode(string employee, string extra1, string extra2, string extra3, string extra4, string extra5, string connstring)
    {
        DataSet ds = new DataSet();
        forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), connstring);
        objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

        string[] parval = new string[6] { employee, extra1, extra2, extra3, extra4, extra5, };
        string[] par = new string[6] { "@PPONo", "@pextra1", "@pextra2", "@pextra3", "@pextra4", "@pextra5" };
        ds = objconnectip.getDataAdapter("bind_PoNo", "HRM_Employees", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        return ds;
    }
    [Ajax.AjaxMethod]
    public DataSet hdr_save(string PPONo, string TranTypeID, string SupplierName, string BillNumber, string BillDate, string CreatedBy, string TotalBillAmount, string AdviceNo, string IsgecGSTIN,
        string CreatedOn,string EmployeeID,string IRReceivedOn,string BillRemarks,string PurchaseType,string UploadBatchNo,string CostCenterID,string SupplierGSTIN,string SupplierGSTINNumber,
        string ShipToState,string BPID,string DepartmentID,string ElementID,string ProjectID,string irno,
   string flag, string pextra1, string pextra2, string pextra3, string pextra4, string pextra5, string connstring)
    {
        string dateformat = "dd/mm/yyyy";
        if (BillDate != "")
        {
            if (dateformat == "dd/mm/yyyy")
            {
                string[] arr = BillDate.Split('/');
                string dd = arr[0];
                string mm = arr[1];
                string yyyy = arr[2];
                BillDate = mm + "/" + dd + "/" + yyyy;
            }
        }
        if (dateformat == "dd/mm/yyyy")
        {
            if (CreatedOn != "")
            {
                string[] arr = CreatedOn.Split('/');
                string dd = arr[0];
                string mm = arr[1];
                string yyyy = arr[2];
                CreatedOn = mm + "/" + dd + "/" + yyyy;
            }
            else
            {
                CreatedOn = "";
            }
        }

        DataSet ds = new DataSet();
        try
        {

            forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), connstring);
            objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

            string[] parval = new string[22] {CheckValue(PPONo), CheckValue(TranTypeID), CheckValue(BillNumber), CheckValue(BillDate), CheckValue(CreatedBy), CheckValue(TotalBillAmount), CheckValue(AdviceNo), CheckValue(IsgecGSTIN),
                                              CheckValue(CreatedOn), CheckValue(EmployeeID),CheckValue(BillRemarks), CheckValue(PurchaseType),CheckValue(SupplierGSTIN),
                                              CheckValue(ShipToState), CheckValue(BPID),CheckValue(irno),CheckValue(flag), CheckValue(pextra1), CheckValue(pextra2), CheckValue(pextra3), CheckValue(pextra4), CheckValue(pextra5)};
            string[] par = new string[22] {"@porderno","@ptratypid","@pbillno","@pbilldt","@pcreatedby","@ptotalbillamt","@padviseno","@pisgecgstin",
                "@pcreateddt","@pemployeeid","@pbillremark","@ppurchasetype","@psuppliergstin","@pshiptost","@pbpid","@pirno","@pflag","@pextra1","@pextra2","@pextra3","@pextra4","@pextra5"};

            ds = objconnectip.getDataAdapter("Pur_SPMT_newSBHSave", "SPMT_newSBH", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
            objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());


        }
        catch (Exception ex)
        {
            string msg = ex.Message;
        }
        return ds;

    }



    [Ajax.AjaxMethod] // FETCH DATA
    public DataSet Bindpoline(string pono,string poline, string extra1, string extra2, string extra3, string extra4, string extra5, string connstring)
    {
        DataSet ds = new DataSet();
        forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), connstring);
        objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

        string[] parval = new string[7] { pono,poline, extra1, extra2, extra3, extra4, extra5, };
        string[] par = new string[7] { "@pono", "@poline", "@pextra1", "@pextra2", "@pextra3", "@pextra4", "@pextra5" };
        ds = objconnectip.getDataAdapter("bind_poline", "HRM_Employees", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());
        return ds;
    }


    [Ajax.AjaxMethod]
    public DataSet hdr_savedet(string irnosave, string pitemcode, string pbilltype, string phsnsaccd, string puom, string pquantity, string pcurrency, string pconversio, string paccessval, string pigstrate, string pigstamount, string psgstrate,
           string psgstamount,string pcgstrate,string pcgstamount,string pcessrate,string pcessamount,string ptotalgst,string ptotalamt,string ptotalgstinr,string ptotalamtinr,string pemployeeid,string pdepatmentid,string pcostcenterid,string ptcsrate,string ptcsamount,
           string connstring,string ppono,string ppoline,string pflag)
    {
       
        DataSet ds = new DataSet();
        try
        {

            forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), connstring);
            objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

            string[] parval = new string[29] {CheckValue(irnosave), CheckValue(pitemcode), CheckValue(pbilltype), CheckValue(phsnsaccd), CheckValue(puom), CheckValue(pquantity), CheckValue(pcurrency), CheckValue(pconversio), CheckValue(paccessval), CheckValue(pigstrate), CheckValue(pigstamount), CheckValue(psgstrate),
           CheckValue(psgstamount), CheckValue(pcgstrate), CheckValue(pcgstamount), CheckValue(pcessrate), CheckValue(pcessamount), CheckValue(ptotalgst), CheckValue(ptotalamt), CheckValue(ptotalgstinr), CheckValue(ptotalamtinr), CheckValue(pemployeeid), CheckValue(pdepatmentid), CheckValue(pcostcenterid), CheckValue(ptcsrate), CheckValue(ptcsamount),
           CheckValue(ppono), CheckValue(ppoline), CheckValue(pflag)};
            string[] par = new string[29] {"@pirno","@pitemcode","@pbilltype","@phsnsaccd","@puom","@pquantity","@pcurrency","@pconversio",
                "@paccessval","@pigstrate","@pigstamount","@psgstrate","@psgstamount","@pcgstrate","@pcgstamount","@pcessrate","@pcessamount","@ptotalgst","@ptotalamt",
                "@ptotalgstinr","@ptotalamtinr","@pemployeeid","@pdepatmentid","@pcostcenterid","@ptcsrate","@ptcsamount","@ppono","@ppoline","@pflag"};

            ds = objconnectip.getDataAdapter("SupplierBilldet_save", "SPMT_newSBH", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
            objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());


        }
        catch (Exception ex)
        {
            string msg = ex.Message;
        }
        return ds;

    }



}