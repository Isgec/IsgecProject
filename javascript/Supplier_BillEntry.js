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

function setButtonImages() {
    if (document.getElementById('btnNew').disabled == true)
        document.getElementById('btnNew').src = "btimages/new-off.jpg";
    else
        document.getElementById('btnNew').src = "btimages/new.jpg";

    if (document.getElementById('btnSave').disabled == true)
        document.getElementById('btnSave').src = "btimages/save-off.jpg";
    else
        document.getElementById('btnSave').src = "btimages/save.jpg";

    if (document.getElementById('btnModify').disabled == true)
        document.getElementById('btnModify').src = "btimages/modify-off.jpg";
    else
        document.getElementById('btnModify').src = "btimages/modify.jpg";

    if (document.getElementById('btnQuery').disabled == true)
        document.getElementById('btnQuery').src = "btimages/query-off.jpg";
    else
        document.getElementById('btnQuery').src = "btimages/query.jpg";

    if (document.getElementById('btnExecute').disabled == true)
        document.getElementById('btnExecute').src = "btimages/execute-off.jpg";
    else
        document.getElementById('btnExecute').src = "btimages/execute.jpg";

    if (document.getElementById('btnCancel').disabled == true)
        document.getElementById('btnCancel').src = "btimages/clear-off.jpg";
    else
        document.getElementById('btnCancel').src = "btimages/clear.jpg";

    if (document.getElementById('btnfirst').disabled == true)
        document.getElementById('btnfirst').src = "btimages/first-off.jpg";
    else
        document.getElementById('btnfirst').src = "btimages/first.jpg";

    if (document.getElementById('btnprevious').disabled == true)
        document.getElementById('btnprevious').src = "btimages/previous-off.jpg";
    else
        document.getElementById('btnprevious').src = "btimages/previous.jpg";

    if (document.getElementById('btnnext').disabled == true)
        document.getElementById('btnnext').src = "btimages/next-off.jpg";
    else
        document.getElementById('btnnext').src = "btimages/next.jpg";

    if (document.getElementById('btnlast').disabled == true)
        document.getElementById('btnlast').src = "btimages/last-off.jpg";
    else
        document.getElementById('btnlast').src = "btimages/last.jpg";

    if (document.getElementById('btnExit').disabled == true)
        document.getElementById('btnExit').src = "btimages/exit-off.jpg";
    else
        document.getElementById('btnExit').src = "btimages/exit.jpg";
}


////bill type///
function bindbilltypecodef2(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var activeid = document.activeElement.id.split('_')[1];
    var id = activeid;//CurrentTextId.split('_')[1];

    CurrentTextId = document.activeElement.id;
    if (event.keyCode == 113) {
        OffSetForGrid(document.activeElement.id, "divbilltype", "lstbilltype", "view");
        var connstring = document.getElementById("hdnconnectionstring").value;
        var billtype = document.getElementById(CurrentTextId).value;
        var extra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
        var res = Supplier_BillEntry.Bindbilltypecode(billtype,  extra1, extra2, extra3, extra4, extra5,connstring, BindBillTypeCdCallbackgrid);
        return false;
    }
    else if (keycode == 8 || keycode == 46) {
        jq('#' + CurrentTextId, "#hdntranstype").val('')
    }
    else if (keycode != 13 && keycode != 37 && keycode != 39 && keycode != 9 && keycode != 17 && event.shiftKey == false && event.ctrlKey == false && event.altKey == false) {
        jq('#' + CurrentTextId, "#hdntranstype").val('')
    }
    if (event.ctrlKey == true && keycode == 88) {
        jq('#' + CurrentTextId, "#hdntranstype").val('')
    }
}

function BindBillTypeCdCallbackgrid(res) {
    var ds = res.value;
    var pkgitem = document.getElementById('lstbilltype')
    pkgitem.options.length = 0;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        pkgitem.options[0] = new Option("---Select Trans. Type---", "0");
        pkgitem.options.length = 1;
        for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].Description + "~" + ds.Tables[0].Rows[i].TranTypeID, ds.Tables[0].Rows[i].Description + "~" + ds.Tables[0].Rows[i].TranTypeID);
            pkgitem.options.length;
        }
    }
    else {
        pkgitem.options[0] = new Option("---There is no data accourding your search---", "");
        return false;
    }
    jq('#lstbilltype').focus();
    return false;
}
function fillbilltypecode(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var id = CurrentTextId.split('_')[1];
    if (keycode == 13 || event.type == "click") {
        if (fndnull(jq('#lstbilltype').val()) == "") {
            alert("Please Select Trans. Type..!!");
            jq('#lstbilltype').focus();
            return false;
        }
        var activeid = CurrentTextId.split('_')[1];
        var page = jq('#lstbilltype').val()
        var str = page.split("~");
        jq('#txttrantype').val(str[0])
        jq('#hdntranstype').val(str[1])
        jq('#divbilltype').css("display", "none");
        jq('#txttrantype').focus();
        return false;
    }
    else if (keycode == 27) {
        jq('#divbilltype').css("display", "none");
        jq('#lstbilltype' + id).focus();
        return false;
    }
}

////hsnsaccode///
function bindhsnsaccodef2(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var activeid = document.activeElement.id.split('_')[1];
    var id = activeid;//CurrentTextId.split('_')[1];

    CurrentTextId = document.activeElement.id;
    if (event.keyCode == 113) {
        OffSetForGrid(document.activeElement.id, "divhsnsaccd", "lsthsnsaccd", "view");
        var connstring = document.getElementById("hdnconnectionstring").value;
        var hsnsaccd = document.getElementById(CurrentTextId).value;
        var extra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
        var res = Supplier_BillEntry.Bindhsnsaccode(hsnsaccd, extra1, extra2, extra3, extra4, extra5, connstring, BindHsnCdCallbackgrid);
        return false;
    }
    else if (keycode == 8 || keycode == 46) {
        jq('#' + CurrentTextId, "#hdnshiptostate").val('')
    }
    else if (keycode != 13 && keycode != 37 && keycode != 39 && keycode != 9 && keycode != 17 && event.shiftKey == false && event.ctrlKey == false && event.altKey == false) {
        jq('#' + CurrentTextId, "#hdnshiptostate").val('')
    }
    if (event.ctrlKey == true && keycode == 88) {
        jq('#' + CurrentTextId, "#hdnshiptostate").val('')
    }
}

function BindHsnCdCallbackgrid(res) {
    var ds = res.value;
    var pkgitem = document.getElementById('lsthsnsaccd')
    pkgitem.options.length = 0;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        pkgitem.options[0] = new Option("---Select Ship To State---", "0");
        pkgitem.options.length = 1;
        for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].StateID + "~" + ds.Tables[0].Rows[i].Description, ds.Tables[0].Rows[i].StateID + "~" + ds.Tables[0].Rows[i].Description);
            pkgitem.options.length;
        }
    }
    else {
        pkgitem.options[0] = new Option("---There is no data accourding your search---", "");
        return false;
    }
    jq('#lsthsnsaccd').focus();
    return false;
}
function fillhsnsaccode(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var id = CurrentTextId.split('_')[1];
    if (keycode == 13 || event.type == "click") {
        if (fndnull(jq('#lsthsnsaccd').val()) == "") {
            alert("Please Select Ship To State..!!");
            jq('#lstbilltype').focus();
            return false;
        }
        var activeid = CurrentTextId.split('_')[1];
        var page = jq('#lsthsnsaccd').val()
        var str = page.split("~");
        jq('#txtshiptostate').val(str[1])
        jq('#hdnshiptostate').val(str[0])
        jq('#divhsnsaccd').css("display", "none");
        jq('#txtshiptostate').focus();
        return false;
    }
    else if (keycode == 27) {
        jq('#divhsnsaccd').css("display", "none");
        jq('#lsthsnsaccd' + id).focus();
        return false;
    }
}

////Employee///
function bindemployeef2(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var activeid = document.activeElement.id.split('_')[1];
    var id = activeid;//CurrentTextId.split('_')[1];

    CurrentTextId = document.activeElement.id;
    if (event.keyCode == 113) {
        OffSetForGrid(document.activeElement.id, "divemployee", "lstemployee", "view");
        var connstring = document.getElementById("hdnconnectionstring").value;
        var hsnsaccd = document.getElementById(CurrentTextId).value;
        var extra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
        var res = Supplier_BillEntry.Bindemployeecode(hsnsaccd, extra1, extra2, extra3, extra4, extra5, connstring, BindEmployeeCdCallbackgrid);
        return false;
    }
    else if (keycode == 8 || keycode == 46) {
        jq('#' + CurrentTextId, "#hdnpono").val('')
        jq('#hdnpono' + i).val('')
        for (var i = 0; i < execount; i++) {
            jq('#txtsgstrate_' + i).val('')
            jq('#txtcgstrate_' + i).val('')
            jq('#txtigstrate_' + i).val('')
            jq('#txtcessrate_' + i).val('')
            jq('#txtsgstamt_' + i).val('')
            jq('#txtcgstamt_' + i).val('')
            jq('#txtigstamt_' + i).val('')
            jq('#txtcessamt_' + i).val('')

            jq('#txtitemcode_' + i).val('')
            jq('#hdnitemcdgrid_' + i).val('')
            jq('#txtuom_' + i).val('')
            jq('#txtbilltype_' + i).val('')
            jq('#hdnbilltypecdgrid_' + i).val('')
            jq('#txthsnsac_' + i).val('')
            jq('#hdnhsnsaccdgrid_' + i).val('')
            jq('#txtqty_' + i).val('')
            jq('#txtcurrency_' + i).val('')
            jq('#txtconversionfact_' + i).val('')
            jq('#txtaccessbleval_' + i).val('')
            jq('#hdnquantitygrid_' + i).val('')
            jq('#hdnaccessvaluegrid_' + i).val('')
            jq('#txttotalgst_' + i).val('')
            jq('#txttotalamt_' + i).val('')
            jq('#txttotalgstinr_' + i).val('')
            jq('#txttotalamtinr_' + i).val('')
            jq('#txtemployee_' + i).val('')
            jq('#hdnemployeegrid_' + i).val('')
            jq('#txtdepartment_' + i).val('')
            jq('#hdndepartmentgrid_' + i).val('')
            jq('#txtcostcenter_' + i).val('')
            jq('#hdncostcentergrid_' + i).val('')
            jq('#txttcsrate_' + i).val('')
            jq('#txttcsamt_' + i).val('')
            jq('#txtpoline_' + i).val('')
            jq('#hdnpolinegrid_' + i).val('')
        }
    }
    else if (keycode != 13 && keycode != 37 && keycode != 39 && keycode != 9 && keycode != 17 && event.shiftKey == false && event.ctrlKey == false && event.altKey == false) {
        jq('#' + CurrentTextId, "#hdnpono").val('')

    }
    if (event.ctrlKey == true && keycode == 88) {
        jq('#' + CurrentTextId, "#hdnpono").val('')
    }
}

function BindEmployeeCdCallbackgrid(res) {
    var ds = res.value;
    var pkgitem = document.getElementById('lstemployee')
    pkgitem.options.length = 0;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        pkgitem.options[0] = new Option("---Select PO---", "0");
        pkgitem.options.length = 1;
        for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].PONo + "~" + ds.Tables[0].Rows[i].BPCode + "~" + ds.Tables[0].Rows[i].IsgecGSTIN + "~" + ds.Tables[0].Rows[i].BPNAME + "~" + ds.Tables[0].Rows[i].BPgstin_desc + "~" + ds.Tables[0].Rows[i].BPGSTIN + "~" + ds.Tables[0].Rows[i].IsgecGSTINid, ds.Tables[0].Rows[i].PONo + "~" + ds.Tables[0].Rows[i].BPCode + "~" + ds.Tables[0].Rows[i].IsgecGSTIN + "~" + ds.Tables[0].Rows[i].BPNAME + "~" + ds.Tables[0].Rows[i].BPgstin_desc + "~" + ds.Tables[0].Rows[i].BPGSTIN + "~" + ds.Tables[0].Rows[i].IsgecGSTINid);
            pkgitem.options.length;
        }
    }
    else {
        pkgitem.options[0] = new Option("---There is no data accourding your search---", "");
        return false;
    }
    jq('#lstemployee').focus();
    return false;
}
function fillemployeecode(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var id = CurrentTextId.split('_')[1];
    if (keycode == 13 || event.type == "click") {
        if (fndnull(jq('#lstemployee').val()) == "") {
            alert("Please Select PoNO..!!");
            jq('#lstemployee').focus();
            return false;
        }
        var activeid = CurrentTextId.split('_')[1];
        var page = jq('#lstemployee').val()
        var str = page.split("~");
        jq('#txtpo').val(str[0])
        jq('#hdnpono').val(str[0])
        jq('#txtsupcode').val(str[1])
        jq('#hdnsuppgstin').val(str[5])
        jq('#txtsupname').val(str[3])
        jq('#txtisgecgstin').val(str[2])
        jq('#txtgstin').val(str[4])
        jq('#hdnisgecgsiid').val(str[6])
        jq('#divemployee').css("display", "none");
        jq('#txtpo').focus();
        return false;
    }
    else if (keycode == 27) {
        jq('#divemployee').css("display", "none");
        jq('#lstemployee' + id).focus();
        return false;
    }
}

function CommonCreateRow(tablename) {
    if (tablename == "new_page") {
        for (var xx = 0; xx < count; xx++) {
            if (jq('#txtitemcode_' + xx).val() == "") {
                alert("Please fill ITEM and UOM and TAX by [F2]")
                jq('#txtitemcode_' + xx).val('')
                jq('#txtitemcode_' + xx).focus()
                return false;
            }




        }
    }
    if (confirm("Do You Want To Add New Row")) {
        var table = document.getElementById(tablename);
        var rowCount = table.rows.length;
        var colCount = table.rows[1].cells.length;
        var row = table.insertRow(rowCount);
        for (var i = 0; i < colCount; i++) {
            var newcell = row.insertCell(i);
            if (table.rows[rowCount - 1].cells[i].style.display == "none") {
                newcell.style.display = "none";
            }
            if (table.rows[rowCount - 1].cells[i].align == "center") {
                newcell.align = "center";
            }
            newcell.innerHTML = table.rows[rowCount - 1].cells[i].innerHTML;
            for (var x = 0; x < newcell.childNodes.length; x++) {
                var old_value = "";
                if (newcell.childNodes[x].alt == "copydata") {
                    old_value = $(newcell.childNodes[x].id).value;
                }
                var old_value_drp = "";
                if (newcell.childNodes[x].title != "") {
                    old_value_drp = newcell.childNodes[x].title;
                }
                switch (newcell.childNodes[x].type || newcell.childNodes[x].tagName) {
                    case "text":
                        if (newcell.childNodes[x].id.split('_')[0] == "txtsno") {
                            newcell.childNodes[x].value = parseInt(rowCount); newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));
                        }
                        else if (newcell.childNodes[x].id.split('_')[0] == "txtunit") {
                            newcell.childNodes[x].value = fndnull(jq('#txtunit').val()); newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));
                        }
                        else if (newcell.childNodes[x].id.split('_')[0] == "txtbranch") {
                            newcell.childNodes[x].value = fndnull(jq('#drbranch').val()); newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));
                        }
                        else if (newcell.childNodes[x].id.split('_')[0] == "hdnunitcdgrid") {
                            newcell.childNodes[x].value = fndnull(jq('#hdnunitcd').val()); newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));
                        }
                        else if (newcell.childNodes[x].id.split('_')[0] == "hdnbranchcdgrid") {
                            newcell.childNodes[x].value = fndnull(jq('#hdnbrancd').val()); newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));
                        }
                        else {
                            newcell.childNodes[x].value = ""; newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));
                        }
                        break;
                    case "hidden":
                        newcell.childNodes[x].value = ""; newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));
                        break;
                    case "IMG":
                        newcell.childNodes[x].value = ""; newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));// var calid = jq('#' + newcell.childNodes[x].id).attr("onclick").split(',')[0] + "," + jq('#' + newcell.childNodes[x].id).attr("onclick").split(',')[1].slice(0, jq('#' + newcell.childNodes[x].id).attr("onclick").split(',')[1].length - 1) + newcell.childNodes[x].id.split('_')[1] + "," + jq('#' + newcell.childNodes[x].id).attr("onclick").split(',')[2] + "," + jq('#' + newcell.childNodes[x].id).attr("onclick").split(',')[3]; jq('#' + newcell.childNodes[x].id).attr("onclick", calid);
                        break;
                    case "button":
                        newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));
                        break;
                    case "checkbox":
                        newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));
                        jq('#' + newcell.childNodes[x].id).attr('checked', false);
                        break;
                    case "select-one":
                        newcell.childNodes[x].value = old_value_drp; newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));
                        break;
                }
            }
        }
        document.getElementById(row.cells[1].childNodes[0].id).focus();
        EnableGrid();
        if (tablename == "new_page") {
            count++;
            execount = count;
        }
        return false
    }
    return false;
}

function EnabledOnNew() {
    flag = "I";
    jq('#hdnflag').val('new');
    jq('#hdnstatusflag').val('N');
    jq('#txtpurtype,#txttrantype,#txtshiptostate,#txtpo,#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbillno,#txtbilldate,#txtbillremark,#txtbilltotamt,#txtadviceno,#txtemployeeid').prop("disabled", false);
    jq('#txtirnno,#txtpurtype,#txttrantype,#txtshiptostate,#txtpo,#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbillno,#txtbilldate,#txtbillremark,#txtbilltotamt,#txtadviceno,#txtemployeeid').val('');
    jq('#btnModify,#btnQuery,#btnExecute,#btnfirst,#btnprevious,#btnnext,#btnlast,#btnNew,#txtirnno').prop("disabled", true);
    jq('#btnSave').prop("disabled", false);
    jq("#txtpurtype,#txttrantype,#txtshiptostate,#txtpo,#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbillno,#txtbilldate,#txtbillremark,#txtbilltotamt,#txtadviceno,#txtemployeeid").css("background-color", "#FFFFFF");

    jq('#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbilltotamt,#txtadviceno,#txtemployeeid,#txtcrtdby,#txtcrtdon').prop("disabled", true);
    jq('#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbilltotamt,#txtadviceno,#txtemployeeid,#txtcrtdby,#txtcrtdon').css("background-color", "#C0C0C0");
    if (jq("#drpcurrency").val() == "INR") {
        jq("#txtconvervisonfactor").val("1");
        jq("#txtconvervisonfactor").css("background-color", "#C0C0C0");
    }
    //bindgriddetail();
    setButtonImages();
    return false;
}

function clearclick() {
    jq('#txtirnno,#txtpurtype,#txttrantype,#txtshiptostate,#txtpo,#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbillno,#txtbilldate,#txtbillremark,#txtbilltotamt,#txtadviceno,#txtemployeeid,#txtcrtdby,#txtcrtdon').prop("disabled", false);
    jq('#txtirnno,#txtirnno,#txtpurtype,#txttrantype,#txtshiptostate,#txtpo,#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbillno,#txtbilldate,#txtbillremark,#txtbilltotamt,#txtadviceno,#txtemployeeid').val('');
    
    jq("#txtirnno,#txtpurtype,#txttrantype,#txtshiptostate,#txtpo,#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbillno,#txtbilldate,#txtbillremark,#txtbilltotamt,#txtadviceno,#txtemployeeid").css("background-color", "#C0C0C0");
    jq('#btnSave,#btnModify,#btnExecute,#btnfirst,#btnprevious,#btnnext,#btnlast').prop("disabled", true);
    jq('#btnNew,#btnQuery').prop("disabled", false);
    jq('#btnNew,#btnCancel,#btnExit').focus();
    bindgriddetail();
    setButtonImages();
    if (document.getElementById("hdnirno").value != "") {
        getrdncheck(document.getElementById("hdnirno").value);
    }
    return false;
}


function EnabledOnQuery() {
    jq('#hdnflag').val('modify');
    jq('#txtpurtype,#txttrantype,#txtshiptostate,#txtpo,#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbillno,#txtbilldate,#txtbillremark,#txtbilltotamt,#txtadviceno,#txtemployeeid').prop("disabled", false);
    jq('#txtirnno,#txtpurtype,#txttrantype,#txtshiptostate,#txtpo,#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbillno,#txtbilldate,#txtbillremark,#txtbilltotamt,#txtadviceno,#txtemployeeid').val('');
    jq('#btnSave,#btnModify,#btnQuery,#btnNew').prop("disabled", true);
    jq('#btnExecute,#btnCancel,#btnExit,#btnfirst,#btnprevious,#btnnext,#btnlast').prop("disabled", false);

    //jq("#txtpo,#txtsupname,#txtquationno,#txtisgecgstin,#txtaprvdt,#txtqudt,#txtpymntterm,#txtdelveryon,#txtdispacth,#txtdes,#txtinsurance,#txtconvervisonfactor,#drpcurrency,#txtremrks").css("background-color", "#FFFFFF");
    //jq('#taxtypemaster').css("dispaly", "block");
    document.getElementById("btnExecute").focus();
    setButtonImages();
    return false;
}

function OnClickModify() {
    if (document.getElementById("txtadviceno").value == "") {
        flag = "U";
        jq('#btnNew').attr('disabled', true);
        jq('#btnSave').attr('disabled', false);
        jq('#btnModify').attr('disabled', true);
        jq('#btnQuery').attr('disabled', true);
        jq('#btnExecute').attr('disabled', true);
        jq('#btnCancel').attr('disabled', false);
        jq('#btnfirst').attr('disabled', true);
        jq('#btnprevious').attr('disabled', true);
        jq('#btnnext').attr('disabled', true);
        jq('#btnlast').attr('disabled', true);
        jq('#btnDelete').attr('disabled', true);
        jq('#btnExit').attr('disabled', false);
        setButtonImages();
        jq('#txtpurtype,#txttrantype,#txtshiptostate,#txtpo,#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbillno,#txtbilldate,#txtbillremark,#txtbilltotamt,#txtadviceno,#txtemployeeid').prop("disabled", true);
        jq('#txtpurtype,#txttrantype,#txtshiptostate,#txtbillno,#txtbilldate,#txtbillremark').prop("disabled", false);
        jq("#txtpurtype,#txttrantype,#txtshiptostate,#txtbillno,#txtbilldate,#txtbillremark").css("background-color", "#FFFFFF");
        for (var i = 0  ; i < execount ; i++) {
            document.getElementById("txtqty_" + i).disabled = false;
            document.getElementById("txtaccessbleval_" + i).disabled = false;
            document.getElementById("txtemployee_" + i).disabled = false;
            jq("#txtqty_" + i).css("background-color", "#FFFFFF");
            jq("#txtaccessbleval_" + i).css("background-color", "#FFFFFF");
            jq("#txtemployee_" + i).css("background-color", "#FFFFFF");
        }
        return false;
    }
    else {
        alert('IRN not modified or deleted');
        return false;
    }
}


function onsaveclick() {

    try {
        if (flag == "U") {
            savedata(flag);
        }
        else {
            savedata();
        }
    }
    catch (ex) {
        alert(ex);
    }
}

function savedata(flag) {

    for (var i = 0  ; i < execount ; i++) {
        if (jq('#hdnpoline_' + i).val() == "") {
            alert("Please select the po line in line");
            return false;
        }
    if (jq('#hdntranstype').val() == "") {
        alert("Please select the transaction type");
        jq('#txttrantype').focus();
        return false;
    }
    if (jq('#hdnshiptostate').val() == "") {
        alert("Please select the Ship To State");
        jq('#txtshiptostate').focus();
        return false;
    }
    if (jq('#hdnpono').val() == "") {
        alert("Please select the PO No");
        jq('#txtpo').focus();
        return false;
    }
    if (jq('#txtbillno').val() == "") {
        alert("Please select the Bill No");
        jq('#txtbillno').focus();
        return false;
    }
    if (jq('#txtbilldate').val() == "") {
        alert("Please select the Bill date");
        jq('#txtbilldate').focus();
        return false;
    }
    if (jq('#txtbillremark').val() == "") {
        alert("Please select the Bill Remark");
        jq('#txtbillremark').focus();
        return false;
    }
    if (jq('#txtbilltotamt').val() == "") {
        alert("Please select the Totalbill amt");
        jq('#txtbilltotamt').focus();
        return false;
    }
    /*if (jq('#txtadviceno').val() == "") {
        alert("Please select the Advice No");
        jq('#txtadviceno').focus();
        return false;
    }*/

        var modi = flag;
        var PPONo = document.getElementById("txtpo").value;
        var TranTypeID = document.getElementById("hdntranstype").value;
        var SupplierName= "";
        var BillNumber = document.getElementById("txtbillno").value;
        var BillDate = document.getElementById("txtbilldate").value;
        var CreatedBy = document.getElementById("hdnuserid").value;
        var TotalBillAmount = document.getElementById("txtbilltotamt").value;
        var AdviceNo = document.getElementById("txtadviceno").value;
        var IsgecGSTIN = document.getElementById("hdnisgecgsiid").value;
        var CreatedOn = document.getElementById("txtcrtdon").value;
        var EmployeeID = jq('#hdnemployeegrid_' + i).val();
        var IRReceivedOn  = "";
        var BillRemarks = document.getElementById("txtbillremark").value;
        var PurchaseType = document.getElementById("txtpurtype").value;
        var UploadBatchNo   = "";
        var CostCenterID    = "";
        var SupplierGSTIN = document.getElementById("hdnsuppgstin").value;
        var SupplierGSTINNumber= "";
        var ShipToState = document.getElementById("hdnshiptostate").value;
        var BPID = document.getElementById("txtsupcode").value;
        var DepartmentID      ="";
        var ElementID     = "";
        var ProjectID       = "";
        var irno = document.getElementById("txtirnno").value;
        if (modi == "U") {
            var flag = "U";
        }
        else {
            var flag = "I";
        }
        var pextra1 = "";
        var pextra2 = "";
        var pextra3 = "";
        var pextra4 = "";
        var pextra5 = "";
        var connstring = document.getElementById("hdnconnectionstring").value;
        var res_vch2 = "";
        if (i == 0) {
            res_vch2 = Supplier_BillEntry.hdr_save(PPONo, TranTypeID, SupplierName, BillNumber, BillDate, CreatedBy, TotalBillAmount, AdviceNo, IsgecGSTIN,
            CreatedOn, EmployeeID, IRReceivedOn, BillRemarks, PurchaseType, UploadBatchNo, CostCenterID, SupplierGSTIN, SupplierGSTINNumber,
            ShipToState, BPID, DepartmentID, ElementID, ProjectID, irno, flag, pextra1, pextra2, pextra3, pextra4, pextra5, connstring);
        }
        if (res_vch2.error != null) {
            alert(res_vch2.error.description);
            return false;
        }
        else {
            
            var res_vch = "";
            var pitemcode = document.getElementById('hdnitemcdgrid_' + i).value;
            var pbilltype = jq('#hdnbilltypecdgrid_' + i).val();
            var phsnsaccd = jq('#hdnhsnsaccdgrid_' + i).val();
            var puom = jq('#txtuom_' + i).val();
            var pquantity = jq('#txtqty_' + i).val();
            var pcurrency = jq('#txtcurrency_' + i).val();
            var pconversio = jq('#txtconversionfact_' + i).val();
            var paccessval = jq('#txtaccessbleval_' + i).val();
            var pigstrate = jq('#txtigstrate_' + i).val();
            var pigstamount = jq('#txtigstamt_' + i).val();
            var psgstrate = jq('#txtsgstrate_' + i).val();
            var psgstamount = jq('#txtsgstamt_' + i).val();
            var pcgstrate = jq('#txtcgstrate_' + i).val();
            var pcgstamount = jq('#txtcgstamt_' + i).val();
            var pcessrate = jq('#txtcessrate_' + i).val();
            var pcessamount = jq('#txtcessamt_' + i).val();
            var ptotalgst = jq('#txttotalgst_' + i).val();
            var ptotalamt = jq('#txttotalamt_' + i).val();
            var ptotalgstinr = jq('#txttotalgstinr_' + i).val();
            if (modi == "U") {
                var flag = "U";
                var irnosave = document.getElementById("txtirnno").value;
            }
            else {
                var flag = "I";
                var irnosave = res_vch2.value.Tables[0].Rows[0].PO_NO;
                document.getElementById("txtirnno").value = res_vch2.value.Tables[0].Rows[0].PO_NO;
            }
            var ptotalamtinr = jq('#txttotalamtinr_' + i).val();
            var pemployeeid = jq('#hdnemployeegrid_' + i).val();
            var pdepatmentid = jq('#hdndepartmentgrid_' + i).val();
            var pcostcenterid = jq('#hdncostcentergrid_' + i).val();
            var ptcsrate = jq('#txttcsrate_' + i).val();
            var ptcsamount = document.getElementById("txttcsamt_" + i).value;
            var ppono = document.getElementById("hdnponogrid_" + i).value;
            var ppoline = document.getElementById("hdnpolinegrid_" + i).value;
            var connstring = document.getElementById("hdnconnectionstring").value;
            if (pbilltype == "0") {
                pbilltype = "1";
            }
            res_vch = Supplier_BillEntry.hdr_savedet(irnosave, pitemcode, pbilltype, phsnsaccd, puom, pquantity, pcurrency, pconversio, paccessval, pigstrate, pigstamount, psgstrate,
           psgstamount, pcgstrate, pcgstamount, pcessrate, pcessamount, ptotalgst, ptotalamt, ptotalgstinr, ptotalamtinr, pemployeeid, pdepatmentid, pcostcenterid, ptcsrate, ptcsamount,
           connstring, ppono, ppoline, flag);

            if (res_vch.error != null) {
                alert(res_vch.error.description);
                return false;
            }
            else {
                alert(res_vch.value.Tables[0].Rows[0].MSG)
                // clearclick();
                document.getElementById("hdnirno").value = "";
                win = window.open('SupplierBillList.aspx?pono=' + "" + '&us=' + document.getElementById('hdnuserid').value + '&cm=' + document.getElementById('hdncompname').value, '', 'width=' + screen.availWidth + ',height=' + screen.availHeight + ',resizable=1,left=0,top=0,scrollbars=yes');
                window.close();
                return false;
            }
        }

    }
    return false;
}




function bindpolinef2(event) {
    if (jq('#hdnpono').val() == "") {
        alert("Please Select the PO header first.")
        return false;
    }
    else {
        var keycode = event.keyCode ? event.keyCode : event.which;
        var activeid = document.activeElement.id.split('_')[1];
        var id = activeid;//CurrentTextId.split('_')[1];

        CurrentTextId = document.activeElement.id;
        if (event.keyCode == 113) {
            OffSetForGrid(document.activeElement.id, "divitemcode", "lstitemcode", "view");
            var connstring = document.getElementById("hdnconnectionstring").value;
            var res = Supplier_BillEntry.Bindpoline(jq('#hdnpono').val().toUpperCase(), jq('#' + CurrentTextId).val().toUpperCase(), "", "", "", "", "", connstring, BinditemcdCallbackgrid);
            return false;
        }
        else if (keycode == 8 || keycode == 46) {
            jq('#' + CurrentTextId, "#hdnpoline_" + id).val('')
        }
        else if (keycode != 13 && keycode != 37 && keycode != 39 && keycode != 9 && keycode != 17 && event.shiftKey == false && event.ctrlKey == false && event.altKey == false) {
            jq('#' + CurrentTextId, "#hdnpoline_" + id).val('')
        }
        if (event.ctrlKey == true && keycode == 88) {
            jq('#' + CurrentTextId, "#hdnpoline_" + id).val('')
        }
    }
}

function BinditemcdCallbackgrid(res) {
    var ds = res.value;
    var pkgitem = document.getElementById('lstitemcode')
    pkgitem.options.length = 0;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        pkgitem.options[0] = new Option("---Select PO Line---", "0");
        pkgitem.options.length = 1;
        for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].poline + "~" + ds.Tables[0].Rows[i].poline + "~" + ds.Tables[0].Rows[i].pono, ds.Tables[0].Rows[i].poline + "~" + ds.Tables[0].Rows[i].poline + "~" + ds.Tables[0].Rows[i].pono);
            pkgitem.options.length;
        }
    }
    else {
        pkgitem.options[0] = new Option("---There is no data accourding your search---", "");
        return false;
    }
    jq('#lstitemcode').focus();
    return false;
}
function fillitemcode(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var id = CurrentTextId.split('_')[1];
    if (keycode == 13 || event.type == "click") {
        if (fndnull(jq('#lstitemcode').val()) == "") {
            alert("Please Select Po Line..!!");
            jq('#lstitemcode').focus();
            return false;
        }
        var activeid = CurrentTextId.split('_')[1];
        var page = jq('#lstitemcode').val()
        var str = page.split("~");
        jq('#txtpoline_' + id).val(str[0])
        jq('#hdnpolinegrid_' + id).val(str[1])
        jq('#hdnponogrid_' + id).val(str[2])

        var connstring = document.getElementById("hdnconnectionstring").value;
        var res = Supplier_BillEntry.Bindpoline(jq('#hdnponogrid_' + id).val(), jq('#hdnpolinegrid_' + id).val(), "", "", "", "", "", connstring);
        var ds = res.value;
        if (ds.Tables[0].Rows.length > 0) {
            if (parseFloat(ds.Tables[0].Rows[0].quantity1) != 0) {
                jq('#txtsgstrate_' + id).val(parseFloat(ds.Tables[0].Rows[0].sgstrate).toFixed(2))
                jq('#txtcgstrate_' + id).val(parseFloat(ds.Tables[0].Rows[0].cgstrate).toFixed(2))
                jq('#txtigstrate_' + id).val(parseFloat(ds.Tables[0].Rows[0].IGSTrate).toFixed(2))
                jq('#txtcessrate_' + id).val(parseFloat(ds.Tables[0].Rows[0].CESSrate).toFixed(2))
                jq('#txtsgstamt_' + id).val(parseFloat(ds.Tables[0].Rows[0].sgstamount).toFixed(2))
                jq('#txtcgstamt_' + id).val(parseFloat(ds.Tables[0].Rows[0].CGSTAmount).toFixed(2))
                jq('#txtigstamt_' + id).val(parseFloat(ds.Tables[0].Rows[0].igstamount).toFixed(2))
                jq('#txtcessamt_' + id).val(parseFloat(ds.Tables[0].Rows[0].CESSAmount).toFixed(2))

                jq('#txtitemcode_' + id).val(ds.Tables[0].Rows[0].itemname)
                jq('#hdnitemcdgrid_' + id).val(ds.Tables[0].Rows[0].ItemCode)
                jq('#txtuom_' + id).val(ds.Tables[0].Rows[0].unit)
                jq('#txtbilltype_' + id).val(ds.Tables[0].Rows[0].billtypname)
                jq('#hdnbilltypecdgrid_' + id).val(ds.Tables[0].Rows[0].BillType)
                jq('#txthsnsac_' + id).val(ds.Tables[0].Rows[0].hsnname)
                jq('#hdnhsnsaccdgrid_' + id).val(ds.Tables[0].Rows[0].HSNSACCode)
                jq('#txtqty_' + id).val(ds.Tables[0].Rows[0].quantity1)
                jq('#txtcurrency_' + id).val(ds.Tables[0].Rows[0].currency)
                jq('#txtconversionfact_' + id).val(ds.Tables[0].Rows[0].ConversionFactorINR)
                jq('#txtaccessbleval_' + id).val(parseFloat(ds.Tables[0].Rows[0].amount).toFixed(2))
                jq('#hdnquantitygrid_' + id).val(ds.Tables[0].Rows[0].quantity1)
                jq('#hdnaccessvaluegrid_' + id).val(parseFloat(ds.Tables[0].Rows[0].amount).toFixed(2))
                jq('#txttotalgst_' + id).val(parseFloat(ds.Tables[0].Rows[0].totalgst).toFixed(2))
                jq('#txttotalamt_' + id).val(parseFloat(ds.Tables[0].Rows[0].totalamt).toFixed(2))
                jq('#txttotalgstinr_' + id).val(parseFloat(ds.Tables[0].Rows[0].totalgst).toFixed(2))
                jq('#txttotalamtinr_' + id).val(parseFloat(ds.Tables[0].Rows[0].totalamtinr).toFixed(2))
                jq('#txtemployee_' + id).val(ds.Tables[0].Rows[0].emp_name)
                jq('#hdnemployeegrid_' + id).val(ds.Tables[0].Rows[0].EmployeeID)
                jq('#txtdepartment_' + id).val(ds.Tables[0].Rows[0].depart_nm)
                jq('#hdndepartmentgrid_' + id).val(ds.Tables[0].Rows[0].DepartmentID)
                jq('#txtcostcenter_' + id).val(ds.Tables[0].Rows[0].cost_nm)
                jq('#hdncostcentergrid_' + id).val(ds.Tables[0].Rows[0].CostCenterID)
                jq('#txttcsrate_' + id).val(parseFloat(ds.Tables[0].Rows[0].TCSrate).toFixed(2))
                jq('#txttcsamt_' + id).val(parseFloat(ds.Tables[0].Rows[0].TCSAmount).toFixed(2))

                var totalbillamt = 0;
                if (totalbillamt == 0) {
                    totalbillamt = parseFloat(jq('#txttotalamt_' + id).val());
                }
                else {
                    totalbillamt = parseFloat(totalbillamt) + parseFloat(jq('#txttotalamt_' + id).val());
                }
                document.getElementById("txtbilltotamt").value = parseFloat(totalbillamt).toFixed(2);
            }
            else {
                alert("PO fully received.Bill cannot be saved for this PO.")
                document.getElementById("txtbilltotamt").value = "0.00";
                jq('#divitemcode').css("display", "none");
                jq('#txtpoline_' + id).focus();
                jq('#txtpoline_' + id).val('')
                jq('#hdnpolinegrid_' + id).val('')
                return false;
            }
        }
        jq('#divitemcode').css("display", "none");
        jq('#txtpoline_' + id).focus();
        return false;
    }
    else if (keycode == 27) {
        jq('#divitemcode').css("display", "none");
        jq('#txtpoline_' + id).focus();
        return false;
    }
}

function bindgriddetail() {
    try {


        count = 0;
        var hdsview = "";
        if (document.getElementById('divpogrid').innerHTML == "") {
            jq('#divpogrid').empty();
            hdsview += BindGridHeader();
            hdsview += ("<tr>")
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' value=''id=txtserialline_" + count + " ></td>"
            hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left;' value='' id=txtpoline_" + count + " value='' onkeydown='return bindpolinef2(event);' ></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' value='' id=txtitemcode_" + count + "></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' value='' id=txtbilltype_" + count + " ></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' value='' id=txthsnsac_" + count + " ></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' value='' id=txtuom_" + count + "></td>"
            hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left;' id=txtqty_" + count + "    value='' onblur='return calamtqty(this);' ></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' value='' id=txtcurrency_" + count + " ></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' value='' id=txtconversionfact_" + count + "></td>"
            hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left;'  id=txtaccessbleval_" + count + " value=''   onblur='return calamtaccess(this);' ></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txtsgstrate_" + count + " ></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txtcgstrate_" + count + "></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txtigstrate_" + count + " ></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txtcessrate_" + count + "></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txtsgstamt_" + count + " ></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txtcgstamt_" + count + " ></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txtigstamt_" + count + "></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txtcessamt_" + count + "></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txttotalgst_" + count + "></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txttotalamt_" + count + "></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txttotalgstinr_" + count + "></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txttotalamtinr_" + count + "></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txtemployee_" + count + "></td>"
            //hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left; value='' id=txtemployee_" + count + " value='' onkeydown='return bindemployeef2(event);' ></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txtdepartment_" + count + "></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txtcostcenter_" + count + "></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txttcsrate_" + count + "></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='' id=txttcsamt_" + count + "></td>"
            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdnpolinegrid_" + count + "   disabled></td>";
            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdnponogrid_" + count + "   disabled></td>";
            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdnitemcdgrid_" + count + "   disabled></td>";
            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdnbilltypecdgrid_" + count + "   disabled></td>";
            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdnhsnsaccdgrid_" + count + "   disabled></td>";

            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdnemployeegrid_" + count + "   disabled></td>";
            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdndepartmentgrid_" + count + "   disabled></td>";
            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdncostcentergrid_" + count + "   disabled></td>";
            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdnquantitygrid_" + count + "   disabled></td>";
            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdnaccessvaluegrid_" + count + "   disabled></td>";

            hdsview += ("</tr>")
            count++;
            execount = count;
            hdsview += ("</table>")
            document.getElementById('divpogrid').innerHTML = hdsview;
            EnableGrid();
            jq('#divpogrid').css("display", "block");
            //CalculateAmounts();
        }
        else {
            document.getElementById('divpogrid').innerHTML += document.getElementById('divpogrid').innerHTML;
        }
    }
    catch (Ex) {
        alert(Ex);
        return false;
    }
    return false;
}
function BindGridHeader() {
    var hdsview = "";
    hdsview += ("<table id='new_page'  class='table table-bordered'>")
    hdsview += ("<tr style='height:15px; color: white;background-color: #5c9afb; font-size:13px;'>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>SerialNo</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Line No.<FONT color=red>F2*</FONT</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Item Code<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Bill Type<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>HSNSAC Code<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Unit<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Quantity<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Crrency<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Conversio Factor<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Assessable Value<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:5%;'>SGST rate<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>CGST rate<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>IGST rate<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>CESS rate<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>SGST Amount<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>CGST Amount<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>IGST Amount<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>CESS Amount<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Total GST<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Total Amount<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Total GST INR<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Total Amount INR<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Employee ID<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Department ID<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>CostCenter ID<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>TCS rate<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>TCS Amount<FONT color=red>*</FONT></td>")

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


function enterkeycode(event, id) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    if (event.keyCode == 13 || event.keyCode == 10) {
        /*if (browser == "Microsoft Internet Explorer")
            event.cancelBubble = true;
        else
            event.stopPropagation();*/
        // document.getElementById(id).focus();
        return false;
    }
}


function calamtaccess() {

    for (var i = 0; i < execount; i++) {
        if (document.getElementById('hdnpolinegrid_' + i).value != "") {
        var amount = parseFloat(document.getElementById('txtaccessbleval_' + i).value);
        var checkamount = parseFloat(document.getElementById('hdnaccessvaluegrid_' + i).value);
        if (amount <= checkamount) {
            var totalamt = parseFloat(amount) + parseFloat(document.getElementById('txttotalgst_' + i).value);
            var totalamtinr = (parseFloat(amount) + parseFloat(document.getElementById('txttotalgst_' + i).value)) * (parseFloat(document.getElementById('txtconversionfact_' + i).value));
            document.getElementById('txttotalamt_' + i).value = parseFloat(totalamt).toFixed(2);
            document.getElementById('txttotalamtinr_' + i).value = parseFloat(totalamtinr).toFixed(2);


            var totalbillamt = 0;
            if (totalbillamt == 0) {
                totalbillamt = parseFloat(jq('#txttotalamt_' + i).val());
            }
            else {
                totalbillamt = parseFloat(totalbillamt) + parseFloat(jq('#txttotalamt_' + i).val());
            }
            document.getElementById("txtbilltotamt").value = parseFloat(totalbillamt).toFixed(2);
        }
        else {
            alert("cannot be more than PO Balance amount")
            document.getElementById('txtaccessbleval_' + i).focus();
            document.getElementById('txtaccessbleval_' + i).value = parseFloat(document.getElementById('hdnaccessvaluegrid_' + i).value).toFixed(2);
            return false;
        }
        }
        else {
            alert("First you can select poline by f2")
            document.getElementById('txtpoline_' + id).focu();
            return false;
        }

    }
    return false;
}


function calamtqty() {

    for (var i = 0; i < execount; i++) {
        if (document.getElementById('hdnpolinegrid_' + i).value != "") {
            var qty = parseFloat(document.getElementById('txtqty_' + i).value);
            var checkqty = parseFloat(document.getElementById('hdnquantitygrid_' + i).value);
            if (qty <= checkqty) {
                //var totalamt = parseFloat(amount) + parseFloat(document.getElementById('txttotalgst_' + i).value);
                //var totalamtinr = (parseFloat(amount) + parseFloat(document.getElementById('txttotalgst_' + i).value)) * (parseFloat(document.getElementById('txtconversionfact_' + i).value));
                //document.getElementById('txttotalamt_' + i).value = parseFloat(amount).toFixed(2);
                //document.getElementById('txttotalamtinr_' + i).value = parseFloat(totalamtinr).toFixed(2);
            }
            else {
                alert("cannot be more than PO Line balance Qty")
                document.getElementById('txtqty_' + i).focus();

                document.getElementById('txtqty_' + i).value = parseFloat(document.getElementById('hdnquantitygrid_' + i).value).toFixed(2);
                return false;
            }
        }
        else {
            alert("First you can select poline by f2")
            document.getElementById('txtpoline_' + id).focu();
            return false;
        }

    }
    return false;
}



function OnClickNext() {
    next = parseInt(next) + 1;
    jq('#btnprevious').attr('disabled', false);
    jq('#btnfirst').attr('disabled', false);
    if (next == total_records - 1) {
        jq('#btnnext').attr('disabled', true);
        jq('#btnlast').attr('disabled', true);
        jq('#btnprevious').attr('disabled', false);
        jq('#btnfirst').attr('disabled', false);
        jq('#btnprevious').focus();
    }
    executehdr();
    return false;
}
function OnClickPrevious() {
    next = parseInt(next) - 1;
    jq('#btnnext').attr('disabled', false);
    jq('#btnlast').attr('disabled', false);
    if (next == 0) {
        jq('#btnprevious').attr('disabled', true);
        jq('#btnnext').attr('disabled', false);
        jq('#btnfirst').attr('disabled', true);
        jq('#btnlast').attr('disabled', false);
        jq('#btnnext').focus();
    }
    executehdr();
    return false;
}
function OnClickLast() {
    next = total_records - 1;
    jq('#btnprevious').attr('disabled', false);
    jq('#btnnext').attr('disabled', true);
    jq('#btnfirst').attr('disabled', false);
    jq('#btnlast').attr('disabled', true);
    jq('#btnprevious').focus();
    executehdr();
    return false;
}
function OnClickFirst() {
    next = 0;
    jq('#btnnext').attr('disabled', false);
    jq('#btnlast').attr('disabled', false);
    jq('#btnprevious').attr('disabled', true);
    jq('#btnfirst').attr('disabled', true);
    jq('#btnnext').focus();
    executehdr();
    return false;
}



function EnableExecute() {
    var res_vch12 = "";
    try {
        var PPONo = document.getElementById("txtpo").value;
        var TranTypeID = document.getElementById("hdntranstype").value;
        var SupplierName = "";
        var BillNumber = document.getElementById("txtbillno").value;
        var BillDate = document.getElementById("txtbilldate").value;
        var CreatedBy = document.getElementById("hdnuserid").value;
        var TotalBillAmount = document.getElementById("txtbilltotamt").value;
        var AdviceNo = document.getElementById("txtadviceno").value;
        var IsgecGSTIN = document.getElementById("hdnisgecgsiid").value;
        var CreatedOn = document.getElementById("txtcrtdon").value;
        var EmployeeID = "";
        var IRReceivedOn = "";
        var BillRemarks = document.getElementById("txtbillremark").value;
        var PurchaseType = document.getElementById("txtpurtype").value;
        var UploadBatchNo = "";
        var CostCenterID = "";
        var SupplierGSTIN = document.getElementById("hdnsuppgstin").value;
        var SupplierGSTINNumber = "";
        var ShipToState = document.getElementById("hdnshiptostate").value;
        var BPID = document.getElementById("txtsupcode").value;
        var DepartmentID = "";
        var ElementID = "";
        var ProjectID = "";
        var irno = document.getElementById("txtirnno").value;
        var flag = "E";
        var pextra1 = "";
        var pextra2 = "";
        var pextra3 = "";
        var pextra4 = "";
        var pextra5 = "";
        var connstring = document.getElementById("hdnconnectionstring").value;
        var res_vch2 = Supplier_BillEntry.hdr_save(PPONo, TranTypeID, SupplierName, BillNumber, BillDate, CreatedBy, TotalBillAmount, AdviceNo, IsgecGSTIN,
        CreatedOn, EmployeeID, IRReceivedOn, BillRemarks, PurchaseType, UploadBatchNo, CostCenterID, SupplierGSTIN, SupplierGSTINNumber,
        ShipToState, BPID, DepartmentID, ElementID, ProjectID, irno, flag, pextra1, pextra2, pextra3, pextra4, pextra5, connstring);

    }
    catch (e) {
        alert('An error has occurred: ' + e.message);
    }

    if (res_vch2.error != null) {
        alert(res_vch2.error.description);
        return false;
    }
    else {
        exec_data = res_vch2.value;
        if (exec_data.Tables[0].Rows.length == 0) {
            alert('There is no data accourding your search');
            clearclick();
            return false;
        }
        else {
            next = 0;
            record_show = 5
            record_show1 = 1
            exec_data = res_vch2.value;
            total_records = exec_data.Tables[0].Rows.length;
            jq('#btnNew,#btnSave,#btnExecute').prop("disabled", true);
            jq('#btnCancel,#btnExit,#btnlast,#btnModify,#btnfirst,#btnDelete,#btnprevious,#btnnext,#btnDelete').prop("disabled", false);
            jq('#txtirnno,#txtpurtype,#txttrantype,#txtshiptostate,#txtpo,#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbillno,#txtbilldate,#txtbillremark,#txtbilltotamt,#txtadviceno,#txtemployeeid,#txtcrtdby,#txtcrtdon').prop("disabled", false);
            jq("#txtirnno,#txtpurtype,#txttrantype,#txtshiptostate,#txtpo,#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbillno,#txtbilldate,#txtbillremark,#txtbilltotamt,#txtadviceno,#txtemployeeid").css("background-color", "#C0C0C0");
            executehdr();
            setButtonImages();

            return false;
        }

    }
    return false;
}

function executehdr(val) {

    if (exec_data.Tables[0].Rows[next].irno != null || exec_data.Tables[0].Rows[next].irno != "" || exec_data.Tables[0].Rows[next].irno != "null") {
        document.getElementById("txtirnno").value = fndnull(exec_data.Tables[0].Rows[next].irno);
        document.getElementById("txtpurtype").value = fndnull(exec_data.Tables[0].Rows[next].PurchaseType);
        document.getElementById("txttrantype").value = fndnull(exec_data.Tables[0].Rows[next].TranTypedesc);
        document.getElementById("txtshiptostate").value = fndnull(exec_data.Tables[0].Rows[next].ShipToStatedesc);
        document.getElementById("txtpo").value = fndnull(exec_data.Tables[0].Rows[next].orderno);
        document.getElementById("txtsupname").value = fndnull(exec_data.Tables[0].Rows[next].BPNAME);
        document.getElementById("txtsupcode").value = fndnull(exec_data.Tables[0].Rows[next].BPID);
        document.getElementById("txtgstin").value = fndnull(exec_data.Tables[0].Rows[next].BPgstin_desc);
        document.getElementById("txtisgecgstin").value = fndnull(exec_data.Tables[0].Rows[next].IsgecGSTINdesc);
        document.getElementById("txtbillno").value = fndnull(exec_data.Tables[0].Rows[next].BillNumber);
        document.getElementById("txtbilldate").value = fndnull(exec_data.Tables[0].Rows[next].BillDate);
        document.getElementById("txtbillremark").value = fndnull(exec_data.Tables[0].Rows[next].BillRemarks);
        document.getElementById("txtbilltotamt").value = fndnull(exec_data.Tables[0].Rows[next].TotalBillAmount);
        document.getElementById("txtadviceno").value = fndnull(exec_data.Tables[0].Rows[next].AdviceNo);
        document.getElementById("txtemployeeid").value = fndnull(exec_data.Tables[0].Rows[next].EmployeeID);
        document.getElementById("txtcrtdby").value = fndnull(exec_data.Tables[0].Rows[next].CreatedBy);
        document.getElementById("txtcrtdon").value = fndnull(exec_data.Tables[0].Rows[next].CreatedOn);
        document.getElementById("hdnpono").value = fndnull(exec_data.Tables[0].Rows[next].orderno);
        document.getElementById("hdnsuppgstin").value = fndnull(exec_data.Tables[0].Rows[next].SupplierGSTIN);
        document.getElementById("hdnisgecgsiid").value = fndnull(exec_data.Tables[0].Rows[next].IsgecGSTIN);
        document.getElementById("hdntranstype").value = fndnull(exec_data.Tables[0].Rows[next].TranTypeID);
        document.getElementById("hdnshiptostate").value = fndnull(exec_data.Tables[0].Rows[next].ShipToState);

        BindBudgetAccountDetail1(exec_data.Tables[0].Rows[next].irno);

    }


    return false;
}

var count1 = 0;
function BindBudgetAccountDetail1(typecd) {
    var pitemcode ="";
    var pbilltype = "";
    var phsnsaccd = "";
    var puom = "";
    var pquantity = "0";
    var pcurrency = "";
    var pconversio = "0";
    var paccessval = "0";
    var pigstrate = "0";
    var pigstamount = "0";
    var psgstrate = "0";
    var psgstamount = "0";
    var pcgstrate = "0";
    var pcgstamount = "0";
    var pcessrate = "0";
    var pcessamount = "0";
    var ptotalgst = "0";
    var ptotalamt = "0";
    var ptotalgstinr = "0";
    var flag = "E";
    var irnosave =document.getElementById("txtirnno").value;
    var ptotalamtinr ="0";
    var pemployeeid = "";
    var pdepatmentid = "";
    var pcostcenterid = "";
    var ptcsrate = "0";
    var ptcsamount = "0";
    var ppono = "";
    var ppoline = "";
    var connstring = document.getElementById("hdnconnectionstring").value;
    var res_vch2= Supplier_BillEntry.hdr_savedet(irnosave, pitemcode, pbilltype, phsnsaccd, puom, pquantity, pcurrency, pconversio, paccessval, pigstrate, pigstamount, psgstrate,
   psgstamount, pcgstrate, pcgstamount, pcessrate, pcessamount, ptotalgst, ptotalamt, ptotalgstinr, ptotalamtinr, pemployeeid, pdepatmentid, pcostcenterid, ptcsrate, ptcsamount,
   connstring, ppono, ppoline, flag);

    if (res_vch2.error != null) {
        alert(res_vch2.error.description);
        return false;
    }

    else {
        try {
            dsmain1 = res_vch2.value;
            var hdsview = "";
            jq('#view').empty();
            hdsview += BindGridHeader();
            jq('#taxcodemaster').css("dispaly", "block");
            //count = 0;
            for (count1 = 0; count1 < dsmain1.Tables[0].Rows.length; count1++) {

                hdsview += ("<tr>")
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].SerialNo) + "' id=txtserialline_" + count1 + " ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtpoline_" + count1 + " value='" + fndnull(dsmain1.Tables[0].Rows[count1].POLine) + "' onkeydown='return bindpolinef2(event);' ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].itemname) + "' id=txtitemcode_" + count1 + "></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].billtypname) + "' id=txtbilltype_" + count1 + " ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].hsnname) + "' id=txthsnsac_" + count1 + " ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].UOM) + "' id=txtuom_" + count1 + "></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtqty_" + count1 + "    value='" + fndnull(dsmain1.Tables[0].Rows[count1].Quantity) + "' onblur='return calamtqty(this);' ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].Currency) + "' id=txtcurrency_" + count1 + " ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].ConversionFactorINR) + "' id=txtconversionfact_" + count1 + "></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  id=txtaccessbleval_" + count1 + " value='" + fndnull(dsmain1.Tables[0].Rows[count1].AssessableValue) + "'   onblur='return calamtaccess(this);' ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].IGSTRate) + "' id=txtsgstrate_" + count1 + " ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].CGSTRate) + "' id=txtcgstrate_" + count1 + "></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].SGSTRate) + "' id=txtigstrate_" + count1 + " ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].CessRate) + "' id=txtcessrate_" + count1 + "></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].SGSTAmount) + "' id=txtsgstamt_" + count1 + " ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].CGSTAmount) + "' id=txtcgstamt_" + count1 + " ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].IGSTAmount) + "' id=txtigstamt_" + count1 + "></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].CessAmount) + "' id=txtcessamt_" + count1 + "></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].TotalGST) + "' id=txttotalgst_" + count1 + "></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].TotalAmount) + "' id=txttotalamt_" + count1 + "></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].TotalGSTINR) + "' id=txttotalgstinr_" + count1 + "></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].TotalAmountINR) + "' id=txttotalamtinr_" + count1 + "></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].emp_name) + "' id=txtemployee_" + count1 + "></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].depart_nm) + "' id=txtdepartment_" + count1 + "></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].cost_nm) + "' id=txtcostcenter_" + count1 + "></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].TCSRate) + "' id=txttcsrate_" + count1 + "></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].TCSAmount) + "' id=txttcsamt_" + count1 + "></td>"
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].POLine) + "'   id=hdnpolinegrid_" + count1 + "   disabled></td>";
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].orderno) + "'   id=hdnponogrid_" + count1 + "   disabled></td>";
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].ItemDescription) + "'   id=hdnitemcdgrid_" + count1 + "   disabled></td>";
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].BillType) + "'   id=hdnbilltypecdgrid_" + count1 + "   disabled></td>";
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].HSNSACCode) + "'   id=hdnhsnsaccdgrid_" + count1 + "   disabled></td>";

                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].EmployeeID) + "'   id=hdnemployeegrid_" + count1 + "   disabled></td>";
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].DepartmentID) + "'   id=hdndepartmentgrid_" + count1 + "   disabled></td>";
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].CostCenterID) + "'   id=hdncostcentergrid_" + count1 + "   disabled></td>";
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].Quantity) + "'   id=hdnquantitygrid_" + count1 + "   disabled></td>";
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].AssessableValue) + "'   id=hdnaccessvaluegrid_" + count1 + "   disabled></td>";

                hdsview += ("</tr>")

            }
            execount = count1;
            hdsview += ("</table>")
            document.getElementById('divpogrid').innerHTML = hdsview;
            EnableGrid();
            jq('#divpogrid').css("display", "block");
        }
        catch (ex) {
            alert('An error has occurred: ' + ex.message);
        }
    }
    return false;
}

function clearclick1() {
    jq('#txtirnno,#txtpurtype,#txttrantype,#txtshiptostate,#txtpo,#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbillno,#txtbilldate,#txtbillremark,#txtbilltotamt,#txtadviceno,#txtemployeeid,#txtcrtdby,#txtcrtdon').prop("disabled", false);
    jq('#txtirnno,#txtirnno,#txtpurtype,#txttrantype,#txtshiptostate,#txtpo,#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbillno,#txtbilldate,#txtbillremark,#txtbilltotamt,#txtadviceno,#txtemployeeid').val('');

    jq("#txtirnno,#txtpurtype,#txttrantype,#txtshiptostate,#txtpo,#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbillno,#txtbilldate,#txtbillremark,#txtbilltotamt,#txtadviceno,#txtemployeeid").css("background-color", "#C0C0C0");
    jq('#btnSave,#btnModify,#btnExecute,#btnfirst,#btnprevious,#btnnext,#btnlast,#txtpodat,#txtrevision,#txtgstin').prop("disabled", true);
    jq('#btnNew,#btnQuery').prop("disabled", false);
    jq('#btnNew,#btnCancel,#btnExit').focus();
    //bindgriddetail();
    document.getElementById('divpogrid').innerHTML = "";
    bindgriddetail();
    setButtonImages();
    return false;
}

function getrdncheck(rdn) {

    var res_vch12 = "";
    try {
        var PPONo = "";
        var TranTypeID = "";
        var SupplierName = "";
        var BillNumber = "";
        var BillDate = "";
        var CreatedBy = "";
        var TotalBillAmount = "";
        var AdviceNo = "";
        var IsgecGSTIN = "";
        var CreatedOn = "";
        var EmployeeID = "";
        var IRReceivedOn = "";
        var BillRemarks = "";
        var PurchaseType = "";
        var UploadBatchNo = "";
        var CostCenterID = "";
        var SupplierGSTIN = "";
        var SupplierGSTINNumber = "";
        var ShipToState = "";
        var BPID = "";
        var DepartmentID = "";
        var ElementID = "";
        var ProjectID = "";
        var irno = rdn;
        var flag = "E";
        var pextra1 = "";
        var pextra2 = "";
        var pextra3 = "";
        var pextra4 = "";
        var pextra5 = "";
        var connstring = document.getElementById("hdnconnectionstring").value;
        var res_vch2 = Supplier_BillEntry.hdr_save(PPONo, TranTypeID, SupplierName, BillNumber, BillDate, CreatedBy, TotalBillAmount, AdviceNo, IsgecGSTIN,
        CreatedOn, EmployeeID, IRReceivedOn, BillRemarks, PurchaseType, UploadBatchNo, CostCenterID, SupplierGSTIN, SupplierGSTINNumber,
        ShipToState, BPID, DepartmentID, ElementID, ProjectID, irno, flag, pextra1, pextra2, pextra3, pextra4, pextra5, connstring);

    }
    catch (e) {
        alert('An error has occurred: ' + e.message);
    }

    if (res_vch2.error != null) {
        alert(res_vch2.error.description);
        return false;
    }
    else {
        exec_data = res_vch2.value;
        if (exec_data.Tables[0].Rows.length == 0) {
            alert('There is no data accourding your search');
            clearclick();
            return false;
        }
        else {
            next = 0;
            record_show = 5
            record_show1 = 1
            exec_data = res_vch2.value;
            total_records = exec_data.Tables[0].Rows.length;
            jq('#btnNew,#btnSave,#btnExecute').prop("disabled", true);
            jq('#btnCancel,#btnExit,#btnlast,#btnModify,#btnfirst,#btnDelete,#btnprevious,#btnnext,#btnDelete').prop("disabled", false);
            jq('#txtirnno,#txtpurtype,#txttrantype,#txtshiptostate,#txtpo,#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbillno,#txtbilldate,#txtbillremark,#txtbilltotamt,#txtadviceno,#txtemployeeid,#txtcrtdby,#txtcrtdon').prop("disabled", false);
            jq("#txtirnno,#txtpurtype,#txttrantype,#txtshiptostate,#txtpo,#txtsupname,#txtsupcode,#txtgstin,#txtisgecgstin,#txtbillno,#txtbilldate,#txtbillremark,#txtbilltotamt,#txtadviceno,#txtemployeeid").css("background-color", "#C0C0C0");
            executehdr();
            setButtonImages();

            return false;
        }

    }
    return false;
}