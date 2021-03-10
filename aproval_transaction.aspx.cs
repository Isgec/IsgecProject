using forQueryExecution;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class aproval_transaction : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DataSet ds1 = new DataSet();
        ds1.ReadXml(Server.MapPath("XML/aproval_trans.xml"));
        lblpono.Text = ds1.Tables[0].Rows[0].ItemArray[0].ToString();
        lblpodt.Text = ds1.Tables[0].Rows[0].ItemArray[1].ToString();

        Ajax.Utility.RegisterTypeForAjax(typeof(aproval_transaction));
         if (!Page.IsPostBack)
         {
             btnrun.Attributes.Add("onclick", "javascript:return EnableExecute();");
         }
    }
    [Ajax.AjaxMethod]
    public DataSet hdr_save(string PPONo, string PPoDate, string PRevisionNo, string Pstatus, string PQuatationNo, string PQuotationDate, string PBPCode, string PBPGSTIN, string PERPCompany,
  string PIsgecGSTIN, string PPaymentTerm, string PDeliveryTerm, string PModeofDispatch, string PDestination, string PInsurance, string PRemarks, string PApproverType, string PCreatedby,
  string PCreatedOn, string PSentforapprovalBy, string PSentforApprovalon, string PApprovedBy, string PApprovedOn, string PReasonofRevision, string PApproval_RejectionRemarks,
   string flag, string pextra1, string pextra2, string pextra3, string pextra4, string pextra5)
    {
        string dateformat = "dd/mm/yyyy";

        if (dateformat == "dd/mm/yyyy")
        {
            if (PPoDate != "")
            {
                string[] arr = PPoDate.Split('/');
                string dd = arr[0];
                string mm = arr[1];
                string yyyy = arr[2];
                PPoDate = mm + "/" + dd + "/" + yyyy;
            }
            else
            {
                PPoDate = "";
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

}