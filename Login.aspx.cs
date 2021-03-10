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

public partial class login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        DataSet objDataSet = new DataSet();
        // Read in the XML file
        objDataSet.ReadXml(Server.MapPath("XML/login.xml"));
        lblcenter.Text = objDataSet.Tables[0].Rows[0].ItemArray[0].ToString();
        lblqbc.Text = objDataSet.Tables[0].Rows[0].ItemArray[1].ToString();
        lbusername.Text = objDataSet.Tables[0].Rows[0].ItemArray[2].ToString();
        lbpassword.Text = objDataSet.Tables[0].Rows[0].ItemArray[3].ToString();
        //btnlogin.Text = objDataSet.Tables[0].Rows[0].ItemArray[4].ToString();
        Ajax.Utility.RegisterTypeForAjax(typeof(login));
        //drpqbc.Items.Clear();
        //drpusername.Items.Clear();
        hiddenmysql.Value = ConfigurationSettings.AppSettings["ConnectionType"].ToString();
        if (!Page.IsPostBack)
        {
            //Ajax.Utility.RegisterTypeForAjax(typeof(login));

            {
                bindagencydrp();
            }

            drpcenter.Attributes.Add("OnChange", "javascript:return bindQBC();");
            btnlogin.Attributes.Add("Onclick", "javascript:return login1();");
            drpqbc.Attributes.Add("OnChange", "javascript:return bindUser();");
            //drpcenter.Attributes.Add("onkeypress", "return keySort(this);");
            //drpqbc.Attributes.Add("onkeypress", "return keySort(this);");
            //drpusername.Attributes.Add("onkeypress", "return keySort(this);");


        }
        fillPubCenter();
        //UserLabel.Value = Session["Username"].ToString();
    }
         /*new change ankur 28 feb*/
    public void bindagencydrp()
    {
        DataSet ds =new DataSet();
        
        if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "sql")
        {

            Collection.Classes.login logindetail = new Collection.Classes.login();

            ds = logindetail.getPubCenter();
        }

        else
            if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "orcl")
            {

                Collection.classesoracle.login logindetail = new Collection.classesoracle.login();

                ds = logindetail.getPubCenter();
                
            }
               
        
    }
    [Ajax.AjaxMethod]
    public DataSet fillUser(string qbc)
    {
        DataSet ds=new DataSet();
        if(ConfigurationSettings .AppSettings ["ConnectionType"].ToString ()=="sql" )
        {
   
        Collection.Classes.login logindetail = new Collection.Classes.login();
     
        ds = logindetail.getUser(qbc);
       
        }
        else
            if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "orcl")
            {
                Collection.classesoracle.login logindetail = new Collection.classesoracle.login();

                ds = logindetail.getUser(qbc);

            }
        
    return ds;
   
    }
    [Ajax.AjaxMethod]
    public DataSet fillQBC(string pubcenter)
    {
        DataSet ds= new DataSet();
        
        /*if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "sql")
        {
            Collection.Classes.login logindetail = new Collection.Classes.login();
           
            ds = logindetail.getQBC(pubcenter);
            
        }
            else
            if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "orcl")
            
            {
                Collection.classesoracle.login logindetail = new Collection.classesoracle.login();

                ds = logindetail.getQBC(pubcenter);

            }*/

        //---------------for branch----------------
        if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "sql")
        {
            Collection.Classes.login unit = new Collection.Classes.login();
            ds = unit.bindbranchforlogin(pubcenter);
        }
        else
            if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "orcl")
            {
                Collection.classesoracle.login unit = new Collection.classesoracle.login();
                ds = unit.bindbranchforlogin(pubcenter);
            }
        //-----------------end-----------------
       
    return ds;
    }
    private void fillPubCenter()
    {
        DataSet ds= new DataSet();
        drpcenter.Items.Clear();
        if(ConfigurationSettings .AppSettings ["ConnectionType"].ToString ()=="sql")
        {

        Collection.Classes.login logindetail = new Collection.Classes.login();
       
        ds = logindetail.getPubCenter();
        }
        else
            if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "orcl")
            {
                Collection.classesoracle.login logindetail = new Collection.classesoracle.login();

                ds = logindetail.getPubCenter();

            }
        
        
        ListItem li1;
        li1 = new ListItem();
        li1.Text = "Select Center";
        li1.Value = "0";
        li1.Selected = true;
        drpcenter.Items.Add(li1);

        int i;
        for (i = 0; i < ds.Tables[0].Rows.Count; i++)
        {
            ListItem li;
            li = new ListItem();
            li.Text = ds.Tables[0].Rows[i].ItemArray[1].ToString();
            li.Value = ds.Tables[0].Rows[i].ItemArray[0].ToString();
            drpcenter.Items.Add(li);
        }

    }

    /*new change ankur 28 feb*/
    [Ajax.AjaxMethod]
    public DataSet getuser_agency(string code_agency)
    {
        DataSet ds = new DataSet();
        if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "sql")
        {
            //Collection.Classes.login useragency = new Collection.Classes.login();

            //ds = useragency.getuser_login(code_agency);

        }

        else
            if (ConfigurationSettings.AppSettings["ConnectionType"].ToString() == "orcl")
            {
                Collection.classesoracle.login useragency = new Collection.classesoracle.login();

                ds = useragency.getuser_login(code_agency);
            }
        
        return ds;

    }

   
    //protected void btnsave_Click(object sender, EventArgs e)
    //{
    //    try
    //        {
    //            if (Txtusernme.Text.Trim() != "" || txtpwd.Text.Trim() != "")
    //            {
    //                Collection.Classes.login logindetail = new Collection.Classes.login();
    //                DataSet ds;
    //                string Username = Txtusernme.Text;
    //                string password = txtpwd.Text;
    //                ds = logindetail.chklogin(Username, password);
    //                //ds.WriteXml(Server.MapPath("Employees2.xsd"));
    //                if (ds.Tables[0].Rows.Count > 0)
    //                {
    //                    Session["Username"] = ds.Tables[0].Rows[0].ItemArray[0].ToString();
    //                    Session["userid"] = ds.Tables[0].Rows[0].ItemArray[2].ToString();
    //                    Session["compcode"] = ds.Tables[0].Rows[0].ItemArray[4].ToString();
    //                    Session["dateformat"] = ds.Tables[0].Rows[0].ItemArray[3].ToString();
    //                    
    //                    Session["autogenerated"] = ds.Tables[0].Rows[0].ItemArray[5].ToString();
    //                    //Response.Redirect("EnterPage.aspx");
    //                    //Response.Redirect("Adsize_master.aspx");
    //                    //Response.Redirect("Agent_master.aspx");
    //                    //Response.Redirect("Revenue_master.aspx");
    //                    //Response.Redirect("CombinationMaster.aspx");
    //                    //Response.Redirect("Bullet_master.aspx");
    //                    //Response.Redirect("Premium_typ_master.aspx");
    //                    //Response.Redirect("RepMast.aspx");
    //                    //Response.Redirect("Pageparametermaster.aspx");
    //                    //Response.Redirect("Adv_booking.aspx");
    //                    //Response.Redirect("UOM.aspx");
    //                    //Response.Redirect("Currencymaster.aspx");
    //                    //Response.Redirect("Contractmaster.aspx");
    //                    Response.Redirect("Default.aspx");
    //                    //Response.Redirect("ProductMaster.aspx");
    //                    //Response.Redirect("Clientrolemaster.aspx");
    //                    // Response.Redirect("AgencyTypeMaster.aspx");
    //                    //Response.Redirect("ClientMaster.aspx");
    //                }
    //                else
    //                {
    //                    Response.Write("<script>alert('Invalid Username Or Password');</script>");
    //                }
    //            }
    //            //else
    //            //{
    //            //    Response.Write("<script>alert('Invalid Username Or Password');</script>");
    //            //}

    //        }
    //        catch(Exception ex)
    //        {
    //            throw(ex);
    //        }
    //    }

    protected void btnlogin_Click(object sender, EventArgs e)
    {

    }
}

