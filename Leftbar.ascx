<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Leftbar.ascx.cs" Inherits="Leftbar" %>


<%--<script language=javascript type="text/javascript" src="javascript/givepermission.js"></script>--%>
<table border="0" cellpadding="0" cellspacing="0">
    <tr style="vertical-align:top;">
        <td style="vertical-align:baseline;">
            <div id="tP1" class="topbarclock">
            </div>
        </td>
    </tr>
    <tr style="vertical-align:top;">
        <td style="background-image:url(images/leftbar.jpg);">
            <div id="FIND_LIST" style="BACKGROUND-IMAGE: url(http://localhost/Collection/images/leftbar.jpg); VISIBILITY:visible; "><%=tree%></div>
        </td>
    </tr>
    <tr style="vertical-align:top;">
        <td>
            <img src="images/leftbar.jpg" />
        </td>
    </tr>
</table><div style="display:none">
<asp:TextBox ID="closewin"  runat="server"></asp:TextBox></div>
<input id="hiddencompcode" runat=server type="hidden" />

<%--<script type="text/javascript">Clock();</script>--%>
