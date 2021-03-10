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
    // check the keypressBuffer attribute is defined on the dropdownlist 
    var undefined;
    if (dropdownlist.keypressBuffer == undefined) {
        dropdownlist.keypressBuffer = '';
    }
    // get the key that was pressed 
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
    var revision = document.getElementById("textrevisionno").value;
    var pextra1 = document.getElementById("txtsuppnamecode").value;
    var pextra2 = "";
    var pextra3 = "";
    var pextra4 = "";
    var pextra5 = "";
    var connstring = document.getElementById("hdnconnectionstring").value;
    var res_vch2 = PODetailList.hdr_savedet(PPONo, revision, pextra1, pextra2, pextra3, pextra4, pextra5, connstring);

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
                hdsview += ("<td><div class='' style='width:100%;text-align:left;' id=txtirnoLink_" + count1 + " class='Divpadding_left' onclick='javascript:return modifytbind(this.id)' title='Edit'><i class='fas fa-edit' style='font-size:12px'></i></div></td>");
                hdsview += ("<td><div class='' style='width:100%;text-align:left;' id=txtirnoLink_" + count1 + " class='Divpadding_left' onclick='javascript:return modifyrevision(this.id)'  title='Revise PO'><i class='fas fa-edit' style='font-size:12px'></i></div></td>");
                hdsview += ("<td><div class='' style='width:100%;text-align:left;' id=txtattachlink_" + count1 + " class='Divpadding_left' onclick='javascript:return attachmentpo(this.id)'  title=Attachment'><i class='fas fa-link' style='font-size:12px'></i></div></td>");
                hdsview += "<td><div class='' style='width:100%;text-align:left;' id=txtirnoprintLink_" + count1 + " class='Divpadding_left' onclick='javascript:return printbind(this.id)' title='print'><i class='fa fa-print' style='font-size:12px'></i></div></td>";
                
                hdsview += "<td><input  name='Disable' class='gridinputclass'  style='text-align:left;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].PONo) + "'  id=txtpono_" + count1 + "   disabled ></td>";
                hdsview += "<td><input  name='Disable' class='gridinputclass'  style='text-align:left;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].PoDate) + "'  id=txtpodate_" + count1 + "   disabled ></td>";
                hdsview += "<td><input  name='Disable'  class='gridinputclass' style='text-align:left;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].RevisionNo) + "'  id=txtrevision_" + count1 + "   disabled></td>";
                hdsview += "<td><input  name='Disable'  class='gridinputclass' style='text-align:left;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].status) + "'  id=txtstatus_" + count1 + "   disabled ></td>";
                hdsview += "<td><input style ='text-align:left;' name='Disable'  class='gridinputclass'  value='" + (fndnull(dsmain1.Tables[0].Rows[count1].BPCode)) + "'  id=txtsuppcode_" + count1 + "   disabled></td>";
                hdsview += "<td><input name='Disable'  class='gridinputclass' style='text-align:left;' title='" + dsmain1.Tables[0].Rows[count1].BPNAME + "' value='" + fndnull(dsmain1.Tables[0].Rows[count1].BPNAME) + "'  id=txtsuppname_" + count1 + "   disabled></td>";
                hdsview += "<td><input  name='Disable'  class='gridinputclass' style='text-align:left;' value='" + (dsmain1.Tables[0].Rows[count1].Currency) + "' id=txtcurrency_" + count1 + "  disabled ></td>";
                hdsview += "<td><input  name='Disable'  class='gridinputclass' style='text-align:right;' value='" + parseFloat(dsmain1.Tables[0].Rows[count1].basic_amt).toFixed(2) + "' id=txttotamt_" + count1 + "  disabled ></td>";
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
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Revision PO</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Attachment</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Print</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%; display:none'>Delete</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Po No</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Po Date</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Revision</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Status</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Supplier Code</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Supplier Name</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Currency</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:5%;'>Basic Amt</td>")

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
    var pono1 = document.getElementById("txtpono_" + id1).value;
    var revision1 = document.getElementById("txtrevision_" + id1).value;
    var index1 = pono1 + "_" + revision1;

    var status = document.getElementById("txtstatus_" + id1).value;
    if (status == "Approved") {
        var ed1 = "n";
    }
    else {
        var ed1 = "y";
    }
    var win = "";
    //document.getElementById('hdnrevision').value = revisionno;
    var url = "http://192.9.200.146/Attachment/Attachment.aspx";//?AthHandle=J_ADMINPO&Index=ADM000004&AttachedBy=0330&ed=y
    win = window.open(url + '?AthHandle=J_ADMINPO&Index=' + index1 + '&AttachedBy=' + document.getElementById('hdnuserid').value + '&ed=' + ed1, '', 'width=' + screen.availWidth + ',height=' + screen.availHeight + ',resizable=1,left=0,top=0,scrollbars=yes');

    return false;
}




function modifytbind(id) {
    var id1=id.split("_")[1]
    var pono1 = document.getElementById("txtpono_" + id1).value;
            var win = "";
            //document.getElementById('hdnrevision').value = revisionno;
            win = window.open('PurchasesOrder.aspx?pono=' + pono1 + '&us=' + document.getElementById('hdnuserid').value + '&cm=' + document.getElementById('hdncompname').value, '', 'width=' + screen.availWidth + ',height=' + screen.availHeight + ',resizable=1,left=0,top=0,scrollbars=yes');
        
    return false;
}


function modifyrevision(id) {
    var j;
    var id1=id.split("_")[1]
    var pono1 = document.getElementById("txtpono_" + id1).value;
    var status = document.getElementById("txtstatus_" + id1).value;
            if (status == "Approved") {
                var win = "";
                //document.getElementById('hdnrevision').value = revisionno;
                win = window.open('revision_po.aspx?pono=' + pono1 + '&us=' + document.getElementById('hdnuserid').value + '&cm=' + document.getElementById('hdncompname').value, '', 'width=' + screen.availWidth + ',height=' + screen.availHeight + ',resizable=1,left=0,top=0,scrollbars=yes');
                return false;
            }
            else {
                alert('Only approved purchases order can be revised.');
                return false;
            }
    return false;
}


function printbind(id) {
    var j;
    var id1 = id.split("_")[1]
    var pono1 = document.getElementById("txtpono_" + id1).value;
    var status = document.getElementById("txtstatus_" + id1).value;
    
        var win = "";
        //document.getElementById('hdnrevision').value = revisionno;
        win = window.open("http://192.9.200.158/ReportServer/Pages/ReportViewer.aspx?%2fP_AdminPOPrint&rs:Command=Render&PONO="+pono1);
        return false;
}



function newpurchasesorder(id) {
    var j;


    var pono1 = "";
    var win = "";
    //document.getElementById('hdnrevision').value = revisionno;
    win = window.open('PurchasesOrder.aspx?pono=' + pono1 + '&us=' + document.getElementById('hdnuserid').value + '&cm=' + document.getElementById('hdncompname').value, '', 'width=' + screen.availWidth + ',height=' + screen.availHeight + ',resizable=1,left=0,top=0,scrollbars=yes');

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
        var res = PODetailList.Bindsuppcode(jq('#' + CurrentTextId).val().toUpperCase(), jq("#txtsuppnamecode").val(), "", "", "", "", connstring, BindsupliercdCallbackgrid);
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