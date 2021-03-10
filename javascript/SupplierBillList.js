var browser = navigator.appName;
var jq = jQuery.noConflict();
var next = 0;
var ds = "";
var exec_data = "";
var total_records = "0";
var record_show = 5;
var record_show1 = 1;
var ClientDocCode;
var RetainerDocCode;
var ExecutiveDocCode;
var str = 0;
var tb = 0;
var count1;
var count2;
var count3;
var count4;
var count5;
var flag = "";
var modifyflag = "";
//var count5;
var count6;
var count7;
var count8;
var rowtotal = 0;
var rowbalance = 0;
var comp_code = "", unit = "", doctype = "", rcptno = "", rcptdate = "", chqdt = "", chqno = "", agcode = "", agmaincode = "", agsubcode = "", agname = "", totalamt = "", tag = "", untag = "", paymentmode = "", manrcptno = "", rcvdfrom = "";
var execount = 0;


function keySort(dropdownlist, caseSensitive) {
    var undefined;
    if (dropdownlist.keypressBuffer == undefined) {
        dropdownlist.keypressBuffer = '';
    }
    var key = String.fromCharCode(window.event.keyCode);
    dropdownlist.keypressBuffer += key;
    if (!caseSensitive) {
        // convert buffer to lowercase
        dropdownlist.keypressBuffer = dropdownlist.keypressBuffer.toLowerCase();
    }
    // find if it is the start of any of the options 
    var optionsLength = dropdownlist.options.length;
    for (var n = 0; n < optionsLength; n++) {
        var optionText = dropdownlist.options[n].text;
        if (!caseSensitive) {
            optionText = optionText.toLowerCase();
        }
        if (optionText.indexOf(dropdownlist.keypressBuffer, 0) == 0) {
            dropdownlist.selectedIndex = n;
            return false; // cancel the default behavior since 
            // we have selected our own value 
        }
    }
    // reset initial key to be inline with default behavior 
    dropdownlist.keypressBuffer = key;
    return true; // give default behavior 
}



function eventcalling(event) {
    if (event.keyCode == 97)
        event.keyCode = 65;
    if (event.keyCode == 98)
        event.keyCode = 66;
    if (event.keyCode == 99)
        event.keyCode = 67;
    if (event.keyCode == 100)
        event.keyCode = 68;
    if (event.keyCode == 101)
        event.keyCode = 69;
    if (event.keyCode == 102)
        event.keyCode = 70;
    if (event.keyCode == 103)
        event.keyCode = 71;
    if (event.keyCode == 104)
        event.keyCode = 72;
    if (event.keyCode == 105)
        event.keyCode = 73;
    if (event.keyCode == 106)
        event.keyCode = 74;
    if (event.keyCode == 107)
        event.keyCode = 75;
    if (event.keyCode == 108)
        event.keyCode = 76;
    if (event.keyCode == 109)
        event.keyCode = 77;
    if (event.keyCode == 110)
        event.keyCode = 78;
    if (event.keyCode == 111)
        event.keyCode = 79;
    if (event.keyCode == 112)
        event.keyCode = 80;
    if (event.keyCode == 113)
        event.keyCode = 81;
    if (event.keyCode == 114)
        event.keyCode = 82;
    if (event.keyCode == 115)
        event.keyCode = 83;
    if (event.keyCode == 116)
        event.keyCode = 84;
    if (event.keyCode == 117)
        event.keyCode = 85;
    if (event.keyCode == 118)
        event.keyCode = 86;
    if (event.keyCode == 119)
        event.keyCode = 87;
    if (event.keyCode == 120)
        event.keyCode = 88;
    if (event.keyCode == 121)
        event.keyCode = 89;
    if (event.keyCode == 122)
        event.keyCode = 90;
}

function clearclick() {
   
    bindgriddetail();
    return false;
}

function bindgriddetail() {
    var PPONo = document.getElementById("txtpono").value;
    var BillNumber = document.getElementById("txtbillno").value;
    var BillDate = document.getElementById("txtdt").value;
    var BPID = document.getElementById("txtsuppnamecode").value;
    var irno = document.getElementById("txtirn").value;
    var pextra1 = "";
    var pextra2 = "";
    var pextra3 = "";
    var pextra4 = "";
    var pextra5 = "";
    var connstring = document.getElementById("hdnconnectionstring").value;
    var res_vch2 = SupplierBillList.hdr_savedet(PPONo, irno, BillNumber, BillDate, BPID, pextra1, pextra2, pextra3, pextra4, pextra5, connstring);

    if (res_vch2.error != null) {
        alert(res_vch2.error.description);
        return false;
    }

    else {
        try {
            dsmain1 = res_vch2.value;
            var hdsview = "";
            document.getElementById('divbilling1').style.display = "block";
            jq("#divbilling1").empty();
            hdsview += BindGridHeader();
            var amt = 0;
            for (count1 = 0; count1 < dsmain1.Tables[0].Rows.length; count1++) {
                hdsview += ("<tr>")
                hdsview += ("<td><div class='' style='width:100%;text-align:left;' id=txtirnoLink_" + count1 + " class='Divpadding_left' onclick='javascript:return modifytbind(this.id)'><i class='fas fa-edit' style='font-size:12px'></i></div></td>");
                hdsview += ("<td><div class='' style='width:100%;text-align:left;' id=txtattachlink_" + count1 + " class='Divpadding_left' onclick='javascript:return attachmentpo(this.id)'  title=Attachment'><i class='fas fa-link' style='font-size:12px'></i></div></td>");
                hdsview += "<td><div class='' style='width:100%;text-align:left;' id=txtirnoprintLink_" + count1 + " class='Divpadding_left' onclick='javascript:return printbind(this.id)'><i class='fa fa-print' style='font-size:12px'></i></div></td>";
                hdsview += "<td><input  name='Disable' class='gridinputclass'  style='text-align:left;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].IRNo) + "'  id=txtirnno_" + count1 + "   disabled ></td>";
                hdsview += "<td><input  name='Disable' class='gridinputclass'  style='text-align:left;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].BPID) + "'  id=txtbpid_" + count1 + "   disabled ></td>";
                hdsview += "<td><input  name='Disable'  class='gridinputclass' style='text-align:left;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].BPNAME) + "'  id=txtbpdesc_" + count1 + "   disabled></td>";
                hdsview += "<td><input  name='Disable'  class='gridinputclass' style='text-align:left;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].BillNumber) + "'  id=txtbillno_" + count1 + "   disabled ></td>";
                hdsview += "<td><input style ='text-align:left;' name='Disable'  class='gridinputclass'  value='" + (fndnull(dsmain1.Tables[0].Rows[count1].billDate)) + "'  id=txtbilldate_" + count1 + "   disabled></td>";
                hdsview += "<td><input name='Disable'  class='gridinputclass' style='text-align:left;' title='" + dsmain1.Tables[0].Rows[count1].orderno + "' value='" + fndnull(dsmain1.Tables[0].Rows[count1].orderno) + "'  id=txtorderno_" + count1 + "   disabled></td>";
                hdsview += "<td><input  name='Disable'  class='gridinputclass' style='text-align:right;' value='" + parseFloat(dsmain1.Tables[0].Rows[count1].basic_amt).toFixed(2) + "' id=txttotamt_" + count1 + "  disabled ></td>";
                hdsview += "<td><input  name='Disable'  class='gridinputclass' style='text-align:left;' value='" + (dsmain1.Tables[0].Rows[count1].TranTypeID) + "' id=txttranid_" + count1 + "  disabled ></td>";
                hdsview += "<td><input  name='Disable'  class='gridinputclass' style='text-align:left;' value='" + (dsmain1.Tables[0].Rows[count1].ShipToState) + "' id=txtshiptostate_" + count1 + "  disabled></td>";
                hdsview += "<td><input  name='Disable'  class='gridinputclass' style='text-align:left;' value='" + (dsmain1.Tables[0].Rows[count1].PurchaseType) + "'    id=txtpurchasestype_" + count1 + "  disabled ></td>";
                hdsview += "<td><input  name='Disable'  class='gridinputclass' style='text-align:left;' value='" + (dsmain1.Tables[0].Rows[count1].CreatedBy) + "'    id=txttcreatedby_" + count1 + "  disabled></td>";
                hdsview += "<td><input  name='Disable' style ='text-align:left;'  class='gridinputclass' value='" + fndnull(dsmain1.Tables[0].Rows[count1].CreatedOn) + "' id=txtcreateddt_" + count1 + "  disabled></td>";
                hdsview += "<td><input  name='Disable' class='gridinputclass' style='text-align:left;' title='" + dsmain1.Tables[0].Rows[count1].EmployeeID + "' value='" + fndnull(dsmain1.Tables[0].Rows[count1].EmployeeID) + "'  id=txtempid_" + count1 + "   disabled ></td>";
                hdsview += "<td><input  name='Disable'  class='gridinputclass' style='text-align:left;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].AdviceNo) + "'  id=txtadviceno_" + count1 + "   disabled></td>";
                hdsview += ("</tr>")
            }
            execount = count1;
            hdsview += ("</table>")
            jq('#divbilling1').append(hdsview);
            EnableGrid();
            jq('#divbilling1').css("display", "block");
        }
        catch (ex) {
            alert('An error has occurred: ' + ex.message);
        }
    }
    return false;
}


function BindGridHeader() {
    var hdsview = "";
    hdsview += ("<table id='new_page'  class='table table-bordered'>")
    hdsview += ("<tr style='height:15px; color: white;background-color: #5c9afb; font-size:13px;'>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Edit</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Attachment</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Print</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%; display:none'>Delete</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>IRNO</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Supplier Code</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Supplier Name</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Bill No</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Bill Date</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>PO No.</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Total Bill Amt</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:5%;'>Trans.Type</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Ship To State</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Purchases Type</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Created By</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Created On</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Employee Id</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Advice No.</td>")

    hdsview += ("</tr>")
    return hdsview;
}


function EnableGrid() {
    if (jq('#hdnflag').val() != "execute") {
        jq("input[name*='Enable']").attr("disabled", false);
        jq("input[name*='Disable']").attr("disabled", true);
        jq('#btnaddrow').attr("disabled", false);
    }
    else {
        jq("input[name*='Enable']").attr("disabled", true);
        jq("input[name*='Disable']").attr("disabled", true);
        // jq('#btnaddrow').attr("disabled", true);
    }
    return false;
}
function attachmentpo(id) {
    var id1 = id.split("_")[1]
    var irno = document.getElementById("txtirnno_" + id1).value;

    var advice = document.getElementById("txtadviceno_" + id1).value;
    if (advice == "") {
        var ed1 = "n";
    }
    else {
        var ed1 = "y";
    }
    var win = "";
    //document.getElementById('hdnrevision').value = revisionno;
    var url = "http://192.9.200.146/Attachment/Attachment.aspx";//?AthHandle=J_ADMINPO&Index=ADM000004&AttachedBy=0330&ed=y
    win = window.open(url + '?AthHandle=J_SPMTNEWSB&Index=' + irno + '&AttachedBy=' + document.getElementById('hdnuserid').value + '&ed=' + ed1, '', 'width=' + screen.availWidth + ',height=' + screen.availHeight + ',resizable=1,left=0,top=0,scrollbars=yes');

    return false;
}


function modifytbind(id) {
    var id1=id.split("_")[1]
    var irno = document.getElementById("txtirnno_" + id1).value;
    var advice = document.getElementById("txtadviceno_" + id1).value;
    if (advice != "") {
        alert('IRN not modified or deleted');
        return false;
    }
    else {
        var win = "";
        //document.getElementById('hdnrevision').value = revisionno;
        win = window.open('Supplier_BillEntry.aspx?irno=' + irno + '&us=' + document.getElementById('hdnuserid').value + '&cm=' + document.getElementById('hdncompname').value, '', 'width=' + screen.availWidth + ',height=' + screen.availHeight + ',resizable=1,left=0,top=0,scrollbars=yes');
        return false;
    }
}


function newpurchasesorder(id) {
    var j;


    var irno = "";
    var win = "";
    //document.getElementById('hdnrevision').value = revisionno;
    win = window.open('Supplier_BillEntry.aspx?irno=' + irno + '&us=' + document.getElementById('hdnuserid').value + '&cm=' + document.getElementById('hdncompname').value, '', 'width=' + screen.availWidth + ',height=' + screen.availHeight + ',resizable=1,left=0,top=0,scrollbars=yes');

    return false;
}


function bindsupliercodef2(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var activeid = document.activeElement.id.split('_')[1];
    var id = activeid;//CurrentTextId.split('_')[1];
    CurrentTextId = document.activeElement.id;
    if (event.keyCode == 113) {
        OffSetForGridpolist(document.activeElement.id, "divsuplircode", "lstsuplircode", "view");
        var connstring = document.getElementById("hdnconnectionstring").value;
        var res = SupplierBillList.Bindsuppcode(jq('#' + CurrentTextId).val().toUpperCase(), jq("#txtsuppnamecode").val(), "", "", "", "", connstring, BindsupliercdCallbackgrid);
        return false;
    }
    else if (keycode == 8 || keycode == 46) {
        document.getElementById("txtsuppnamecode").value = "";



    }
    else if (keycode != 13 && keycode != 37 && keycode != 39 && keycode != 9 && keycode != 17 && event.shiftKey == false && event.ctrlKey == false && event.altKey == false) {

        document.getElementById("txtsuppnamecode").value = "";
    }
    if (event.ctrlKey == true && keycode == 88) {
        document.getElementById("txtsuppnamecode").value = "";
    }
}

function BindsupliercdCallbackgrid(res) {
    var ds = res.value;
    var pkgitem = document.getElementById('lstsuplircode')
    pkgitem.options.length = 0;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        pkgitem.options[0] = new Option("---Select Supplier Item Code---", "0");
        pkgitem.options.length = 1;
        for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].NAME + "~" + ds.Tables[0].Rows[i].BPCode, ds.Tables[0].Rows[i].NAME + "~" + ds.Tables[0].Rows[i].BPCode);
            pkgitem.options.length;
        }
    }
    else {
        pkgitem.options[0] = new Option("---There is no data accourding your search---", "");
        return false;
    }
    jq('#lstsuplircode').focus();
    return false;
}
function fillsupliercode(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var id = CurrentTextId.split('_')[1];
    if (keycode == 13 || event.type == "click") {
        if (fndnull(jq('#lstsuplircode').val()) == "") {
            alert("Please Select Supplier Code..!!");
            jq('#lstsuplircode').focus();
            return false;
        }
        var activeid = CurrentTextId.split('_')[1];
        var page = jq('#lstsuplircode').val()
        var str = page.split("~");
        jq('#txtsuppname').val(str[0])
        jq('#txtsuppnamecode').val(str[1])
        jq('#txtsuppnamecode').val(str[1])
        jq('#divsuplircode').css("display", "none");
        jq('#txtsuppname').focus();
        return false;
    }
    else if (keycode == 27) {
        jq('#divsuplircode').css("display", "none");
        jq('#txtsuppname').focus();
        return false;
    }
}