<%@ Page Language="C#" AutoEventWireup="true" CodeFile="history_of_po.aspx.cs" Inherits="history_of_po"  EnableEventValidation="false"%>

<%@ Register TagPrefix="uc1" TagName="Topbar" Src="~/Topbarnew_n.ascx" %>
<%@ Register TagPrefix="uc2" TagName="Leftbar" Src="~/Leftbar.ascx" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8" />
<title>untitled</title>
<link rel="preconnect" href="https://fonts.gstatic.com" />
<link href="https://fonts.googleapis.com/css2?family=Fira+Sans+Extra+Condensed:wght@300&display=swap" rel="stylesheet" />
    <link href="css/style_history.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no' />
 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="javascript/history_of_po.js"></script>
    <script src='https://kit.fontawesome.com/a076d05399.js' crossorigin='anonymous'></script>
</head>
<body>
    <form>
<div class="col-sm-12">
<div class="blank">
</div>
</div>
<div class="col-sm-12">
<div class="row">
<div class="header">
<p>List:Change request</p>
</div>
</div>
</div>

<div class="maincontent">
<div class="main-nav">
<div class="navbar">
<a><i class="fa fa-arrow-left" style="font-size:18px ;color:green"></i></a>
<a><i class="fa fa-save" style="font-size:18px"></i></a>
<a><i class="fa fa-file" style="font-size:18px"></i></a>
<a><i class="fa fa-close" style="font-size:18px"></i></a>
<a><i class="fa fa-file-text-o" style="font-size:18px"></i></a>
<a><i class="fa fa-file-text-o" style="font-size:18px"></i></a>
<a><i class="fa fa-print" style="font-size:18px"></i></a>
</div>
<div class="navbar1">
<a><i class="fa fa-step-backward" style="font-size:18px;color:blue"></i></a>
<a><i class="fa fa-caret-left" style="font-size:18px;color:blue"></i></a>
  <input type="text" id="fname" name="fname" />
  <span>#of 41 Pages</span>
<a><i class="fa fa-caret-right" style="font-size:18px;color:blue"></i></a>
<i class="fa fa-step-forward" style="font-size:18px;color:blue"></i>
<a><input type="text" id="Text1" name="fname" /></a>  <p>/pages</p>
</div>
<div class="navbar2">
<input type="text" placeholder="Search.." /> <i class="fa fa-search"style="font-size:18px;"></i>
</div>
</div>
<div class="tilebar">
<div class="tilebar1">
<!-- <!-- </div> -->
 <div class="tilebar2"> 
<span>Filter Records (Show Filters.....)</span>
<button type="button" class="collapsible"><i class="fa fa-chevron-circle-down" style="font-size:18px"></i></button>
<div class="content">
  <div class="container-fluid">              

                   <div class="control-group">
                       <div class="container-fluid mt-3">

                           <div class="row" id="Div3">
                               <div class="col-sm-2">
                                   <div class="form-group">
                                       <label for="School Name" id="lblscholapproval" runat="server" class="">PO No.</label>

                                   </div>
                               </div>
                               <div class="col-sm-3">
                                   <div class="form-group">
                                       <input type="text" class="form-control txtboxstyle" runat="server" id="txtpono"  placeholder="" name="School Name" />
                                       
                                       </div>
                                   </div>
                               </div>
   
                           </div>

                           <div class="row" id="Div4">
                               <div class="col-sm-2">
                                   <div class="form-group">
                                       <label for="Order no" id="LblorderNoapproval" runat="server">Revision No.</label>
                                   </div>
                               </div>
                               <div class="col-sm-3">
                                   <div class="form-group">
                                       <input type="text" class="form-control txtboxstyle" id="textrevisionno" onchange="order_gridchange(this.value);" placeholder="" name="Order" runat="server" />
                                       

                                   </div>
                               </div>
                          </div>
      				 </div>
</div>
  <script>
      var coll = document.getElementsByClassName("collapsible");
      var i;

      for (i = 0; i < coll.length; i++) {
          coll[i].addEventListener("click", function () {
              this.classList.toggle("active");
              var content = this.nextElementSibling;
              if (content.style.display === "block") {
                  content.style.display = "none";
              } else {
                  content.style.display = "block";
              }
          });
      }
</script>
</div>
</div>
</div>


<div class="table">
<table>
  <tr>
   <td>
       
<asp:DataGrid ID="DataGrid1" runat="server" CssClass="dtGrid" Width="100%"  
        AutoGenerateColumns="False"  OnItemDataBound="DataGrid1_ItemDataBound"  >
<SelectedItemStyle Font-Size="XX-Small" BackColor="#046791"></SelectedItemStyle>
<HeaderStyle HorizontalAlign="Center" Height="20px" ForeColor="White" CssClass="dtGridHd12" BackColor="#7DAAE3"></HeaderStyle>
<Columns>

    <asp:TemplateColumn HeaderText="Edit" >
	    <HeaderStyle Width="50px"></HeaderStyle>
	    <ItemStyle HorizontalAlign="Center"></ItemStyle>
	    <ItemTemplate>
		   <a><i class='fas fa-edit' style='font-size:18px'></i></a>
	    </ItemTemplate>
    </asp:TemplateColumn>
   
    <asp:TemplateColumn HeaderText="Revision">
	    <HeaderStyle Width="50px"></HeaderStyle>
	    <ItemStyle HorizontalAlign="Center"></ItemStyle>
	    <ItemTemplate>
		    <a><i class='fas fa-edit' style='font-size:18px'></i></a>
	    </ItemTemplate>
    </asp:TemplateColumn>

    
   
    <asp:TemplateColumn HeaderText="Print">
	    <HeaderStyle Width="50px"></HeaderStyle>
	    <ItemStyle HorizontalAlign="Center"></ItemStyle>
	    <ItemTemplate>
		    <a><i class="fa fa-print" style="font-size:18px"></i></a>
	    </ItemTemplate>
    </asp:TemplateColumn>


<asp:BoundColumn DataField="PONo" HeaderText="Po No" SortExpression="Edition_Alias">
<ItemStyle HorizontalAlign="Center"></ItemStyle>
<HeaderStyle Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
Font-Underline="False" ForeColor="White" HorizontalAlign="Center" />
</asp:BoundColumn>

<asp:BoundColumn  HeaderText="Po Date" DataField="PoDate" >
<ItemStyle HorizontalAlign="Center" Width="120px"></ItemStyle>
<HeaderStyle Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
Font-Underline="False" ForeColor="White" HorizontalAlign="Center" />
</asp:BoundColumn>

<asp:BoundColumn DataField="RevisionNo" HeaderText="Revision" SortExpression="Date_Edition">
<ItemStyle HorizontalAlign="Left"></ItemStyle>
<HeaderStyle Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
Font-Underline="False" ForeColor="White" HorizontalAlign="Center" />
</asp:BoundColumn>

<asp:BoundColumn DataField="status" HeaderText="Status" SortExpression="Date_Edition">
<ItemStyle HorizontalAlign="Center"></ItemStyle>
<HeaderStyle Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
Font-Underline="False" ForeColor="White" HorizontalAlign="Center" />
</asp:BoundColumn>

<asp:BoundColumn DataField="BPNAME" HeaderText="Supplier Name" SortExpression="Date_Edition"  >
<ItemStyle HorizontalAlign="Center"></ItemStyle>
<HeaderStyle Font-Bold="False" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
Font-Underline="False" ForeColor="White" HorizontalAlign="Center" />
</asp:BoundColumn>

<asp:BoundColumn SortExpression="Client" DataField="basic_amt" HeaderText="Basic Amt" ReadOnly="True" Visible="true">
<ItemStyle HorizontalAlign="Left"></ItemStyle>
<HeaderStyle Font-Bold="True" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
Font-Underline="False" ForeColor="White" HorizontalAlign="Center" />
</asp:BoundColumn>
	
	<asp:BoundColumn  ReadOnly="True" HeaderText="Supplier Code"   DataField="BPCode">
<ItemStyle HorizontalAlign="Center"></ItemStyle>
<HeaderStyle Font-Bold="True" Font-Italic="False" Font-Overline="False" Font-Strikeout="False"
Font-Underline="False" ForeColor="White" HorizontalAlign="Center" />
</asp:BoundColumn> 

</Columns>
</asp:DataGrid>

   </td>
  </tr>


</table>
</div>



</div>
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
        <input type="hidden" runat="server" id="hdnuserid" />
        <input type="hidden" runat="server" id="hdnusername" />
        <input type="hidden" runat="server" id="hdncompname" />
        <input type="hidden" runat="server" id="hdnconnectionstring" />
    </form>
</body>
</html>
