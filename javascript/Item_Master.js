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
var count = 0;
var execount = 0;
//var count5;
var count6;
var count7;
var modifyflag = "";
var count8;
var rowtotal = 0;
var rowbalance = 0;
var dsmain1 = "";
var comp_code = "", unit = "", doctype = "", rcptno = "", rcptdate = "", chqdt = "", chqno = "", agcode = "", agmaincode = "", agsubcode = "", agname = "", totalamt = "", tag = "", untag = "", paymentmode = "", manrcptno = "", rcvdfrom = "";


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




function EnabledOnNew() {
    jq('#hdnflag').val('new');
    jq('#hdnstatusflag').val('N');
    jq('#txtitemuom,#txtitemname').prop("disabled", false);
    jq('#txtitemuom,#txtitemname,#txtitemcode,#hdnuomcode').val('');
    jq('#btnModify,#btnQuery,#btnExecute,#btnfirst,#btnprevious,#btnnext,#btnlast,#btnNew').prop("disabled", true);
    jq('#btnSave').prop("disabled", false);
    setButtonImages();
    return false;
}

function clearclick() {
    jq('#txtitemuom,#txtitemname,#txtitemcode').prop("disabled", true);
    jq('#txtitemuom,#txtitemname,#txtitemcode,#hdnuomcode').val('');
    jq('#btnSave,#btnModify,#btnExecute,#btnfirst,#btnprevious,#btnnext,#btnlast,#btnDelete').prop("disabled", true);
    jq('#btnNew,#btnQuery').prop("disabled", false);
    //jq('#btnNew,#btnCancel,#btnExit').focus();
    viewalltaxtype();
    setButtonImages();
    return false;
}


function EnabledOnQuery() {
    jq('#hdnflag').val('modify');
    jq('#txtitemuom,#txtitemname,#txtitemcode').prop("disabled", false);
    jq('#txtitemuom,#txtitemname,#txtitemcode,#hdnuomcode').val('');
    jq('#btnSave,#btnModify,#btnQuery,#btnNew,#btnfirst,#btnprevious,#btnnext,#btnlast').prop("disabled", true);
    jq('#btnExecute,#btnCancel,#btnExit').prop("disabled", false);
    document.getElementById("btnExecute").focus();
    setButtonImages();
    return false;
}

function OnClickModify() {
    modifyflag = "U";
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

    jq('#txtitemuom,#txtitemname').prop("disabled", false);
    return false;
}

function onsaveclick() {

    try {
        if (modifyflag == "U") {
            save_data(modifyflag);
        }
        else {
            save_data();
        }
    }
    catch (ex) {
        alert(ex);
    }
}
function EnableExecute() {
    var res_vch12 = "";
    try {
       
        var txtuomcode = jq('#hdnuomcode').val();
        var PItemCode = jq('#txtitemcode').val();
        var Pdescriptions = jq('#txtitemname').val();
        var flag = 'E'
        var exra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
        var connstring = document.getElementById("hdnconnectionstring").value;
       
        res_vch12 = Item_Master.hdr_save(txtuomcode, PItemCode,Pdescriptions, flag, exra1, extra2, extra3, extra4, extra5, connstring);

    }
    catch (e) {
        alert('An error has occurred: ' + e.message);
    }

    if (res_vch12.error != null) {
        alert(res.error.description);
        return false;
    }
    else {
        exec_data = res_vch12.value;
        if (exec_data.Tables[0].Rows.length == 0) {
            alert('There is no data accourding your search');
            clearclick();
            return false;
        }
        else {
            next = 0;
            record_show = 5
            record_show1 = 1
            exec_data = res_vch12.value;
            total_records = exec_data.Tables[0].Rows.length;
            jq('#btnNew,#btnSave,#btnExecute').prop("disabled", true);
            jq('#btnCancel,#btnExit,#btnlast,#btnModify,#btnfirst,#btnDelete,#btnprevious,#btnnext,#btnDelete').prop("disabled", false);
            
            jq('#txtitemuom,#txtitemname,#txtitemcode').prop("disabled", true);
            executehdr();
            setButtonImages();

            return false;
        }

    }
    return false;
}

function executehdr() {

    if (exec_data.Tables[0].Rows[next].ITEMCode != null || exec_data.Tables[0].Rows[next].ITEMCode != "" || exec_data.Tables[0].Rows[next].ITEMCode != "null") {
        document.getElementById("txtitemcode").value = fndnull(exec_data.Tables[0].Rows[next].ITEMCode);
        document.getElementById("txtitemname").value = fndnull(exec_data.Tables[0].Rows[next].DESCRIPTION);
        document.getElementById("hdnuomcode").value = fndnull(exec_data.Tables[0].Rows[next].UNIT);
        document.getElementById("txtitemuom").value = fndnull(exec_data.Tables[0].Rows[next].uom_name);
    }
    document.getElementById("btnModify").disabled = false;
    setButtonImages();
    return false;
}

var count1 = 0;

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

    if (document.getElementById('btnDelete').disabled == true)
        document.getElementById('btnDelete').src = "btimages/delete-off.jpg";
    else
        document.getElementById('btnDelete').src = "btimages/delete.jpg";

    if (document.getElementById('btnExit').disabled == true)
        document.getElementById('btnExit').src = "btimages/exit-off.jpg";
    else
        document.getElementById('btnExit').src = "btimages/exit.jpg";
}

function delete_data() {
    if (confirm("Do You Want To Delete This Record")) {
        try {
            var res_vch12 = "";
            var txtuomcode = jq('#hdnuomcode').val();
            var PItemCode = jq('#txtitemcode').val();
            var Pdescriptions = jq('#txtitemname').val();
            var flag = 'D'
            var exra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
            var connstring = document.getElementById("hdnconnectionstring").value;

            res_vch12 = Item_Master.hdr_save(txtuomcode, PItemCode, Pdescriptions, flag, exra1, extra2, extra3, extra4, extra5, connstring);


            if (res_vch12.error != null) {
                alert(res_vch12.error.description);
                return false;
            }
            else {
                    alert(res_vch12.value.Tables[0].Rows[0].MSG);
                    clearclick();
                    return false;
            }

            return false;
        }
        catch (ex) {
            alert(ex);
            return false;
        }
    }
    else {
        return false;
    }
}

function Exit() {
    if (confirm("Do You Want To Skip This Page")) {
        window.close();
        return false;
    }
    return false;
}

var count = 0;
var dsmain12 = "";
function save_data(modifyflag) {
    if (modifyflag == "U") { }
    else {
        if (jq('#txttaxtypcd').val() == "") {
            alert("please select the tax type code")
            document.getElementById("txttaxtypcd").focus();
            return false;
        }
    }
    var modi = modifyflag;
    var txtuomcode = jq('#hdnuomcode').val();
    var PItemCode = jq('#txtitemcode').val();
    var Pdescriptions = jq('#txtitemname').val();
    if (modi == "U") {
        var flag = 'U'
    }
    else {
        var flag = 'I'
    }
    var exra1 = "";
    var extra2 = "", extra3 = "", extra4 = "", extra5 = "";
    var connstring = document.getElementById("hdnconnectionstring").value;
    var res_vch1 = Item_Master.hdr_save(txtuomcode, PItemCode, Pdescriptions, flag, exra1, extra2, extra3, extra4, extra5, connstring);
    var dsmain12 = res_vch1.value;
    if (res_vch1.error != null) {
        alert(res_vch1.error.description);
        return false;
    }
    else {
        alert(res_vch1.value.Tables[0].Rows[0].MSG);
            clearclick();
            if (document.getElementById('btnSave').disabled == true)
                document.getElementById('btnSave').src = "btimages/save.jpg";
            else
                document.getElementById('btnSave').src = "btimages/save-off.jpg";
            document.getElementById('btnSave').disabled = true;
    }
    return false;
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


function viewalltaxtype() {
    var res_vch12 = "";
    try {
        var txtuomcode = jq('#hdnuomcode').val();
        var PItemCode = jq('#txtitemcode').val();
        var Pdescriptions = jq('#txtitemname').val();
        var flag = 'E'
        var exra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
        var connstring = document.getElementById("hdnconnectionstring").value;

        res_vch12 = Item_Master.hdr_save(txtuomcode, PItemCode, Pdescriptions, flag, exra1, extra2, extra3, extra4, extra5, connstring);


    }
    catch (e) {
        alert('An error has occurred: ' + e.message);
    }

    if (res_vch12.error != null) {
        alert(res.error.description);
        return false;
    }
    else {
        exec_data = res_vch12.value;
        if (exec_data.Tables[0].Rows.length == 0) {
            //alert('There is no data accourding your search');
            //clearclick();
            //return false;
        }
        else {
           
            exec_data = res_vch12.value;
            total_records = exec_data.Tables[0].Rows.length;
           
            count = 0;
            var hdsview = "";
            jq('#taxitemmasterview').empty();
            hdsview += ("<table id='taxtypemaster1'  class='table table-bordered'>")
            hdsview += ("<tr style='height:20px; color: white;background-color: #5c9afb;'>")
            hdsview += ("<td class='Divpadding_left th' style='Width:10%;'>Item Code</td>")
            hdsview += ("<td class='Divpadding_left th' style='Width:50%;'>Description</td>")
            hdsview += ("<td class='Divpadding_left th' style='Width:10%;'>Uom</td>")
            hdsview += ("</tr>")
            for (var i = 0; i < exec_data.Tables[0].Rows.length; i++) {
                hdsview += ("<tr>")
                hdsview += "<td><div name='Enable' class='gridinputclass' style='text-align:left; color:blue;text-decoration: underline;' id=txtitemcd_" + i + "  onclick='javascript:return itemheadbind(this.id)'>" + fndnull(exec_data.Tables[0].Rows[i].ITEMCode) + "</div></td>"
                hdsview += "<td style='display:none;'><input  name='Disable' class='gridinputclass' style='text-align:left;' id=hiddenitemcd_" + i + " value='" + fndnull(exec_data.Tables[0].Rows[i].ITEMCode) + "'  ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclass' style='text-align:left;' id=txtitemdescription_" + i + " value='" + fndnull(exec_data.Tables[0].Rows[i].DESCRIPTION) + "'  ></td>";
                hdsview += "<td><input  name='Disable' class='gridinputclass' style='text-align:left;' id=txtuom_" + i + " value='" + fndnull(exec_data.Tables[0].Rows[i].uom_name) + "'  ></td>"
                hdsview += "<td style='display:none;'><input  name='Disable' class='gridinputclass' style='text-align:left;' id=hiddenitemcd_" + i + " value='" + fndnull(exec_data.Tables[0].Rows[i].UNIT) + "'  ></td>"
                hdsview += ("</tr>")
            }
            hdsview += ("</table>")
            document.getElementById('taxitemmasterview').innerHTML = hdsview;
            EnableGrid();
            jq('#taxitemmasterview').css("display", "block");

            return false;
        }

    }
    return false;
}


function itemheadbind(id) {

    var id1 = id.split("_")[1];
    
    document.getElementById("txtitemcode").value = document.getElementById("hiddenitemcd_" + id1).value;
    document.getElementById("txtitemname").value = document.getElementById("txtitemdescription_" + id1).value;
    document.getElementById("txtitemuom").value = document.getElementById("txtuom_" + id1).value;
    document.getElementById("hdnuomcode").value = document.getElementById("hiddenitemcd_" + id1).value;
    document.getElementById("btnModify").disabled = false;
    document.getElementById("btnDelete").disabled = false;
    setButtonImages();
    return false;
}


///bind uom by f2


function binduomcode(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var activeid = document.activeElement.id.split('_')[1];
    var id = activeid;//CurrentTextId.split('_')[1];
    CurrentTextId = document.activeElement.id;
    if (event.keyCode == 113) {
        offset(document.activeElement.id, "divuomcode", "lstuomcode");
        var connstring = document.getElementById("hdnconnectionstring").value;
        var res = Item_Master.Binduomcode(jq('#' + CurrentTextId).val(), connstring, "", "", "", "", "", connstring, BinduomcodeCallbackgrid);
        return false;
    }
    else if (keycode == 8 || keycode == 46) {
        jq('#' + CurrentTextId, "#hdnuomcode" + id).val('')
    }
    else if (keycode != 13 && keycode != 37 && keycode != 39 && keycode != 9 && keycode != 17 && event.shiftKey == false && event.ctrlKey == false && event.altKey == false) {
        jq('#' + CurrentTextId, "#hdnuomcode" + id).val('')
    }
    if (event.ctrlKey == true && keycode == 88) {
        jq('#' + CurrentTextId, "#hdnuomcode" + id).val('')
    }
}

function BinduomcodeCallbackgrid(res) {
    var ds = res.value;
    var pkgitem = document.getElementById('lstuomcode')
    pkgitem.options.length = 0;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        pkgitem.options[0] = new Option("---Select Uom Code---", "0");
        pkgitem.options.length = 1;
        for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].Description + "~" + ds.Tables[0].Rows[i].UOM, ds.Tables[0].Rows[i].Description + "~" + ds.Tables[0].Rows[i].UOM);
            pkgitem.options.length;
        }
    }
    else {
        pkgitem.options[0] = new Option("---There is no data accourding your search---", "");
        return false;
    }
    jq('#lstuomcode').focus();
    return false;
}
function filluomcode(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var id = CurrentTextId.split('_')[1];
    if (keycode == 13 || event.type == "click") {
        if (fndnull(jq('#lstuomcode').val()) == "") {
            alert("Please Select UOM NAME..!!");
            jq('#lstsuplircode').focus();
            return false;
        }
        var activeid = CurrentTextId.split('_')[1];
        var page = jq('#lstuomcode').val()
        var str = page.split("~");
        // jq('#txtsupname').val(str[0])
        jq('#txtitemuom').val(str[0])
        jq('#hdnuomcode').val(str[1])
        //  jq('#txtgstin').val(str[2])
        jq('#divuomcode').css("display", "none");
        jq('#txtitemuom').focus();
        return false;
    }
    else if (keycode == 27) {
        jq('#divuomcode').css("display", "none");
        jq('#txtitemuom').focus();
        return false;
    }
}