<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TaxTypeMaster.aspx.cs" Inherits="TaxTypeMaster"  EnableEventValidation="false"%>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register TagPrefix="uc1" TagName="Topbar" Src="~/Topbarnew_n.ascx" %>
<%@ Register TagPrefix="uc2" TagName="Leftbar" Src="~/Leftbar.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Tax Type Master</title>
    <link href="css/store.css" rel="stylesheet" />
    <link href="css/main.css" rel="Stylesheet" />
</head>
<body  style="background-color: #f3f6fd; margin: 0px 0px 0px 0px" onload="javascript:return clearclick();">
    <form id="form1" runat="server">

    <table id="OuterTable" width="1000px" border="0" cellpadding="0" cellspacing="0">
        <tr valign="top">
            <td colspan="2">
                <uc1:Topbar ID="Topbar1" runat="server" Text="Composit Receipt Entry"></uc1:Topbar>
            </td>
        </tr>
        <tr>
            <td valign="top" id="frsttd" style="width: 1000px;">
                <table id="RightTable" cellpadding="0" cellspacing="0" border="0px" style="margin-top: 0px;
                    vertical-align: top; width: 1000px">
                    <tr>
                        <td width="100px">
                            &nbsp;
                        </td>
                        <td valign="top">
                            <asp:ImageButton ID="btnNew" runat="server" Font-Size="XX-Small" BackColor="Control"
                                BorderStyle="Outset" Font-Bold="True"></asp:ImageButton>
                            <asp:ImageButton ID="btnSave" runat="server" Font-Size="XX-Small" BackColor="Control"
                                BorderStyle="Outset" BorderColor="DarkGray" Font-Bold="True"></asp:ImageButton>
                            <asp:ImageButton ID="btnModify" runat="server" Font-Size="XX-Small" BackColor="Control"
                                BorderStyle="Outset" BorderColor="DarkGray" Font-Bold="True" Enabled="false">
                            </asp:ImageButton>
                            <asp:ImageButton ID="btnQuery" runat="server" Font-Size="XX-Small" BackColor="Control"
                                BorderStyle="Outset" BorderColor="DarkGray" Font-Bold="True"></asp:ImageButton>
                            <asp:ImageButton ID="btnExecute" runat="server" Font-Size="XX-Small" BackColor="Control"
                                BorderStyle="Outset" Font-Bold="True"></asp:ImageButton>
                            <asp:ImageButton ID="btnCancel" runat="server" Font-Size="XX-Small" BackColor="Control"
                                BorderStyle="Outset" BorderColor="DarkGray" Font-Bold="True"></asp:ImageButton>
                            <asp:ImageButton ID="btnfirst" runat="server" Font-Size="XX-Small" BackColor="Control"
                                BorderStyle="Outset" BorderColor="DarkGray" Font-Bold="True"></asp:ImageButton>
                            <asp:ImageButton ID="btnprevious" runat="server" Font-Size="XX-Small" BackColor="Control"
                                BorderStyle="Outset" Font-Bold="True"></asp:ImageButton>
                            <asp:ImageButton ID="btnnext" runat="server" Font-Size="XX-Small" BackColor="Control"
                                BorderStyle="Outset" BorderColor="DarkGray" Font-Bold="True"></asp:ImageButton>
                            <asp:ImageButton ID="btnlast" runat="server" Font-Size="XX-Small" BackColor="Control"
                                BorderStyle="Outset" BorderColor="DarkGray" Font-Bold="True"></asp:ImageButton>
                             <asp:ImageButton ID="btnDelete" runat="server" Font-Size="XX-Small" BackColor="Control"
                                BorderStyle="Outset" BorderColor="DarkGray" Font-Bold="True"></asp:ImageButton>
                            <asp:ImageButton ID="btnExit" runat="server" Font-Size="XX-Small" BackColor="Control"
                                BorderStyle="Outset" BorderColor="DarkGray" Font-Bold="True"></asp:ImageButton>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <div>
        <fieldset style="width: 75%; padding-left: 10px; float: left; margin-top: 10px; border: 2px solid #7DAAE3;
            margin-left: 100px; padding: 10px 10px 10px 10px; height: auto;">
            <legend style="color: #00008B; font-family: Arial; font-size: 13px; font-weight: bold">
                Tax Type Master</legend>
            <div style="text-align: left; width: 100%; float: left; padding: 1px 1px 1px 1px;">
                <div style="width: 16%; float: left;">
                    <asp:Label ID="lbltaxtypcd" runat="server" CssClass="lbtxt"></asp:Label>
                </div>
                <div style="width: 17%; float: left;">
                    <asp:TextBox ID="txttaxtypcd" runat="server" CssClass="TextFieldNew" Width="165px"></asp:TextBox>
                </div>

                
                <div style="width: 14%; float: left; margin-left: 2%;">
                    <asp:Label ID="lbldescription" runat="server" CssClass="lbtxt"></asp:Label>
                </div>
                <div style="width: 17%; float: left;">
                    <asp:TextBox ID="txtdescription" runat="server" CssClass="TextFieldNew" Width="162px"  ></asp:TextBox>
                </div>

                  <div style="width: 14%; float: left; margin-left: 2%;">
                    <asp:Label ID="lbldrop" runat="server" CssClass="lbtxt"></asp:Label>
                </div>
                <div style="width: 17%; float: left;" >
                   <asp:Dropdownlist id="drpdownn" runat="server" Width="162px" CssClass="TextFieldNew">
                       <asp:Listitem value="CGST" text="CGST"></asp:Listitem>
                       <asp:Listitem value="SGST" text="SGST"></asp:Listitem>
                       <asp:Listitem value="IGST" text="IGST"></asp:Listitem>
                       <asp:Listitem value="CESS" text="CESS"></asp:Listitem>
                       <asp:Listitem value="TCS" text="TCS"></asp:Listitem>
                   </asp:Dropdownlist>
                </div>
            </div>
        </fieldset>
        <div id="taxtypemaster" style="width: 50%; position: absolute; height: auto;
            overflow: auto; z-index: 2; top: 160px; left: 50px; display:block;">
            <fieldset id="DivItemDetail" style="width: 50%; border-style: double; border-width: 2px;
                border-color: #7DAAE3; margin-top: 10px; margin-left: 50px; height: 200px;">
                <legend style="color: #00008B; font-family: Arial; font-size: 13px; font-weight: bold">
                    Details</legend>
                <div runat="server" id="view" style="width: 100%; height: 160px; overflow-y: scroll;
                    border: 2px solid #7DAAE3; float: left; margin: 2px 2px 2px 2px; z-index: auto">
                </div>
                <div style="width: 90%;">
                    <input type="button" runat="server" id="BtnAddRow" value="Add Row" onclick="javascript: return CommonCreateRow('taxtypemaster1');"
                        style="width: 70px; height: 22px; text-align: center; font-size: 11px; font-family: Verdana;" />
                    <input type="button" runat="server" id="btncancle" value="exit" onclick="javascript: return ChqbouGridClose('taxtypemaster1');"
                        style="width: 70px; height: 22px; text-align: center; font-size: 11px; font-family: Verdana; display:none;" />
                </div>
            </fieldset>
        </div>
    </div>
       
          <div runat="server" id="taxtypemasterview" style="width: 77%; height: 160px; overflow-y: scroll;
                    border: 2px solid #7DAAE3; float: left; margin: 2px 99px 99px 99px; z-index: auto; top: 260px; left: 50px; margin-top: 230px;">
                </div>
    
    <input type="hidden" runat="server" id="hiddendateformat" />
    <input type="hidden" runat="server" id="hdnbconnec" />
    <input type="hidden" runat="server" id="HDN_server_date" />
    <input type="hidden" runat="server" id="dateformat" />
    <input type="hidden" runat="server" id="hdntxtDate" /> 
    <input type="hidden" runat="server" id="hdnflag" /> 
    <input type="hidden" runat="server" id="hdnstatusflag" />
        <input type="hidden" runat="server" id="hdncompname" />
        <input type="hidden" runat="server" id="hdnconnectionstring" /> 

    </form>
</body>

<script type="text/javascript" src="javascript/jquery.min.js"></script>

<script type="text/javascript" src="javascript/jquery.freezeheader.js"></script>

<script type="text/javascript" src="javascript/CommonFunction_New.js"></script>

<script type="text/javascript" src="javascript/popupcalender.js"></script>
<script type="text/javascript" language="javascript" src="javascript/popcalendar.js"></script>
<script type="text/javascript" src="javascript/TaxTypeMaster.js"></script>
</html>
