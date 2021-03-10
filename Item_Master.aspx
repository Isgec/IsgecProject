﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Item_Master.aspx.cs" Inherits="Item_Master"   EnableEventValidation="false"%>

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

         <div id="divuomcode" style="position: absolute; top: 0px; left: 0px; border: none; display: none; z-index: 1;"
            class="f2_div">
            <table cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <asp:ListBox ID="lstuomcode" Width="400px" Height="150px" runat="server" CssClass="btextlist"></asp:ListBox>
                    </td>
                </tr>
            </table>
        </div>

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
                Item Master</legend>
            <div style="text-align: left; width: 100%; float: left; padding: 1px 1px 1px 1px;">
                <div style="width: 16%; float: left;">
                    <asp:Label ID="lblitemuom" runat="server" CssClass="lbtxt"></asp:Label>
                </div>
                <div style="width: 17%; float: left;">
                    <asp:TextBox ID="txtitemuom" runat="server" CssClass="TextFieldNew" Width="165px"></asp:TextBox>
                </div>

                
                <div style="width: 14%; float: left; margin-left: 2%;">
                    <asp:Label ID="lblitemname" runat="server" CssClass="lbtxt"></asp:Label>
                </div>
                <div style="width: 17%; float: left;">
                    <asp:TextBox ID="txtitemname" runat="server" CssClass="TextFieldNew" Width="162px"  ></asp:TextBox>
                </div>

                  <div style="width: 14%; float: left; margin-left: 2%;">
                    <asp:Label ID="lblitemcode" runat="server" CssClass="lbtxt"></asp:Label>
                </div>
                <div style="width: 17%; float: left;" >
                  <asp:TextBox ID="txtitemcode" runat="server" CssClass="TextFieldNew" Width="162px"  ></asp:TextBox>
                </div>
            </div>
        </fieldset>
    </div>
       
          <div runat="server" id="taxitemmasterview" style="width: 77%; height: 160px; overflow-y: scroll;
                    border: 2px solid #7DAAE3; float: left; margin: 2px 99px 99px 99px; z-index: auto; top: 260px; left: 50px; margin-top: 230px;">
                </div>
    
    <input type="hidden" runat="server" id="hiddendateformat" />
    <input type="hidden" runat="server" id="hdnbconnec" />
    <input type="hidden" runat="server" id="HDN_server_date" />
    <input type="hidden" runat="server" id="dateformat" />
    <input type="hidden" runat="server" id="hdntxtDate" /> 
    <input type="hidden" runat="server" id="hdnflag" /> 
    <input type="hidden" runat="server" id="hdnstatusflag" />
        <input type="hidden" runat="server" id="hdnuomcode" />
        <input type="hidden" runat="server" id="hdncompname" />
        <input type="hidden" runat="server" id="hdnconnectionstring" /> 

    </form>
</body>

<script type="text/javascript" src="javascript/jquery.min.js"></script>
<script type="text/javascript" src="javascript/jquery.freezeheader.js"></script>
<script type="text/javascript" src="javascript/CommonFunction_New.js"></script>
<script type="text/javascript" src="javascript/Item_Master.js"></script>
</html>
