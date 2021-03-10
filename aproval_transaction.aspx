<%@ Page Language="C#" AutoEventWireup="true" CodeFile="aproval_transaction.aspx.cs" Inherits="aproval_transaction" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" %>
<%@ Register TagPrefix="uc1" TagName="Topbar" Src="~/Topbarnew_n.ascx" %>
<%@ Register TagPrefix="uc2" TagName="Leftbar" Src="~/Leftbar.ascx" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Approval Transaction</title>
    <link href="css/store.css" rel="stylesheet" />
    <link href="css/main.css" rel="Stylesheet" />

    <script type="text/javascript" src="javascript/jquery.min.js"></script>
    <script type="text/javascript" src="javascript/jquery.freezeheader.js"></script>
    <script type="text/javascript" src="javascript/CommonFunction_New.js"></script>
    <script type="text/javascript" src="javascript/popupcalender.js"></script>
    <script type="text/javascript" language="javascript" src="javascript/popcalendar.js"></script>
    <script type="text/javascript" src="javascript/aproval_transaction.js"></script>
    <link href="css/4.3.1/bootstrap.min.css" rel="stylesheet" />
    <script type="text/javascript" src="datecss/dateui.js"></script>
    <link href="datecss/datecss1.css" rel="stylesheet" />
    <script type="text/javascript">
        var jq = jQuery.noConflict();
        jq(document).ready(function () {
            jq("#txtpodt").datepicker(
                {
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'dd/mm/yy',

                });
        });

    </script>
    <style>
        legend {
            display: block;
            width: 7%;
            max-width: 100%;
            padding: 0;
            margin-bottom: .5rem;
            font-size: 1.5rem;
            line-height: inherit;
            color: inherit;
            white-space: normal;
        }
    </style>

</head>
<body style="background-color: #f3f6fd; margin: 0px 0px 0px 0px">
    <form id="form1" runat="server">

        <table id="OuterTable" width="1000px" border="0" cellpadding="0" cellspacing="0">
            <tr valign="top">
                <td colspan="2">
                    <uc1:Topbar ID="Topbar1" runat="server" Text="Composit Receipt Entry"></uc1:Topbar>
                </td>
            </tr>
        </table>
        <div>
            <fieldset style="width: 75%; padding-left: 10px; float: left; margin-top: 10px; border: 2px solid #7DAAE3; margin-left: 100px; padding: 10px 10px 10px 10px; height: auto;">
                <legend style="color: #00008B; font-family: Arial; font-size: 13px; font-weight: bold">Approval</legend>
                <div style="text-align: left; width: 100%; float: left; padding: 1px 1px 1px 1px;">
                    <div style="width: 16%; float: left;">
                        <asp:Label ID="lblpono" runat="server" CssClass="lbtxt"></asp:Label>
                    </div>
                    <div style="width: 17%; float: left;">
                        <asp:TextBox ID="txtpono" runat="server" CssClass="TextFieldNew" Width="165px"></asp:TextBox>
                    </div>


                    <div style="width: 14%; float: left; margin-left: 2%;">
                        <asp:Label ID="lblpodt" runat="server" CssClass="lbtxt"></asp:Label>
                    </div>
                    <div style="width: 17%; float: left;">
                        <asp:TextBox ID="txtpodt" runat="server" CssClass="TextFieldNew" Width="162px"></asp:TextBox>
                    </div>

                </div>

                <div class="col-sm-12">
                    <div class="row">
                        <div class="col-sm-9"></div>
                        <div class="col-sm-2">
                            <button type="submit" class="btn btn-primary btn-block1 btnstyle" id="btnrun" runat="server">Submit</button>

                        </div>
                    </div>

                </div>

            </fieldset>
        </div>


        <%--   <div runat="server" id="taxcodeview" style="width: 77%; height: 160px; overflow-y: scroll;
                    border: 2px solid #7DAAE3; float: left; margin: 2px 99px 99px 99px; z-index: auto; top: 260px; left: 50px; margin-top: 230px;">
                </div>--%>
        <input type="hidden" runat="server" id="hiddendateformat" />
        <input type="hidden" runat="server" id="hdnbconnec" />
        <input type="hidden" runat="server" id="HDN_server_date" />
        <input type="hidden" runat="server" id="dateformat" />
        <input type="hidden" runat="server" id="hdntxtDate" />
        <input type="hidden" runat="server" id="hdnflag" />
        <input type="hidden" runat="server" id="hdnstatusflag" />

    </form>
</body>

<%--<script type="text/javascript" src="javascript/tax_type_code.js"></script>--%>
</html>

