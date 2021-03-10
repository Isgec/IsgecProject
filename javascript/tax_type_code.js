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
function ChqbouGridClose() {
    jq("#backgroundPopup").fadeOut("normal");
    document.getElementById('Tax_Code').style.display = "none";
    return false;
}

function CommonCreateRow(tablename) {
    if (tablename == "Tax_Code1") {
        for (var xx = 0; xx < count; xx++) {

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
        if (tablename == "Tax_Code1") {
            count++;
            execount = count;
        }
        return false
    }
    return false;
}


function EnabledOnNew() {
    jq('#hdnflag').val('new');
    jq('#hdnstatusflag').val('N');
    jq('#txttaxtypcd,#txtdescription').prop("disabled", false);
    jq('#txttaxtypcd,#txtdescription').val('');
    jq('#taxcodemaster').css("dispaly", "block");
    jq('#btnModify,#btnQuery,#btnExecute,#btnfirst,#btnprevious,#btnnext,#btnlast,#btnNew').prop("disabled", true);
    jq('#btnSave').prop("disabled", false);
    bindgriddetail();
    setButtonImages();
    return false;
}

function clearclick() {
    jq('#txttaxtypcd,#txtdescription').prop("disabled", true);
    jq('#txttaxtypcd,#txtdescription').val('');
    jq('#Tax_Code').css("dispaly", "none");
    jq('#btnSave,#btnModify,#btnExecute,#btnfirst,#btnprevious,#btnnext,#btnlast,#btnDelete').prop("disabled", true);
    jq('#btnNew,#btnQuery').prop("disabled", false);
    jq('#btnNew,#btnCancel,#btnExit').focus();
    //jq('#Tax_Code').slideUp("slow");
    jq("#view").empty();
    viewalltaxcode();
    setButtonImages();
    return false;
}


function EnabledOnQuery() {
    jq('#hdnflag').val('modify');
    jq('#txttaxtypcd,#txtdescription').prop("disabled", false);
    jq('#txttaxtypcd,#txtdescription').val('');
    jq('#btnSave,#btnModify,#btnQuery,#btnNew,#btnfirst,#btnprevious,#btnnext,#btnlast').prop("disabled", true);
    jq('#btnExecute,#btnCancel,#btnExit').prop("disabled", false);
    jq('#Tax_Code').css("dispaly", "block");
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

    jq('#txttaxtypcd,#txtdescription').prop("disabled", true);
    jq('#txtdescription').prop("disabled", false);
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
function EnableExecute() 
{
    var res_vch12="";
    try {
        var ParameterValueArray = [];
        var txttaxtypcd = "";
        var txtdescription = jq('#txtdescription').val();
        var taxcode = jq('#txttaxtypcd').val();
        var flag = 'E'
        var exra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
        var connstring = document.getElementById("hdnconnectionstring").value;
        ParameterValueArray = [taxcode, txtdescription, txttaxtypcd, flag, exra1, extra2, extra3, extra4, extra5];
        res_vch12 = Tax_Code.hdr_save(taxcode, txtdescription, txttaxtypcd, flag, exra1, extra2, extra3, extra4, extra5,connstring);

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
            jq('#txttaxtypcd,#txtdescription').prop("disabled", true);
            executehdr();
            setButtonImages();

            return false;
        }

    }
    return false;
}

function executehdr(val) {

    if (exec_data.Tables[0].Rows[next].TaxCode != null || exec_data.Tables[0].Rows[next].TaxCode != "" || exec_data.Tables[0].Rows[next].TaxCode != "null") {
        document.getElementById("txttaxtypcd").value = fndnull(exec_data.Tables[0].Rows[next].TaxCode);
        document.getElementById("txtdescription").value = fndnull(exec_data.Tables[0].Rows[next].descriptions);


        BindBudgetAccountDetail1(exec_data.Tables[0].Rows[next].TaxCode);
    }
    document.getElementById("btnModify").disabled = false;
    setButtonImages();
    return false;
}

var count1 = 0;
function BindBudgetAccountDetail1(typecd) {
    var txttaxtypcd = "";
    var txtdescription = jq('#txtdescription').val();
    var taxcode = typecd;//jq('#txttaxtypcd').val();
    var flag = 'E'
    var exra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
    var connstring = document.getElementById("hdnconnectionstring").value;
    var res_vch2 = Tax_Code.hdr_save(taxcode, txtdescription, txttaxtypcd, flag, exra1, extra2, extra3, extra4, extra5,connstring);
   
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
                hdsview += "<td><input  name='Disable' class='gridinputclass' style='text-align:left;' id=taxtypecd_" + count1 + " value='" + fndnull(dsmain1.Tables[0].Rows[count1].TaxTypeCode) + "' onkeydown='return bindtaxtypecodef2(event);' ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclass' style='text-align:left;'  value='" + fndnull(dsmain1.Tables[0].Rows[count1].TaxTypedesc) + "'   id=txttaxtypdesc_" + count1 + "></td>"
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].TaxTypeCode) + "'   id=hdntaxtyocdcdgrid_" + count1 + "   disabled></td>";
                hdsview += ("</tr>")

            }
            execount = count1;
            hdsview += ("</table>")
            document.getElementById('view').innerHTML = hdsview;
            EnableGrid();
            jq('#view').css("display", "block");
        }
        catch (ex) {
            alert('An error has occurred: ' + ex.message);
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
            var txttaxtypcd = "";
            var txtdescription = jq('#txtdescription').val();
            var taxcode = jq('#txttaxtypcd').val();
            var flag = 'D'
            var exra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
            var connstring = document.getElementById("hdnconnectionstring").value;
            ParameterValueArray = [taxcode, txtdescription, txttaxtypcd, flag, exra1, extra2, extra3, extra4, extra5];
            res_vch2 = Tax_Code.hdr_save(taxcode, txtdescription, txttaxtypcd, flag, exra1, extra2, extra3, extra4, extra5,connstring);

            if (res_vch2.error != null) {
                alert(res_vch2.error.description);
                return false;
            }
            else {
                
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
        if (jq('#txttaxtypcd').val() == "") {
            alert("please select the tax code")
            document.getElementById("txttaxtypcd").focus();
            return false;
        }
    }
    var modi = modifyflag;
    var ParameterValueArray = [];
    var txttaxtypcd = "";
    var txtdescription = jq('#txtdescription').val();
    var taxcode = jq('#txttaxtypcd').val();
    if (modi == "U") {
        var flag = 'U'
    }
    else {
        var flag = 'I'
    }
    var exra1 ="";
    var extra2 = "", extra3 = "", extra4 = "", extra5 = "";
        var res_vch2 = "";
        for (var i = 0  ; i < execount ; i++) {

            txttaxtypcd = jq('#taxtypecd_' + i).val();
            var connstring = document.getElementById("hdnconnectionstring").value;
            ParameterValueArray = [taxcode, txtdescription, txttaxtypcd, flag, exra1, extra2, extra3, extra4, extra5];
            res_vch2 = Tax_Code.hdr_save(taxcode, txtdescription, txttaxtypcd, flag, exra1, extra2, extra3, extra4, extra5,connstring);

        }

        if (res_vch2.error != null) {
            alert(res_vch2.error.description);
            return false;
        }
        else {
            // if (res_vch2.value.Tables[0].Rows[0].MSEG == "true") {
            alert("Data Save Successfully...");
            clearclick();
            if (document.getElementById('btnSave').disabled == true)
                document.getElementById('btnSave').src = "btimages/save.jpg";
            else
                document.getElementById('btnSave').src = "btimages/save-off.jpg";
            document.getElementById('btnSave').disabled = true;
            //}
        }
    


    return false;
}


function bindgriddetail() {
    try {

        jq('#Tax_Code').css("dispaly", "block");
        count = 0;
        var hdsview = "";
        jq('#view').empty();
        hdsview += BindGridHeader();
        hdsview += ("<tr>")
        hdsview += "<td><input  name='Enable' class='gridinputclass' style='text-align:left;' id=taxtypecd_" + count + " value='' onkeydown='return bindtaxtypecodef2(event);' ></td>"
        hdsview += "<td><input  name='Enable' class='gridinputclass' style='text-align:left;'  value=''   id=txttaxtypdesc_" + count + "></td>"
        hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdntaxtyocdcdgrid_" + count + "   disabled></td>";
        hdsview += ("</tr>")
        count++;
        execount = count;
        hdsview += ("</table>")
        document.getElementById('view').innerHTML = hdsview;
        EnableGrid();
        jq('#view').css("display", "block");
        //CalculateAmounts();
    }
    catch (Ex) {
        alert(Ex);
        return false;
    }
    return false;
}

function BindGridHeader() {
    var hdsview = "";
    hdsview += ("<table id='Tax_Code1'  class='table table-bordered' width ='100%'>")
    hdsview += ("<tr style='height:20px; color: white;background-color: #5c9afb;'>")
    hdsview += ("<td class='Divpadding_left th' style='Width:50%;'>Tax Type Code</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:50%;'>Description</td>")
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




function bindtaxtypecodef2(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var activeid = document.activeElement.id.split('_')[1];
    var id = activeid;//CurrentTextId.split('_')[1];
    if (event.keyCode == 113) {
        CurrentTextId = document.activeElement.id;
        OffSetForGrid1(document.activeElement.id, "divtaxtypcdgrid", "lsttaxtypcdgrid", "view");
        var connstring = document.getElementById("hdnconnectionstring").value;
        var res = Tax_Code.BindTaxtype(jq('#' + CurrentTextId).val().toUpperCase(), "", "", "", "", "",connstring, BindTaxtypcdCallbackgrid);
        return false;
    }
    else if (keycode == 8 || keycode == 46) {
        jq('#' + CurrentTextId, "#hdntaxtyocdcdgrid_" + id).val('')
    }
    else if (keycode != 13 && keycode != 37 && keycode != 39 && keycode != 9 && keycode != 17 && event.shiftKey == false && event.ctrlKey == false && event.altKey == false) {
        jq('#' + CurrentTextId, "#hdntaxtyocdcdgrid_" + id).val('')
    }
    if (event.ctrlKey == true && keycode == 88) {
        jq('#' + CurrentTextId, "#hdntaxtyocdcdgrid_" + id).val('')
    }
}

function BindTaxtypcdCallbackgrid(res) {
    var ds = res.value;
    var pkgitem = document.getElementById('lsttaxtypcdgrid')
    pkgitem.options.length = 0;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        pkgitem.options[0] = new Option("---Select Tax Type---", "0");
        pkgitem.options.length = 1;
        for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].Description + "~" + ds.Tables[0].Rows[i].TaxTypeCode, ds.Tables[0].Rows[i].Description + "~" + ds.Tables[0].Rows[i].TaxTypeCode);
            pkgitem.options.length;
        }
    }
    else {
        pkgitem.options[0] = new Option("---There is no data accourding your search---", "");
        return false;
    }
    jq('#lsttaxtypcdgrid').focus();
    return false;
}
function filltaxtypecode(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var id = CurrentTextId.split('_')[1];
    if (keycode == 13 || event.type == "click") {
        if (fndnull(jq('#lsttaxtypcdgrid').val()) == "") {
            alert("Please Select Unit Name..!!");
            jq('#lsttaxtypcdgrid').focus();
            return false;
        }
        var activeid = CurrentTextId.split('_')[1];
        var page = jq('#lsttaxtypcdgrid').val()
        var str = page.split("~");
        jq('#taxtypecd_' + id).val(str[1])
        jq('#hdntaxtyocdcdgrid_' + id).val(str[1])
        jq('#txttaxtypdesc_' + id).val(str[0])
        jq('#divtaxtypcdgrid').css("display", "none");
        jq('#taxtypecd_' + id).focus();
        return false;
    }
    else if (keycode == 27) {
        jq('#divtaxtypcdgrid').css("display", "none");
        jq('#taxtypecd_' + id).focus();
        return false;
    }
}




function viewalltaxcode() {
    var res_vch12 = "";
    try {
        var ParameterValueArray = [];
        var txttaxtypcd ="";
        var txtdescription = jq('#txtdescription').val();
        var taxcode = jq('#txttaxtypcd').val();
        var flag = 'E'
        var exra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
        var connstring = document.getElementById("hdnconnectionstring").value;
        ParameterValueArray = [taxcode, txtdescription, txttaxtypcd, flag, exra1, extra2, extra3, extra4, extra5];
        res_vch12 = Tax_Code.hdr_save(taxcode, txtdescription, txttaxtypcd, flag, exra1, extra2, extra3, extra4, extra5,connstring);

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
            // clearclick();
            jq('#taxcodeview').css("display", "none");
            return false;
        }
        else {

            exec_data = res_vch12.value;
            total_records = exec_data.Tables[0].Rows.length;

            jq('#taxcodeview').css("dispaly", "block");
            count = 0;
            var hdsview = "";
            jq('#taxcodeview').empty();
            hdsview += ("<table id='taxtypemaster1'  class='table table-bordered'>")
            hdsview += ("<tr style='height:20px; color: white;background-color: #5c9afb;'>")
            hdsview += ("<td class='Divpadding_left th' style='Width:10%;'>Tax Code</td>")
            hdsview += ("<td class='Divpadding_left th' style='Width:50%;'>Description</td>")
            hdsview += ("<td class='Divpadding_left th' style='Width:10%;'>Tax Type Code</td>")
            hdsview += ("</tr>")
            for (var i = 0; i < exec_data.Tables[0].Rows.length; i++) {
                hdsview += ("<tr>")
                hdsview += "<td><div name='Enable' class='gridinputclass' style='text-align:left; color:blue;text-decoration: underline;' id=txttaxcd_" + i + "  onclick='javascript:return taxcodebind(this.id)'>" + fndnull(exec_data.Tables[0].Rows[i].TaxCode) + "</div></td>"
                hdsview += "<td style='display:none;'><input  name='Disable' class='gridinputclass' style='text-align:left;' id=hiddentaxcd_" + i + " value='" + fndnull(exec_data.Tables[0].Rows[i].TaxCode) + "'  ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclass' style='text-align:left;' id=txttaxtypdescription_" + i + " value='" + fndnull(exec_data.Tables[0].Rows[i].descriptions) + "'  ></td>";
                hdsview += "<td><input  name='Disable' class='gridinputclass' style='text-align:left;' id=txttaxtypcd_" + i + " value='" + fndnull(exec_data.Tables[0].Rows[i].TaxTypeCode) + "'  ></td>"
                hdsview += ("</tr>")
            }
            hdsview += ("</table>")
            document.getElementById('taxcodeview').innerHTML = hdsview;
            EnableGrid();
            jq('#taxcodeview').css("display", "block");

            return false;
        }

    }
    return false;
}


function taxcodebind(id) {

    var id1 = id.split("_")[1];

    document.getElementById("txttaxtypcd").value = document.getElementById("hiddentaxcd_" + id1).value;
    document.getElementById("txtdescription").value = document.getElementById("txttaxtypdescription_" + id1).value;
    //document.getElementById("drpdownn").value = document.getElementById("txttaxtycat_" + id1).value;
    BindBudgetAccountDetail1(document.getElementById("txttaxtypcd").value);
    document.getElementById("btnModify").disabled = false;
    document.getElementById("btnDelete").disabled = false;
    setButtonImages();
    return false;
}