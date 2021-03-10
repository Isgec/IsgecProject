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



public partial class Leftbar : System.Web.UI.UserControl
{

    public string tree = "";

    public void Page_Load(object sender, EventArgs e)
    {


        //Ajax.Utility.RegisterTypeForAjax(typeof(EnterPage));
        //Ajax.Utility.RegisterTypeForAjax(typeof(ClientMaster));

        // Put user code to initialize the page here
        //dynamictreeview();

        Response.Expires = -1;
        Response.Buffer = true;
        Response.ExpiresAbsolute = DateTime.Now.AddDays(-1d);
        Response.Expires = -1500;
        Response.CacheControl = "no-cache";



        if (Session["compcode"] == null)
        {
            Response.Redirect("login.aspx");
        }
        else
        {


            hiddencompcode.Value = Session["compcode"].ToString();
        }

       // dynamictreeview();


    }




    public void dynamictreeview()
    {

        tree += "<table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"200\" id = 'table1' >";
        tree += "<tr>";
        tree += "<td valign=\"top\">";
        tree += "<a onClick=\"toggle(this)\" class=\"folder\"><img src=\"plus.gif\">Collection</a>";


        //tree += "<div style=\"display:none;\">";
        //tree += "<a onClick=\"toggle(this)\" class=\"folder\">&nbsp;&nbsp;&nbsp;<img src=\"plus.gif\">Booking Scheduling</a>";
        //tree += "<div style=\"display:none;\">";
        //tree += "<a onClick=\"toggle(this)\" class=\"folder\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=\"plus.gif\">Master</a>";

        //tree += "<div  style=\"display:none;\">";
        //tree += "<a onClick=\"toggle1(this,'group1')\" class=\"folder\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=\"plus.gif\">Agency/Client Master</a>";
        ////tree += "<div id=\"group1\" style=\"display:none;\">";
        //tree += "<a  class=\"folder\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=\"minus.gif\"></a><a style=\"{text-decoration:none}\" class=\"nodescription\" onClick=\"window.open(''+formname+'.aspx','','width='+screen.availWidth+',height='+screen.availHeight+',resizable=1,left=0,top=0,scrollbars=yes') >Rceipt Entry Form</a>";

      

       

        //tree += "<a onClick=\"toggle(this)\" class=\"folder\">&nbsp;&nbsp;<img src=\"plus.gif\">Reports</a>";

        tree += "<div style=\"display:none;\">";
        tree += "<a  class=\"folder\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=\"minus.gif\"></a><a style=\"{text-decoration:none}\"  class=\"nodescription\" onClick=\"window.open(''+formname+'.aspx','','width='+screen.availWidth+',height='+screen.availHeight+',resizable=1,left=0,top=0,scrollbars=yes') >Rceipt Entry Form</a>";


        //tree += "<table border=\"0\" width=\"100%\">";
        //tree += "<tr>";
        //tree += "<td valign=\"top\">";
        ////tree +="<br>";
        //tree += "<a onClick=\"folder\" class=\"folder\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=\"minus.gif\"></a><a style=\"{text-decoration:none}\"  class=\"nodescription\" href=\"javascript:date();\">Preferences</a>";



        //tree += "</td>";
        //tree += "</tr>";
        //tree += "</table>";

        //tree += "</div>";



        //tree += "</td>";
        //tree += "</tr>";
        //tree += "</table>";


        //tree += "<table border=\"0\" width=\"100%\">";
        //tree += "<tr>";
        //tree += "<td valign=\"top\">";


        //tree += "<a  class=\"folder\">&nbsp;&nbsp;<img src=\"minus.gif\"></a><a style=\"{text-decoration:none}\" class=\"nodescription\" OnClick=\"javascript: home('Enter Page');\">Home Page</a>";

        //tree += "</td>";
        //tree += "</tr>";
        //tree += "</table>";

        //			tree +="<table border=\"0\" width=\"100%\">";
        //			tree +="<tr>";
        //			tree +="<td valign=\"top\">";
        //			//tree +="<br>";
        //			tree +="<a  class=\"folder\">&nbsp;&nbsp;<img src=\"minus.gif\"></a><a style=\"{text-decoration:none}\"  class=\"nodescription\" href=\"javascript: logout();\">Log Out</a>";
        //
        //
        //
        //
        //			tree +="</td>";
        //			tree +="</tr>";
        //			tree +="</table>";



        //tree += "</div>";
        //tree += "</td>";
        //tree += "</tr>";
        //tree += "</table>";




    }

}