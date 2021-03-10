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
    jq('#txtaprovaltype,#txtaprovalcode,#txtlimit').prop("disabled", false);
    jq('#txtlimit').val('');
    jq('#btnModify,#btnQuery,#btnExecute,#btnfirst,#btnprevious,#btnnext,#btnlast,#btnNew').prop("disabled", true);
    jq('#btnSave').prop("disabled", false);
    setButtonImages();
    return false;
}

function clearclick() {
    jq('#txtaprovaltype,#txtaprovalcode,#txtlimit').prop("disabled", true);
    jq('#txtlimit').val('');
    jq('#btnSave,#btnModify,#btnExecute,#btnfirst,#btnprevious,#btnnext,#btnlast,#btnDelete').prop("disabled", true);
    jq('#btnNew,#btnQuery').prop("disabled", false);
    jq('#btnNew,#btnCancel,#btnExit').focus();
    viewalltaxtype();
    setButtonImages();
    return false;
}


function EnabledOnQuery() {
    jq('#hdnflag').val('modify');
    jq('#txtaprovaltype,#txtaprovalcode,#txtlimit').prop("disabled", false);
    jq('#txtlimit').val('');
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

    jq('#txtaprovaltype,#txtaprovalcode,#txtlimit').prop("disabled", true);
    jq('#txtaprovaltype,#txtlimit').prop("disabled", false);
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
        var ParameterValueArray = [];
        var txtaprovaltype = jq('#txtaprovaltype').val();
        var txtaprovalcode = jq('#txtaprovalcode').val();
        var txtlimit = jq('#txtlimit').val();
        var flag = 'E'
        var exra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
        var connstring = document.getElementById("hdnconnectionstring").value;
        ParameterValueArray = [txtaprovaltype, txtaprovalcode, txtlimit,flag, exra1, extra2, extra3, extra4, extra5];
        res_vch12 = Approval_type_master.hdr_save(txtaprovaltype, txtaprovalcode, txtlimit, flag, exra1, extra2, extra3, extra4, extra5,connstring);

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
            jq('#txtaprovaltype,#txtaprovalcode,#txtlimit').prop("disabled", true);
            executehdr();
            setButtonImages();

            return false;
        }

    }
    return false;
}

function executehdr() {

    if (exec_data.Tables[0].Rows[next].ApprovalEmployeCode != null || exec_data.Tables[0].Rows[next].ApprovalEmployeCode != "" || exec_data.Tables[0].Rows[next].ApprovalEmployeCode != "null") {
        document.getElementById("txtaprovalcode").value = fndnull(exec_data.Tables[0].Rows[next].ApprovalEmployeCode);
        document.getElementById("txtaprovaltype").value = fndnull(exec_data.Tables[0].Rows[next].ApprovalType);
        document.getElementById("txtlimit").value = fndnull(exec_data.Tables[0].Rows[next].ApprovalLimit);
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
            var res_vch2 = "";
            var ParameterValueArray = [];
            var txtaprovaltype = jq('#txtaprovaltype').val();
            var txtaprovalcode = jq('#txtaprovalcode').val();
            var txtlimit = jq('#txtlimit').val();
            var flag = 'D'
            var exra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
            var connstring = document.getElementById("hdnconnectionstring").value;
            ParameterValueArray = [txtaprovaltype, txtaprovalcode, txtlimit, flag, exra1, extra2, extra3, extra4, extra5];
            res_vch2 = Approval_type_master.hdr_save(txtaprovaltype, txtaprovalcode, txtlimit, flag, exra1, extra2, extra3, extra4, extra5,connstring);

            if (res_vch2.error != null) {
                alert(res_vch2.error.description);
                    return false;
                }
                else {
                    //alert(res_vch12.value.Tables[0].Rows[0].MSG);
                    alert("Data Delete Successfully...");
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
        if (jq('#txtaprovalcode').val() == "") {
            alert("please select approval employee code")
            document.getElementById("txtaprovalcode").focus();
            return false;
        }
    }
    var modi = modifyflag;
    var ParameterValueArray = [];
    var txtaprovaltype = jq('#txtaprovaltype').val();
    var txtaprovalcode = jq('#txtaprovalcode').val();
    var txtlimit = jq('#txtlimit').val();
    if (modi == "U") {
        var flag = 'U'
    }
    else {
        var flag = 'I'
    }
    var exra1 = "";
    var extra2 = "", extra3 = "", extra4 = "", extra5 = "";
    var connstring = document.getElementById("hdnconnectionstring").value;
    ParameterValueArray = [txtaprovaltype, txtaprovalcode, txtlimit, flag, exra1, extra2, extra3, extra4, extra5];
    var res_vch1 = Approval_type_master.hdr_save(txtaprovaltype, txtaprovalcode, txtlimit, flag, exra1, extra2, extra3, extra4, extra5,connstring);
    dsmain12 = res_vch1.value;
    if (res_vch1.error != null) {
        alert(res_vch1.error.description);
        return false;
    }
    else {  
            alert("Data Save Successfully...");
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
        var ParameterValueArray = [];
        var txtaprovaltype = jq('#txtaprovaltype').val();
        var txtaprovalcode = jq('#txtaprovalcode').val();
        var txtlimit = jq('#txtlimit').val();
        var flag = 'E'
        var exra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
        var connstring = document.getElementById("hdnconnectionstring").value;
        ParameterValueArray = [txtaprovaltype, txtaprovalcode, txtlimit, flag, exra1, extra2, extra3, extra4, extra5];
        res_vch12 = Approval_type_master.hdr_save(txtaprovaltype, txtaprovalcode, txtlimit, flag, exra1, extra2, extra3, extra4, extra5,connstring);

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
            return false;
        }
        else {

            exec_data = res_vch12.value;
            total_records = exec_data.Tables[0].Rows.length;

            jq('#taxtypemasterview').css("dispaly", "block");
            count = 0;
            var hdsview = "";
            jq('#taxtypemasterview').empty();
            hdsview += ("<table id='taxtypemaster1'  class='table table-bordered'>")
            hdsview += ("<tr style='height:20px; color: white;background-color: #5c9afb;'>")
            hdsview += ("<td class='Divpadding_left th' style='Width:50%;'>Approval Employee</td>")
            hdsview += ("<td class='Divpadding_left th' style='Width:10%;'>Approval Type Code</td>")
            hdsview += ("<td class='Divpadding_left th' style='Width:10%;'>Approval Limit</td>")
            hdsview += ("</tr>")
            for (var i = 0; i < exec_data.Tables[0].Rows.length; i++) {
                hdsview += ("<tr>")
                hdsview += "<td><div name='Enable' class='gridinputclass' style='text-align:left; color:blue;text-decoration: underline;' id=txtapprovalemp_" + i + "  onclick='javascript:return taxtypbind(this.id)'>" + fndnull(exec_data.Tables[0].Rows[i].ApprovalEmployeCode) + "</div></td>"
                hdsview += "<td style='display:none;'><input  name='Disable' class='gridinputclass' style='text-align:left;' id=hiddenapprovalemp_" + i + " value='" + fndnull(exec_data.Tables[0].Rows[i].ApprovalEmployeCode) + "'  ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclass' style='text-align:left;' id=txtapprovaltypcd_" + i + " value='" + fndnull(exec_data.Tables[0].Rows[i].ApprovalType) + "'  ></td>";
                hdsview += "<td><input  name='Disable' class='gridinputclass' style='text-align:left;' id=txtlimit_" + i + " value='" + fndnull(exec_data.Tables[0].Rows[i].ApprovalLimit) + "'  ></td>"
                hdsview += ("</tr>")
            }
            hdsview += ("</table>")
            document.getElementById('taxtypemasterview').innerHTML = hdsview;
            EnableGrid();
            jq('#taxtypemasterview').css("display", "block");

            return false;
        }

    }
    return false;
}


function taxtypbind(id) {

    var id1 = id.split("_")[1];

    document.getElementById("txtaprovalcode").value = document.getElementById("hiddenapprovalemp_" + id1).value;
    document.getElementById("txtaprovaltype").value = document.getElementById("txtapprovaltypcd_" + id1).value;
    document.getElementById("txtlimit").value = document.getElementById("txtlimit_" + id1).value;
    document.getElementById("btnModify").disabled = false;
    document.getElementById("btnDelete").disabled = false;
    setButtonImages();
    return false;
}
