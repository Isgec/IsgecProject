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
    document.getElementById('taxtypemaster').style.display = "none";
    return false;
}

function CommonCreateRow(tablename) {
    if (tablename == "taxtypemaster1") {
        for (var xx = 0; xx < count; xx++) {
            
        }
    }
    //fndnull(jq('#hdnunitcd').val()) + "'   id=hdnunitcdgrid_" + count + "   disabled></td>";
    //hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;font-family:Trebuchet MS;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value='" + fndnull(jq('#hdnbrancd').val()) + "'   id=hdnbranchcdgrid
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
        if (tablename == "taxtypemaster1") {
            count++;
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
    jq('#taxtypemaster').css("dispaly", "block");
    jq('#btnModify,#btnQuery,#btnExecute,#btnfirst,#btnprevious,#btnnext,#btnlast,#btnNew').prop("disabled", true);
    jq('#btnSave').prop("disabled", false);
    bindgriddetail();
    setButtonImages();
    return false;
}

function clearclick() {
    jq('#txttaxtypcd,#txtdescription').prop("disabled", true);
    jq('#txttaxtypcd,#txtdescription').val('');
    jq('#taxtypemaster').css("dispaly", "none");
    jq('#btnSave,#btnModify,#btnExecute,#btnfirst,#btnprevious,#btnnext,#btnlast,#btnDelete').prop("disabled", true);
    jq('#btnNew,#btnQuery').prop("disabled", false);
    jq('#btnNew,#btnCancel,#btnExit').focus();
    //jq('#taxtypemaster').slideUp("slow");
    jq("#view").empty();
    viewalltaxtype();
    setButtonImages();
    return false;
}


function EnabledOnQuery() {
    jq('#hdnflag').val('modify');
    jq('#txttaxtypcd,#txtdescription').prop("disabled", false);
    jq('#txttaxtypcd,#txtdescription').val('');
    jq('#btnSave,#btnModify,#btnQuery,#btnNew,#btnfirst,#btnprevious,#btnnext,#btnlast').prop("disabled", true);
    jq('#btnExecute,#btnCancel,#btnExit').prop("disabled", false);
    jq('#taxtypemaster').css("dispaly", "block");
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
function EnableExecute() {
    var res_vch12 = "";
    try {
        var ParameterValueArray = [];
        var txttaxtypcd = jq('#txttaxtypcd').val().toUpperCase();
        var txtdescription = jq('#txtdescription').val();
        var flag = 'E'
        var exra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
        var connstring = document.getElementById("hdnconnectionstring").value;
        ParameterValueArray = [txttaxtypcd, txtdescription, flag, exra1, extra2, extra3, extra4, extra5];
         res_vch12 = TaxTypeMaster.hdr_save(txttaxtypcd, txtdescription, flag, exra1, extra2, extra3, extra4, extra5,connstring);
       
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
            //if (exec_data.Tables[0].Rows.length == 1) {
            //    jq('#btnnext').attr('disabled', true);
            //    jq('#btnlast').attr('disabled', true);
            //}
            //else if (exec_data.Tables[0].Rows.length > 1) {
            //    jq('#btnnext').attr('disabled', false);
            //    jq('#btnlast').attr('disabled', false);
            //}
            jq('#txttaxtypcd,#txtdescription').prop("disabled", true);
            executehdr();
            setButtonImages();

            return false;
        }

    }
    return false;
}

function executehdr() {
   
    if (exec_data.Tables[0].Rows[next].TaxTypeCode != null || exec_data.Tables[0].Rows[next].TaxTypeCode != "" || exec_data.Tables[0].Rows[next].TaxTypeCode != "null") {
        document.getElementById("txttaxtypcd").value = fndnull(exec_data.Tables[0].Rows[next].TaxTypeCode);
        document.getElementById("txtdescription").value = fndnull(exec_data.Tables[0].Rows[next].Description);
        document.getElementById("drpdownn").value = fndnull(exec_data.Tables[0].Rows[next].Tax_cat);

        
        BindBudgetAccountDetail1(exec_data.Tables[0].Rows[next].TaxTypeCode);
    }
    document.getElementById("btnModify").disabled = false;
    setButtonImages();
    return false;
}

var count1 = 0;
function BindBudgetAccountDetail1(typecd) {
    var ParameterValueArray = [];
    var txttaxtypcd = typecd;
    var txtdescription ="";
    var flag = 'E'
    var exra1 = "";
    var extra2 = "", extra3 = "", extra4 = "", extra5 = "";
    var effectivedate ="";
    var rate = "";
    var connstring = document.getElementById("hdnconnectionstring").value;
    ParameterValueArray = [txttaxtypcd, txtdescription, effectivedate, rate, flag, exra1, extra2, extra3, extra4, extra5];
    var res_vch2 = TaxTypeMaster.hdr_savedet(txttaxtypcd, txtdescription, effectivedate, rate, flag, exra1, extra2, extra3, extra4, extra5,connstring);
    dsmain1 = res_vch2.value;
    if (res_vch2.error != null) {
        alert(res_vch2.error.description);
        return false;
    }  
   
    else {
        try {
            var hdsview = "";
            jq('#view').empty();
            hdsview += BindGridHeader();
            jq('#taxtypemaster').css("dispaly", "block");
            //count = 0;
            for (count1 = 0; count1 < dsmain1.Tables[0].Rows.length; count1++) {            
                
                hdsview += ("<tr>")
                hdsview += "<td><input  name='Enable' class='gridinputclass' style='text-align:left;' id=txteffectivedate_" + count1 + " value='" + fndnull(dsmain1.Tables[0].Rows[count1].EffectiveDate) + "' accept='date'  ></td>"
                hdsview += "<td><img src=\"images/cal1.gif\" id=calender_" + count1 + "  onclick=\"popUpCalendar2(this,form1.txteffectivedate_" + count1 + " ,'mm/dd/yyyy',event);\" ></td>";
                hdsview += "<td><input  name='Enable' class='gridinputclass' style='text-align:left;' value='" + fndnull(dsmain1.Tables[0].Rows[count1].Rate) + "'   id=txtrate_" + count1 + " accept='decimal' MaxLength='14'   ></td>"
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
            var ParameterValueArray = [];
            var txttaxtypcd = jq('#txttaxtypcd').val().toUpperCase();
            var txtdescription = jq('#txtdescription').val();
            var flag = 'D'
            var exra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
            var connstring = document.getElementById("hdnconnectionstring").value;
            ParameterValueArray = [txttaxtypcd, txtdescription, flag, exra1, extra2, extra3, extra4, extra5];

            var res_vch2 = "";
            for (var i = 0  ; i < execount ; i++) {

                var effectivedate = jq('#txteffectivedate_' + i).val();
                var rate = jq('#txtrate_' + i).val();
                ParameterValueArray = [txttaxtypcd, txtdescription, effectivedate, rate, flag, exra1, extra2, extra3, extra4, extra5];
                res_vch2 = TaxTypeMaster.hdr_savedet(txttaxtypcd, txtdescription, effectivedate, rate, flag, exra1, extra2, extra3, extra4, extra5,connstring);

            }

            if (res_vch2.error != null) {
                alert(res_vch2.error.description);
                return false;
            }
            else {
                // if (res_vch2.value.Tables[0].Rows[0].MSEG == "true") {
                var res_vch12 = TaxTypeMaster.hdr_save(txttaxtypcd, txtdescription, flag, exra1, extra2, extra3, extra4, extra5,connstring);

                if (res_vch12.error != null) {
                    alert(res_vch12.error.description);
                    return false;
                }
                else {
                    //alert(res_vch12.value.Tables[0].Rows[0].MSG);
                    alert("Data Delete Successfully...");
                    clearclick();
                    return false;
                }
                //}
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
    var ParameterValueArray = [];
    var txttaxtypcd = jq('#txttaxtypcd').val().toUpperCase();
    var txtdescription = jq('#txtdescription').val();
     if (modi == "U") {
            var flag = 'U'
        }
    else{
        var flag ='I'
    }
    var exra1 = jq('#drpdownn').val();
    var extra2 = "", extra3 = "", extra4 = "", extra5 = "";
    var connstring = document.getElementById("hdnconnectionstring").value;
    ParameterValueArray = [txttaxtypcd, txtdescription, flag, exra1, extra2, extra3, extra4, extra5];
    var res_vch1 = TaxTypeMaster.hdr_save(txttaxtypcd, txtdescription, flag, exra1, extra2, extra3, extra4, extra5,connstring);
    dsmain12 = res_vch1.value;
    if (res_vch1.error != null) {
        alert(res_vch1.error.description);
        return false;
    }
    else {
        var res_vch2 = "";
        for (var i = 0  ; i < execount ; i++) {

            var effectivedate = jq('#txteffectivedate_' + i).val();
            var rate = jq('#txtrate_' + i).val();
            var connstring = document.getElementById("hdnconnectionstring").value;
            ParameterValueArray = [txttaxtypcd, txtdescription, effectivedate, rate, flag, exra1, extra2, extra3, extra4, extra5];
            res_vch2 = TaxTypeMaster.hdr_savedet(txttaxtypcd, txtdescription, effectivedate, rate, flag, exra1, extra2, extra3, extra4, extra5,connstring);
            
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
    }

        
    return false;
}


function bindgriddetail() {
    try {

        jq('#taxtypemaster').css("dispaly", "block");
        count = 0;
        var hdsview = "";
        jq('#view').empty();
        hdsview += BindGridHeader();
        hdsview += ("<tr>")
        hdsview += "<td><input  name='Enable' class='gridinputclass' style='text-align:left;' id=txteffectivedate_" + count + " value='' accept='date'  ></td>"
        hdsview += "<td><img src=\"images/cal1.gif\" id=calender_" + count + " onclick=\"popUpCalendar2(this,form1.txteffectivedate_" + count + ",'mm/dd/yyyy',event);\" ></td>";
        hdsview += "<td><input  name='Enable' class='gridinputclass' style='text-align:left;'  value=''   id=txtrate_" + count + " accept='decimal' MaxLength='14'   ></td>"
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
    hdsview += ("<table id='taxtypemaster1'  class='table table-bordered'>")
    hdsview += ("<tr style='height:20px; color: white;background-color: #5c9afb;'>")
    hdsview += ("<td class='Divpadding_left th' style='Width:50%;'>Effective Date<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:5%;'>&nbsp;</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:50%;'>Rate</td>")
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


function viewalltaxtype() {
    var res_vch12 = "";
    try {
        var ParameterValueArray = [];
        var txttaxtypcd = jq('#txttaxtypcd').val().toUpperCase();
        var txtdescription = jq('#txtdescription').val();
        var flag = 'E'
        var exra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
        var connstring = document.getElementById("hdnconnectionstring").value;
        ParameterValueArray = [txttaxtypcd, txtdescription, flag, exra1, extra2, extra3, extra4, extra5];
        res_vch12 = TaxTypeMaster.hdr_save(txttaxtypcd, txtdescription, flag, exra1, extra2, extra3, extra4, extra5,connstring);

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
           
            exec_data = res_vch12.value;
            total_records = exec_data.Tables[0].Rows.length;
           
            jq('#taxtypemaster').css("dispaly", "block");
            count = 0;
            var hdsview = "";
            jq('#taxtypemasterview').empty();
            hdsview += ("<table id='taxtypemaster1'  class='table table-bordered'>")
            hdsview += ("<tr style='height:20px; color: white;background-color: #5c9afb;'>")
            hdsview += ("<td class='Divpadding_left th' style='Width:10%;'>Tax Type Code</td>")
            hdsview += ("<td class='Divpadding_left th' style='Width:50%;'>Description</td>")
            hdsview += ("<td class='Divpadding_left th' style='Width:10%;'>Cateogry</td>")
            hdsview += ("</tr>")
            for (var i = 0; i < exec_data.Tables[0].Rows.length; i++) {
                hdsview += ("<tr>")
                hdsview += "<td><div name='Enable' class='gridinputclass' style='text-align:left; color:blue;text-decoration: underline;' id=txttaxtypcd_" + i + "  onclick='javascript:return taxtypbind(this.id)'>" + fndnull(exec_data.Tables[0].Rows[i].TaxTypeCode) + "</div></td>"
                hdsview += "<td style='display:none;'><input  name='Disable' class='gridinputclass' style='text-align:left;' id=hiddentaxtypcd_" + i + " value='"+fndnull(exec_data.Tables[0].Rows[i].TaxTypeCode)+"'  ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclass' style='text-align:left;' id=txttaxtypdescription_" + i + " value='" + fndnull(exec_data.Tables[0].Rows[i].Description) + "'  ></td>";
                hdsview += "<td><input  name='Disable' class='gridinputclass' style='text-align:left;' id=txttaxtycat_" + i + " value='" + fndnull(exec_data.Tables[0].Rows[i].Tax_cat) + "'  ></td>"
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
    
    document.getElementById("txttaxtypcd").value = document.getElementById("hiddentaxtypcd_"+id1).value;
    document.getElementById("txtdescription").value = document.getElementById("txttaxtypdescription_" + id1).value;
    document.getElementById("drpdownn").value = document.getElementById("txttaxtycat_" + id1).value;
    BindBudgetAccountDetail1(document.getElementById("txttaxtypcd").value);
    document.getElementById("btnModify").disabled = false;
    document.getElementById("btnDelete").disabled = false;
    setButtonImages();
    return false;
}
