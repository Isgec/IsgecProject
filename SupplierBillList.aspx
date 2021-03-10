<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SupplierBillList.aspx.cs" Inherits="SupplierBillList" EnableEventValidation="false"%>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8" />
<title>Admin PO Management</title>
<link rel="preconnect" href="https://fonts.gstatic.com" />
<link href="https://fonts.googleapis.com/css2?family=Fira+Sans+Extra+Condensed:wght@300&display=swap" rel="stylesheet" />
    <link href="css/style_history.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
<meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no' />
 <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <style>
        .table td, .table th {
    padding: 0px 2px 0px 6px;
    vertical-align: middle;
    font-size: 12px;
    border-top: 1px solid #dee2e6;
}
    </style>
    <style>
        .column {
    text-align:right;
    padding-right:15px;

}
    </style>
    <style>
       .navbar_itag {
    position: relative;
    display: -ms-flexbox;
    display: flex;
    -ms-flex-wrap: wrap;
    flex-wrap: wrap;
    -ms-flex-align: center;
    align-items: center;
    -ms-flex-pack: justify;
    justify-content: space-between;
    padding: -0.5rem 1rem;
    background-color: #cce1e6;
    width: 20%;
    height: 36px;
    float: left;
    padding: 0px 0px 0px 0px;
    border-radius: 10px;

}
    </style>
</head>
<body style="background-color: #f3f6fd; margin: 0px 0px 0px 0px" onload="javascript:return clearclick();">
    <form id="form1" runat="server">

        <div id="divsuplircode" style="position: absolute; top: 0px; left: 0px; border: none; display: none; z-index: 1;"
            class="f2_div">
            <table cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                        <asp:ListBox ID="lstsuplircode" Width="400px" Height="150px" runat="server" CssClass="btextlist"></asp:ListBox>
                    </td>
                </tr>
            </table>
        </div>
<div class="col-sm-12">
<div class="blank">
</div>
</div>
<div class="col-sm-12">
<div class="row" style="height: 64px;">
<div class="header">
<p>Admin Supplier Bill Management</p>
</div>
</div>
</div>

<div class="maincontent">
<div class="main-nav">
<div class="navbar_itag">
<a><i class="fa fa-arrow-left" style="font-size:12px ;color:green; display:none;"></i></a>
<asp:LinkButton runat="server" ID="linkbutton1" ToolTip="New"><div><button class="btn btn-default" type="submit" onclick="newpurchasesorder(this.id); return false;" id="btnnewpono" runat="server"><i class="fa fa-save" style="font-size:12px"></i></button></div></asp:LinkButton>
<a><i class="fa fa-file" style="font-size:12px; display:none;"></i></a>
<a><i class="fa fa-close" style="font-size:12px; display:none;"></i></a>
<a><i class="fa fa-file-text-o" style="font-size:12px; display:none;"></i></a>
<a><i class="fa fa-file-text-o" style="font-size:12px; display:none;"></i></a>
<a><i class="fa fa-print" style="font-size:12px; display:none;"></i></a>
</div>
<div class="navbar1" style="display:none;">
<a><i class="fa fa-step-backward" style="font-size:12px;color:blue"></i></a>
<a><i class="fa fa-caret-left" style="font-size:12px;color:blue"></i></a>
  <input type="text" id="fname" name="fname" />
  <span>#of 41 Pages</span>
<a><i class="fa fa-caret-right" style="font-size:12px;color:blue"></i></a>
<i class="fa fa-step-forward" style="font-size:12px;color:blue"></i>
<a><input type="text" id="Text1" name="fname" /></a>  <p>/pages</p>
</div>

      <div class='navbar2'>
                                        <input  placeholder='Search...' type='text' id="searchvalue1"/>
                                        <%--<div class="input-group-btn">--%>
                                            <button class="btn btn-default" type="submit" onclick="gridf2check(id); return false;" id="btnsearch1" runat="server"><i class="fa fa-search" aria-hidden="true"></i></button>
                                        <%--</div>--%>
                                    </div>

</div>
<div class="tilebar">
<div class="tilebar1">
 <div class="tilebar2"> 
<span>Filter Records (Show Filters.....)</span>
<button type="button" class="collapsible"><i class="fa fa-chevron-circle-down" style="font-size:12px"></i></button>
<div class="content">
  <div class="container-fluid">              

                   <div class="control-group">
                       <div class="container-fluid mt-3">

                           <div class="row" id="Div3">
                               <div class="col-sm-2">
                                   <div class="form-group">
                                       <label for="School Name" id="lblirn" runat="server" class="">IRNO</label>

                                   </div>
                               </div>
                               <div class="col-sm-3">
                                   <div class="form-group">
                                       <input type="text" class="form-control txtboxstyle" runat="server" id="txtirn" onchange="bindgriddetail();"  placeholder="" name="School Name" />
                                       
                                       </div>
                                   </div>
                               <div class="col-sm-2">
                                   <div class="form-group">
                                       <label for="School Name" id="lblscholapproval" runat="server" class="">PO No.</label>

                                   </div>
                               </div>
                               <div class="col-sm-3">
                                   <div class="form-group">
                                       <input type="text" class="form-control txtboxstyle" runat="server" id="txtpono" onchange="bindgriddetail();"  placeholder="" name="School Name" />
                                       
                                       </div>
                                   </div>
                               </div>

                           <div class="row" id="Div4">
                               <div class="col-sm-2">
                                   <div class="form-group">
                                       <label for="Order no" id="LblorderNoapproval" runat="server">Bill No.</label>
                                   </div>
                               </div>
                               <div class="col-sm-3">
                                   <div class="form-group">
                                       <input type="text" class="form-control txtboxstyle" id="txtbillno" onchange="bindgriddetail();" placeholder="" name="Order" runat="server" />
                                       

                                   </div>
                               </div>
                               <div class="col-sm-2">
                                   <div class="form-group">
                                       <label for="Order no" id="Label1" runat="server">Supplier Name</label>
                                   </div>
                               </div>
                               <div class="col-sm-3">
                                   <div class="form-group">
                                       <input type="text" class="form-control txtboxstyle" id="txtsuppname" onblur="bindgriddetail();" placeholder="" name="Order" runat="server" />
                                       <input type="text" class="form-control txtboxstyle" id="txtsuppnamecode"  placeholder="" name="Order" runat="server" style="display:none;"/>
                                       

                                   </div>
                               </div>
                          </div>
   

                           <div class="row" id="Div1">
                               <div class="col-sm-2">
                                   <div class="form-group">
                                       <label for="Order no" id="Label2" runat="server">Bill Date</label>
                                   </div>
                               </div>
                               <div class="col-sm-3">
                                   <div class="form-group">
                                       <input type="text" class="form-control txtboxstyle" id="txtdt" onchange="bindgriddetail();" placeholder="" name="Order" runat="server" />
                                       

                                   </div>
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
     <div id="divbilling1"  style="padding-left: 0px; position: absolute; height: 550px; margin-top: 0px; margin-left: 0px; width: 100%; overflow-y: auto;"></div>
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
        <input type="hidden" runat="server" id="hdnrevision" />
    </form>
</body>    
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
  <script src='https://kit.fontawesome.com/a076d05399.js' crossorigin='anonymous'></script>
  <script type="text/javascript" src="javascript/jquery.min.js"></script>
  <script type="text/javascript" src="javascript/jquery.freezeheader.js"></script>
  <script type="text/javascript" src="javascript/CommonFunction_New.js"></script>
  <script type="text/javascript" src="javascript/SupplierBillList.js"></script>
</html>