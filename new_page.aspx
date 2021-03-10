<%@ Page Language="C#" AutoEventWireup="true" CodeFile="new_page.aspx.cs" Inherits="new_page" EnableEventValidation="false" %>

<%@ Register TagPrefix="uc1" TagName="Topbar" Src="~/Topbarnew_n.ascx" %>
<%@ Register TagPrefix="uc2" TagName="Leftbar" Src="~/Leftbar.ascx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>PO Master</title>
    <link href="css/store.css" rel="stylesheet" />
    <link href="css/main.css" rel="Stylesheet" />
    <link href="css/4.3.1/bootstrap.min.css" rel="stylesheet" />
    <script type="text/javascript" src="javascript/jquery.min.js"></script>
    <script type="text/javascript" src="javascript/jquery.freezeheader.js"></script>
    <script type="text/javascript" src="javascript/CommonFunction_New.js"></script>
    <script type="text/javascript" src="javascript/popupcalender.js"></script>
    <script type="text/javascript" language="javascript" src="javascript/popcalendar.js"></script>
    <script type="text/javascript" src="javascript/new_page.js"></script>
    <style>
        .gridinputclassnew {
            width: calc(100% - 0px);
            width: -webkit-calc(100% - 0px);
            background-color: #ffffff;
            font-family: Arial, Helvetica, sans-serif;
            font-size: 10px;
            text-transform: uppercase;
            text-align: left;
            border: 1px solid #929292;
            color: #000000;
        }

        .legend {
            display: block;
            width: 12%;
            max-width: 100%;
            padding: 0;
            margin-bottom: .5rem;
            font-size: 1.5rem;
            line-height: inherit;
            color: inherit;
            white-space: normal;
        }
        .legendnew {
          
            display: block;
            width: 4%;
            max-width: 100%;
            padding: 0;
            margin-bottom: .5rem;
            font-size: 1.5rem;
            line-height: inherit;
            color: blue;
            white-space: normal;
       
        }
    </style>
</head>
<body onload="javascript:return clearclick();" style="background-color: #f3f6fd; margin: 0px 0px 0px 0px">
    <form id="form1" runat="server">
    <div id="divbpcode" style="position: absolute; top: 0px; left: 0px; border: none;
        display: none; z-index: 1;" class="f2_div">
        <table cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <asp:ListBox ID="lstbpcode" Width="400px" Height="150px" runat="server" CssClass="btextlist">
                    </asp:ListBox>
                </td>
            </tr>
        </table>
    </div>
    <div id="divitemcode" style="position: absolute; top: 0px; left: 0px; border: none;
        display: none; z-index: 1;" class="f2_div">
        <table cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <asp:ListBox ID="lstitemcode" Width="400px" Height="150px" runat="server" CssClass="btextlist">
                    </asp:ListBox>
                </td>
            </tr>
        </table>
    </div>
        
    <div id="divtaxtypcdgrid" style="background-color: #f3f6fd; position: absolute; top: 0px;
        left: 0px; z-index: 3; width: inherit; border: 1px solid black; display: none;"
        class="f2_div">
        <table cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <asp:ListBox ID="lsttaxtypcdgrid" Width="400px" Height="150px" runat="server" CssClass="btextlist">
                    </asp:ListBox>
                </td>
            </tr>
        </table>
    </div>

          <div id="divsuplircode" style="position: absolute; top: 0px; left: 0px; border: none;
        display: none; z-index: 1;" class="f2_div">
        <table cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <asp:ListBox ID="lstsuplircode" Width="400px" Height="150px" runat="server" CssClass="btextlist">
                    </asp:ListBox>
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
                    <table id="RightTable" cellpadding="0" cellspacing="0" border="0px" style="margin-top: 0px; vertical-align: top; width: 1000px">
                        <tr>
                            <td width="200px">&nbsp;
                            </td>
                            <td valign="top">
                                <asp:ImageButton ID="btnNew" runat="server" Font-Size="XX-Small" BackColor="Control"
                                    BorderStyle="Outset" Font-Bold="True"></asp:ImageButton>
                                <asp:ImageButton ID="btnSave" runat="server" Font-Size="XX-Small" BackColor="Control"
                                    BorderStyle="Outset" BorderColor="DarkGray" Font-Bold="True"></asp:ImageButton>
                                <asp:ImageButton ID="btnModify" runat="server" Font-Size="XX-Small" BackColor="Control"
                                    BorderStyle="Outset" BorderColor="DarkGray" Font-Bold="True" Enabled="false"></asp:ImageButton>
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
                                <asp:ImageButton ID="btnExit" runat="server" Font-Size="XX-Small" BackColor="Control"
                                    BorderStyle="Outset" BorderColor="DarkGray" Font-Bold="True"></asp:ImageButton>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <div class="col-sm-12" style="margin-bottom: 10px;">
            <div class="row">
                <div class="col-sm-6">
                    <fieldset style="border: 2px solid #7DAAE3; height: auto;">
                        <legend class="legend" style="color: #00008B; font-family: Arial; font-size: 11px; font-weight: bold">PO Detail</legend>
                        <div class="row" id="Div3" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblpo" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtpo" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-sm-1"></div>
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblpodate" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">

                                    <asp:TextBox ID="txtpodat" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>

                        </div>
                        <div class="row" id="Div4" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblrevision" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtrevision" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-sm-1"></div>
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblrreason" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtrreason" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="Div1" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblerpno" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:DropDownList ID="txterpno" runat="server" CssClass="TextFieldNew" Width="120px">
                                        <asp:ListItem Text="200" Value="200"></asp:ListItem>
                                        <asp:ListItem Text="651" Value="651"></asp:ListItem>
                                        <asp:ListItem Text="700" Value="700"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </div>
                    </fieldset>
                </div>
                <%--<div class="col-sm-1"></div>--%>
                <div class="col-sm-6">
                    <fieldset style="border: 2px solid #7DAAE3; height: auto;">
                        <legend class="legend" style="color: #00008B; font-family: Arial; font-size: 11px; font-weight: bold">Supplier</legend>
                        <div class="row" id="Div2" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblsupcode" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtsupcode" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-sm-1"></div>
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblisgecgstin" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtisgecgstin" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>

                        </div>
                        <div class="row" id="Div45" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblgstin" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtgstin" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-sm-1"></div>
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblquationno" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtquationno" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <div class="row" id="Div5" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblqudt" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtqudt" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>

                            </div>
                        </div>
                    </fieldset>
                </div>
            </div>
        </div>
        <div class="col-sm-12" style="margin-bottom:20px;">
            <div class="row">
                <div class="col-sm-6">
                    <fieldset style="border: 2px solid #7DAAE3; height: 156px;">
                        <legend class="legend" style="color: #00008B; font-family: Arial; font-size: 11px; font-weight: bold">Delivery</legend>
                        <div class="row" id="Div6" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lbldelveryon" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtdelveryon" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-sm-1"></div>
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblpymntterm" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtpymntterm" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                         <div class="col-sm-1"></div>
                        <div class="row" id="Div7" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblinsurance" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtinsurance" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-sm-1"></div>
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lbldispatch" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtdispacth" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                         <div class="col-sm-1"></div>
                        <div class="row" id="Div8" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lbldes" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtdes" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </fieldset>
                </div>
                <%--<div class="col-sm-1"></div>--%>
                <div class="col-sm-6">
                    <fieldset style="border: 2px solid #7DAAE3; height: auto;">
                        <legend class="legend" style="color: #00008B; font-family: Arial; font-size: 11px; font-weight: bold">Other Detail</legend>
                        <div class="row" id="Div9" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblaprvdt" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:DropDownList ID="txtaprvdt" runat="server" CssClass="TextFieldNew" Width="120px">
                                        <asp:ListItem Text="Audit" Value="Audit"></asp:ListItem>
                                        <asp:ListItem Text="Materials" Value="Materials"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                             <div class="col-sm-1"></div>
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblstatus" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtstatus" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="Div10" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblremrks" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtremrks" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                             <div class="col-sm-1"></div>
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblreject" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtreject" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="Div11" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblcrtdby" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtcrtdby" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                             <div class="col-sm-1"></div>
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblcrtdon" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtcrtdon" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="Div12" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblsentaprv" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtsentaprv" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                             <div class="col-sm-1"></div>
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblaprvon" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtaprvon" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="Div13" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblaprovedby" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtaprovedby" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                             <div class="col-sm-1"></div>
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblapprovedon" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtaprovedon" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                    </fieldset>
                </div>
            </div>
        </div>

        <div class="col-sm-12">
            <fieldset style="width: 100%; float: left; margin-top: 10px; border: 2px solid #094A9C; padding: 0px 10px 0px 0px; height: auto;">
                <legend class="legendnew" style="color: #00008B; font-family: Arial; font-size: 11px; font-weight: bold">PO line</legend>
                <div style="text-align: end;">
                    <input type="button" runat="server" id="BtnAddRow" value="Add Row" onclick="javascript: return CommonCreateRow('new_page');"
                        style="width: 70px; height: 22px; text-align: center; font-size: 11px; font-family: Verdana;" />
                </div>
                <div id="divpogrid" runat="server" style="margin-bottom: 10px; height:120px;overflow:auto;"></div>
            </fieldset>
        </div>

        <input type="hidden" runat="server" id="hiddendateformat" />
        <input type="hidden" runat="server" id="hdnbconnec" />
        <input type="hidden" runat="server" id="HDN_server_date" />
        <input type="hidden" runat="server" id="dateformat" />
        <input type="hidden" runat="server" id="hdntxtDate" />
        <input type="hidden" runat="server" id="hdnflag" />
        <input type="hidden" runat="server" id="hdnstatusflag" />
        <input type="hidden" runat="server" id="hdnbpcode" />
        <input type="hidden" runat="server" id="hdnsupcode" />
    </form>
</body>
</html>
