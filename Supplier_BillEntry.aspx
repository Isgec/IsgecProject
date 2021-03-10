<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Supplier_BillEntry.aspx.cs" Inherits="Supplier_BillEntry" EnableEventValidation="false" %>

<%@ Register TagPrefix="uc1" TagName="Topbar" Src="~/Topbarnew_n.ascx" %>
<%@ Register TagPrefix="uc2" TagName="Leftbar" Src="~/Leftbar.ascx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>IRN ENTRY</title>
    <link href="css/store.css" rel="stylesheet" />
    <link href="css/main.css" rel="Stylesheet" />
    <link href="css/4.3.1/bootstrap.min.css" rel="stylesheet" />
    <style>
        .disbledbg {
        background-color:#efefef!important;
        }
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
    <link href="datecss/datecss1.css" rel="stylesheet" />
</head>
<body style="background-color: #f3f6fd; margin: 0px 0px 0px 0px"  onkeypress="javascript:return enterkeycode(event, this);" onload="javascript:return clearclick();">
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>       
        
        <div id="divitemcode" style="position: absolute; top: 0px; left: 0px; border: none; display: none; z-index: 1;"
            class="f2_div">
            <table cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <asp:ListBox ID="lstitemcode" Width="400px" Height="150px" runat="server" CssClass="btextlist"></asp:ListBox>
                    </td>
                </tr>
            </table>
        </div>
        <div id="divbilltype" style="position: absolute; top: 0px; left: 0px; border: none; display: none; z-index: 1;"
            class="f2_div">
            <table cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <asp:ListBox ID="lstbilltype" Width="400px" Height="150px" runat="server" CssClass="btextlist"></asp:ListBox>
                    </td>
                </tr>
            </table>
        </div>
        <div id="divhsnsaccd" style="position: absolute; top: 0px; left: 0px; border: none; display: none; z-index: 1;"
            class="f2_div">
            <table cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <asp:ListBox ID="lsthsnsaccd" Width="400px" Height="150px" runat="server" CssClass="btextlist"></asp:ListBox>
                    </td>
                </tr>
            </table>
        </div>
        <div id="divemployee" style="position: absolute; top: 0px; left: 0px; border: none; display: none; z-index: 1;"
            class="f2_div">
            <table cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <asp:ListBox ID="lstemployee" Width="400px" Height="150px" runat="server" CssClass="btextlist"></asp:ListBox>
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
                            <td width="200px"> <legend class="legend" style="color: #00008B; font-family: Arial; font-size: 16px; font-weight: bold; WIDTH: 200PX; PADDING-LEFT: 80PX;">IRN ENTRY</legend>
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
        <asp:UpdatePanel runat="server" ID="updatepanel1"><ContentTemplate>
        <div class="col-sm-12" style="margin-bottom: 10px;">
            <div class="row">
                <div class="col-sm-6">
                    <fieldset style="border: 2px solid #7DAAE3; height: auto;">
                        <legend class="legend" style="color: #00008B; font-family: Arial; font-size: 11px; font-weight: bold">IRN Detail</legend>
                        <div class="row" id="Div3" style="margin-left: 0px;">
                            
                             <div class="col-sm-3" style="padding-right: 0px;">
                            <div class="form-group">
                                    <asp:Label ID="lblirno" runat="server" CssClass="lbtxt">IRNO</asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtirnno" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                                
                            <div class="col-sm-1"></div>
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblpurtype" runat="server" CssClass="lbtxt">Purchase Type</asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">

                                    <asp:DropDownList ID="txtpurtype" runat="server" CssClass="dropdown_pur">
                                        <asp:ListItem Value="Purchase from Registered Dealer">Purchase from Registered Dealer</asp:ListItem>
                                        <asp:ListItem Value="Purchase from Registered Dealer-No ITC">Purchase from Registered Dealer-No ITC</asp:ListItem>
                                        <asp:ListItem Value="Purchase from Composition Dealer">Purchase from Composition Dealer</asp:ListItem>
                                        <asp:ListItem Value="Purchase from Unregistered Dealer">Purchase from Unregistered Dealer</asp:ListItem>
                                        <asp:ListItem Value="Non GST expenses bill">Non GST expenses bill</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>

                        </div>
                        <div class="row" id="Div4" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lbltrantype" runat="server" CssClass="lbtxt">Tran. Type</asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txttrantype" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-sm-1"></div>
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblshiptostate" runat="server" CssClass="lbtxt">Ship To State</asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtshiptostate" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="Div1" style="margin-left: 0px;">
                            
                        </div>
                    </fieldset>
                </div>
                <%--<div class="col-sm-1"></div>--%>
                <div class="col-sm-6">
                    <fieldset style="border: 2px solid #7DAAE3; height: auto;">
                        <legend class="legend" style="color: #00008B; font-family: Arial; font-size: 11px; font-weight: bold">PO Detail</legend>
                        <div class="row" id="Div2" style="margin-left: 0px;">
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
                                    <asp:Label ID="lblsupname" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtsupname" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-sm-1"></div>
                            <div class="col-sm-3" style="padding-right: 0px; display:none;">
                                <div class="form-group">
                                    <asp:Label ID="lblsupcode" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3"style="padding-right: 0px; display:none;">
                                <div class="form-group">
                                    <asp:TextBox ID="txtsupcode" runat="server" CssClass="TextFieldNew"></asp:TextBox>
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
                                    <asp:Label ID="lblisgecgstin" runat="server" CssClass="lbtxt"></asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtisgecgstin" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>


                        </div>

                        <div class="row" id="Div5" style="margin-left: 0px;">
                            
                        </div>
                    </fieldset>
                </div>
            </div>
        </div>
            </ContentTemplate></asp:UpdatePanel>
         <asp:UpdatePanel runat="server" ID="updatepanel2"><ContentTemplate>
        <div class="col-sm-12" style="margin-bottom: 20px;">
            <div class="row">
                <div class="col-sm-6">
                    <fieldset style="border: 2px solid #7DAAE3; height: 156px;">
                        <legend class="legend" style="color: #00008B; font-family: Arial; font-size: 11px; font-weight: bold">Bill Deatil</legend>
                        <div class="row" id="Div6" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblbillno" runat="server" CssClass="lbtxt">Bill Number</asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-9">
                                <div class="form-group">
                                    <asp:TextBox ID="txtbillno" runat="server" CssClass="TextFieldNew" Style="width: 100%;"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="Div14" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblbilldate" runat="server" CssClass="lbtxt">Bill Date</asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-9">
                                <div class="form-group">
                                    <asp:TextBox ID="txtbilldate" runat="server" CssClass="TextFieldNew" Style="width: 100%;"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="Div7" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblbillremark" runat="server" CssClass="lbtxt">Bill Remark</asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-9">
                                <div class="form-group">
                                    <asp:TextBox ID="txtbillremark" runat="server" CssClass="TextFieldNew" Style="width: 100%;"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="Div15" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblbilltotamt" runat="server" CssClass="lbtxt">Bill Total Amt.</asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-9">
                                <div class="form-group">
                                    <asp:TextBox ID="txtbilltotamt" runat="server" CssClass="TextFieldNew" Style="width: 100%;"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="Div8" style="margin-left: 0px;">
                            
                        </div>
                    </fieldset>
                </div>
                <%--<div class="col-sm-1"></div>--%>
                <div class="col-sm-6">
                    <fieldset style="border: 2px solid #7DAAE3; height:156px;">
                        <legend class="legend" style="color: #00008B; font-family: Arial; font-size: 11px; font-weight: bold">Other Detail</legend>
                        <div class="row" id="Div9" style="margin-left: 0px;">
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lbladviseno" runat="server" CssClass="lbtxt">Advice No</asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtadviceno" runat="server" CssClass="TextFieldNew" Width="120px">
                                    </asp:TextBox>
                                </div>
                            </div>
                            <div class="col-sm-1"></div>
                            <div class="col-sm-3" style="padding-right: 0px;">
                                <div class="form-group">
                                    <asp:Label ID="lblemployeeid" runat="server" CssClass="lbtxt">Employee Id</asp:Label>
                                </div>
                            </div>
                            <div class="col-sm-3">
                                <div class="form-group">
                                    <asp:TextBox ID="txtemployeeid" runat="server" CssClass="TextFieldNew"></asp:TextBox>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="Div10" style="margin-left: 0px;">
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
                            
                        </div>
                        <div class="row" id="Div13" style="margin-left: 0px;">
                            
                        </div>
                    </fieldset>
                </div>
            </div>
        </div>
             </ContentTemplate></asp:UpdatePanel>
         <asp:UpdatePanel runat="server" ID="updatepanel3"><ContentTemplate>
        <div class="col-sm-12">
            <fieldset style="width: 100%; float: left; margin-top: 10px; border: 2px solid #094A9C; padding: 0px 10px 0px 0px; height: auto;">
                <legend class="legendnew" style="color: #00008B; font-family: Arial; font-size: 11px; font-weight: bold">PO line</legend>
                <div style="text-align: end;">
                    <input type="button" runat="server" id="BtnAddRow" value="Add Row" onclick="javascript: return CommonCreateRow('new_page');"
                        style="width: 70px; height: 22px; text-align: center; font-size: 11px; font-family: Verdana;" />
                </div>
                <div id="divpogrid" runat="server" style="margin-bottom: 10px; height: 120px; overflow: auto;"></div>
            </fieldset>
        </div>
             </ContentTemplate></asp:UpdatePanel>
        
               

        <input type="hidden" runat="server" id="hiddendateformat" />
        <input type="hidden" runat="server" id="hdnbconnec" />
        <input type="hidden" runat="server" id="HDN_server_date" />
        <input type="hidden" runat="server" id="dateformat" />
        <input type="hidden" runat="server" id="hdntxtDate" />
        <input type="hidden" runat="server" id="hdnflag" />
        <input type="hidden" runat="server" id="hdnstatusflag" />
        <input type="hidden" runat="server" id="hdnbpcode" />
        <input type="hidden" runat="server" id="hdnsupcode" />
        <input type="hidden" runat="server" id="hdnsupisgccode" />
        <input type="hidden" runat="server" id="hdnuserid" />
        <input type="hidden" runat="server" id="hdnusername" />
        <input type="hidden" runat="server" id="hdncompname" />
        <input type="hidden" runat="server" id="hdnconnectionstring" />
        <input type="hidden" runat="server" id="hdnsuppgstin" />
        <input type="hidden" runat="server" id="hdnpono" />
        <input type="hidden" runat="server" id="hdntranstype" />
        <input type="hidden" runat="server" id="hdnshiptostate" />
        <input type="hidden" runat="server" id="hdnisgecgsiid" />
        <input type="hidden" runat="server" id="hdnirno" />
    </form>
</body>      
    
    <script type="text/javascript" src="javascript/jquery.min.js"></script>
    <script type="text/javascript" src="javascript/Supplier_BillEntry.js"></script>
    <script type="text/javascript" src="javascript/jquery.freezeheader.js"></script>
    <script type="text/javascript" src="javascript/CommonFunction_New.js"></script>
    <script type="text/javascript" src="datecss/dateui.js"></script>  
    <script type="text/javascript">
        var jq = jQuery.noConflict();
        jq(document).ready(function () {
            jq("#txtbilldate").datepicker(
                {
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'dd/mm/yy',

                });
        });

    </script>
</html>
