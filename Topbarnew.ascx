<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Topbarnew.ascx.cs" Inherits="Topbarnew" %>

<script language="javascript" src="javascript/tree.js"></script>

<%--<script language="javascript" src="javascript/TreeLibrary.js"></script>--%>

<table align="left" border="0" cellpadding="0" cellspacing="0" width="964">
    <tr valign="middle">
        <td valign="bottom">
            <img src="images/img_02A.jpg" width="964" />
            <img align="middle" alt="Ad Booking" height="25" src="images/top.jpg" width="964" />
            <%--<div id="1" class="Ads" style="visibility: visible">
                <table>
                    <tr>
                        <td>
                            <asp:Label ID="lbldisplay" runat="server" CssClass="DisplayAd" ForeColor="#5050A4"
                                onclick="javascript:return EnableAdBooking(this);"></asp:Label><asp:Label
                                    ID="Label2" runat="server" CssClass="ClassifiedAd" ForeColor="#5050A4"></asp:Label></td>
                        <td >
                            <asp:Label ID="Label3" runat="server" CssClass="Layout-X" ForeColor="#5050A4"> Layout-X |</asp:Label></td>
                        <td >
                            <asp:Label ID="Label4" runat="server" CssClass="News-Wrap" ForeColor="#5050A4"> News-Wrap |</asp:Label></td>
                        <td>
                            <asp:Label ID="Label5" runat="server" CssClass="newDAMS" ForeColor="#5050A4"> 4C-DAMS |</asp:Label></td>
                    </tr>
                </table>
            </div>--%>
            <div id="2" class="middlediv" style="visibility: hidden; vertical-align:top;">
                <a id="book" class="bookingandscheduling" href="#"></a><a
                    class="billing" href="#"></a> <a class="services" href="#"></a></div>
            <table width="900" style="top:0;">
                <tr>
                    <td id="td1" width="275" valign="top"   style="text-align:center; vertical-align:top;">
                        <div id="Formname" class="FormLabel" style="vertical-align:top;">
                            <%=Text%>
                        </div>
                    </td>
                    <td id="td2" width="677" valign="top"  style="text-align:center;">
                        <div id="Formnamezz" class="FormLabellog"  onclick="javascript:return logoutpage();">
                            Logout</div>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>

<script runat="server" language="C#">
    public String Text = "";
    
</script>

<script language="javascript">
function opendiv(q)
{
	document.getElementById(q).style.visibility = "visible"; 
	document.getElementById('book').style.color = "red";
}

</script>
