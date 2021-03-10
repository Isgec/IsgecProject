using forQueryExecution;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class history_of_po : System.Web.UI.Page
{

    int j = 1; 
    int i = 0;
    int sno = 1;
    protected void Page_Load(object sender, EventArgs e)
    {
        DataSet ds1 = new DataSet();
        ds1.ReadXml(Server.MapPath("XML/PurchasesOrder.xml"));
        dateformat.Value = "dd/mm/yyyy";
        DataSet objDataSetbu = new DataSet();
        objDataSetbu.ReadXml(Server.MapPath("XML/button.xml"));
        hdnuserid.Value = Request.QueryString["us"].ToString();
        hdnusername.Value = Request.QueryString["us"].ToString();
        Ajax.Utility.RegisterTypeForAjax(typeof(history_of_po));
        if (!Page.IsPostBack)
        {
            string formname = "Purchases History";
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

        DataSet ds = new DataSet();

        forQueryExecution.NandConnection objconnectip = new NandConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString(), hdnconnectionstring.Value);
                objconnectip.getConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());

                string[] parval = new string[7] { txtpono.Value, textrevisionno.Value, "", "", "", "", "" };
                string[] par = new string[7] {"@PPONo","@PRevisionNo","@pextra1","@pextra2","@pextra3","@pextra4","@pextra5"};
                ds = objconnectip.getDataAdapter("Pur_podetail", "PUR_TaxCodes", parval, par, ConfigurationSettings.AppSettings["ConnectionType"].ToString());
                objconnectip.closeConnection(ConfigurationSettings.AppSettings["ConnectionType"].ToString());





            Session["RowLen"] = ds.Tables[0].Rows.Count;
                DataGrid1.DataSource = ds;
                DataGrid1.DataBind();
    }

    protected void DataGrid1_ItemDataBound(object sender, DataGridItemEventArgs e)
    { 
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                
                string status = e.Item.Cells[6].Text;
                //e.Item.Cells[1].Text = "<a id='cio" + i + "' style=\"cursor:hand;color:blue\" onClick=\"openbooking('" + e.Item.Cells[1].Text + "','cio" + i + "','" + hiddenrowcount.Value + "','" + e.Item.Cells[4].Text + "','')\">" + e.Item.Cells[1].Text + "</a>";
                if (status == "Created" || status == "Rejected")
                {
                    //e.Item.Cells[6].Text = "<a style=\"cursor:hand;color:blue\" id='cio" + i + "'  onClick=\"openbooking('" + e.Item.Cells[2].Text + "','cio" + i + "','" + hiddenrowcount.Value + "','" + e.Item.Cells[4].Text + "','" + e.Item.Cells[7].Text + "',''  )\">" + e.Item.Cells[2].Text + "</a>";
                }
                i = i + 1;
            }
    }

}