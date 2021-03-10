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
function EnabledOnNew() {
    flag = "I";
    jq('#hdnflag').val('new');
    jq('#hdnstatusflag').val('N');
    jq('#txtsupname,#txtquationno,#txtisgecgstin,#txtaprvdt,#txtqudt,#txtpymntterm,#txtdelveryon,#txtdispacth,#txtdes,#txtinsurance,#txtconvervisonfactor,#drpcurrency,#txtgstin,#txtwarrentyrmk').prop("disabled", false);
    jq('#txtpo,#txtsupcode,#txtgstin,#txtreject,#txtstatus,#txtquationno,#txtqudt,#txtaprvdt,#txtpymntterm,#txtdelveryon,#txtsentaprv,#txtdispacth,#txtaprvon,#txtdes,#txtaprovedby,#txtinsurance,#txtaprovedon,#txtremrks,#txtconvervisonfactor,#txtwarrentyrmk').val('');
    jq('#btnModify,#btnQuery,#btnExecute,#btnfirst,#btnprevious,#btnnext,#btnlast,#btnNew').prop("disabled", true);
    jq('#btnSave').prop("disabled", false);
    jq("#txtsupname,#txtquationno,#txtisgecgstin,#txtaprvdt,#txtqudt,#txtpymntterm,#txtdelveryon,#txtdispacth,#txtdes,#txtinsurance,#txtconvervisonfactor,#drpcurrency,#txtremrks,#txtgstin").css("background-color", "#FFFFFF");
    if (jq("#drpcurrency").val() == "INR") {
        jq("#txtconvervisonfactor").val("1");
        jq("#txtconvervisonfactor").css("background-color", "#C0C0C0");
    }
    bindgriddetail();
    setButtonImages();
    return false;
}

function clearclick() {
    document.getElementById('btnsentfrapproval').style.display = "none";
    document.getElementById('btnapproval').style.display = "none";
    document.getElementById('btnreject').style.display = "none";
    setButtonImages();
    if (document.getElementById("hdnpono").value != "") {
        getrdncheck(document.getElementById("hdnpono").value);
    }
    return false;
}


function EnabledOnQuery() {
    jq('#hdnflag').val('modify');
    jq('#txtpo,#txtsupcode,#txtrreason,#txtreject,#txterpno,#txtstatus,#txtquationno,#txtqudt,#txtaprvdt,#txtcrtdby,#txtpymntterm,#txtcrtdon,#txtdelveryon,#txtsentaprv,#txtdispacth,#txtaprvon,#txtdes,#txtaprovedby,#txtinsurance,#txtaprovedon,#txtremrks,#txtwarrentyrmk').prop("disabled", false);
    jq('#txtsupcode,#txtrreason,#txtgstin,#txtreject,#txtstatus,#txtquationno,#txtqudt,#txtaprvdt,#txtpymntterm,#txtdelveryon,#txtsentaprv,#txtdispacth,#txtaprvon,#txtdes,#txtaprovedby,#txtinsurance,#txtaprovedon,#txtremrks,#txtwarrentyrmk').val('');
    jq('#btnSave,#btnModify,#btnQuery,#btnNew').prop("disabled", true);
    jq('#btnExecute,#btnCancel,#btnExit,#btnfirst,#btnprevious,#btnnext,#btnlast').prop("disabled", false);

    jq("#txtpo,#txtsupname,#txtquationno,#txtisgecgstin,#txtaprvdt,#txtqudt,#txtpymntterm,#txtdelveryon,#txtdispacth,#txtdes,#txtinsurance,#txtconvervisonfactor,#drpcurrency,#txtremrks").css("background-color", "#FFFFFF");
    //jq('#taxtypemaster').css("dispaly", "block");
    document.getElementById("btnExecute").focus();
    setButtonImages();
    return false;
}

function OnClickModify() {
    flag = "U";
    jq('#BtnAddRow').attr('disabled', true);
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
    jq('#txtpo,#txtsupcode,#txtrreason,#txtpodat,#txtgstin,#txtreject,#txtrevision,#txterpno,#txtstatus,#txtisgecgstin,#txtquationno,#txtqudt,#txtaprvdt,#txtcrtdby,#txtpymntterm,#txtcrtdon,#txtdelveryon,#txtsentaprv,#txtdispacth,#txtaprvon,#txtdes,#txtaprovedby,#txtinsurance,#txtaprovedon,#txtremrks').prop("disabled", true);
    jq('#txtsupcode,#txtrreason,#txtpodat,#txtgstin,#txtreject,#txtrevision,#txterpno,#txtstatus,#txtquationno,#txtqudt,#txtaprvdt,#txtcrtdby,#txtpymntterm,#txtcrtdon,#txtdelveryon,#txtsentaprv,#txtdispacth,#txtaprvon,#txtdes,#txtaprovedby,#txtinsurance,#txtaprovedon,#txtremrks').prop("disabled", false);
    jq("#txtsupname,#txtquationno,#txtisgecgstin,#txtaprvdt,#txtqudt,#txtpymntterm,#txtdelveryon,#txtdispacth,#txtdes,#txtinsurance,#txtconvervisonfactor,#drpcurrency,#txtremrks").css("background-color", "#FFFFFF");
    for (var i = 0  ; i < execount ; i++) {
        document.getElementById("txtitemcode_" + i).disabled = false;
        document.getElementById("txtqty_" + i).disabled = false;
        document.getElementById("txtuom_" + i).disabled = false;
        document.getElementById("txtpricperunit_" + i).disabled = false;
        document.getElementById("txtaccessbleval_" + i).disabled = false;
        document.getElementById("txttaxcode_" + i).disabled = false;
    }
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

    if (document.getElementById('btnExit').disabled == true)
        document.getElementById('btnExit').src = "btimages/exit-off.jpg";
    else
        document.getElementById('btnExit').src = "btimages/exit.jpg";
}

function Exit() {
    if (confirm("Do You Want To Skip This Page")) {
        window.close();
        return false;
    }
    return false;
}


function bindgriddetail() {
    try {
        jq('#BtnAddRow').attr('disabled', true);

        count = 0;
        var hdsview = "";
        if (document.getElementById('divpogrid').innerHTML == "") {
            jq('#divpogrid').empty();
            hdsview += BindGridHeader();
            hdsview += ("<tr>")
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtpoline_" + count + " value=''></td>"
            hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left;'  value=''   id=txtitemcode_" + count + "  onkeydown='return binditemcodef2(event);' ></td>"
            hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left;' id=txtqty_" + count + " value=''></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value=''   id=txtuom_" + count + "></td>"
            hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left;' id=txtpricperunit_" + count + " value='' onblur='autocalcamt(this.id,this.value,event)'></td>"
            hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left;'  value=''   id=txtaccessbleval_" + count + " ></td>"
            hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left;' id=txttaxcode_" + count + " value=''  onkeydown='return bindtaxtypecodef2(event);' ></td>"
            hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left;' id=txtbilltype_" + count + " value=''  onkeydown='return bindbilltypecodef2(event);' ></td>"
            hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left;' id=txthsnsac_" + count + " value=''  onkeydown='return bindhsnsaccodef2(event);' ></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value=''   id=txtsgstrate_" + count + " ></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtcgstrate_" + count + " value=''></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value=''   id=txtigstrate_" + count + " ></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtcessrate_" + count + " value=''></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value=''   id=txttcsrate_" + count + "></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtsgstamt_" + count + " value=''></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value=''   id=txtcgstamt_" + count + " ></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtigstamt_" + count + " value=''></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;'  value=''   id=txtcessamt_" + count + "></td>"
            hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txttcsamt_" + count + " value=''></td>"
            hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left;' id=txtemployee_" + count + " value=''  onkeydown='return bindemployeef2(event);' ></td>"
            hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left;' id=txtdepartment_" + count + " value=''  onkeydown='return binddepartmentidf2(event);' ></td>"
            hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left;' id=txtcostcenter_" + count + " value=''  onkeydown='return bindcostcenteridf2(event);' ></td>"

            hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left;' id=txtwarrantyrmk_" + count + " value=''  onkeydown='return bindcostcenteridf2(event);' ></td>" // added on 4 march by at
            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdntaxtyocdcdgrid_" + count + "   disabled></td>";
            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdnrategrid_" + count + "   disabled></td>";
            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdnitemcdgrid_" + count + "   disabled></td>";
            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdnbilltypecdgrid_" + count + "   disabled></td>";
            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdnhsnsaccdgrid_" + count + "   disabled></td>";

            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdnemployeegrid_" + count + "   disabled></td>";
            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdndepartmentgrid_" + count + "   disabled></td>";
            hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' value=''   id=hdncostcentergrid_" + count + "   disabled></td>";

            hdsview += ("</tr>")
            count++;
            execount = count;
            hdsview += ("</table>")
            document.getElementById('divpogrid').innerHTML = hdsview;
            EnableGrid();
            jq('#divpogrid').css("display", "block");
            jq('#BtnAddRow').attr('disabled', false);
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
function autocalcamt(id, val, event) {
    var orderqty = val;
    var n = id.split('_')[1];
    var price_pr_unit = 0;
    for (var i = 0; i < execount; i++) {
        orderqty = document.getElementById("txtqty_" + i).value;
        if (document.getElementById("txtpricperunit_" + i).value != "") {
            price_pr_unit = document.getElementById("txtpricperunit_" + i).value;
        }

        document.getElementById("txtaccessbleval_" + i).value = parseFloat(orderqty) * parseFloat(price_pr_unit);
        document.getElementById("txtaccessbleval_" + i).value = parseFloat(document.getElementById("txtaccessbleval_" + i).value).toFixed(2);
    }

    return false;
}
function BindGridHeader() {
    var hdsview = "";
    hdsview += ("<table id='new_page'  class='table table-bordered'>")
    hdsview += ("<tr style='height:15px; color: white;background-color: #5c9afb; font-size:13px;'>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Line No.</td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Item Code<FONT color=red>[F2]*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Quantity<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Unit<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Price per unit<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Assessable Value<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Tax Code<FONT color=red>[F2]*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Bill Type<FONT color=red>[F2]*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>HSNSAC Code<FONT color=red>[F2]*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:5%;'>SGST rate<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>CGST rate<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>IGST rate<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>CESS rate<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>TCS rate<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>SGST Amount<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>CGST Amount<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>IGST Amount<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>CESS Amount<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>TCS Amount<FONT color=red>*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Employee ID<FONT color=red>[F2]*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Department ID<FONT color=red>[F2]*</FONT></td>")
    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>CostCenter ID<FONT color=red>[F2]*</FONT></td>")

    hdsview += ("<td class='Divpadding_left th' style='Width:3%;'>Item Remark</td>")//added by at on 4 march
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
    var ponosave = "";
    for (var i = 0  ; i < execount ; i++) {
        if (jq('#hdnitemcdgrid_' + i).val() == "") {
            alert("Please select the item name in po line");
            return false;
        }
        if (jq('#hdntaxtyocdcdgrid_' + i).val() == "") {
            alert("Please select the taxcode in po line");
            return false;
        }
        var modi = flag;
        var PPONo = document.getElementById("txtpo").value;
        var PPoDate = document.getElementById("txtpodat").value;
        var PRevisionNo = document.getElementById("txtrevision").value;
        var Pstatus = document.getElementById("txtstatus").value;
        var PQuatationNo = document.getElementById("txtquationno").value;
        var PQuotationDate = document.getElementById("txtqudt").value;
        var PBPCode = document.getElementById("txtsupcode").value;
        var PBPGSTIN = document.getElementById("hdnsuppgstin").value;
        var PERPCompany = document.getElementById("txterpno").value;
        var PIsgecGSTIN = document.getElementById("txtisgecgstin").value;
        var PPaymentTerm = document.getElementById("txtpymntterm").value;
        var PDeliveryTerm = document.getElementById("txtdelveryon").value;
        var PModeofDispatch = document.getElementById("txtdispacth").value;
        var PDestination = document.getElementById("txtdes").value;
        var PInsurance = document.getElementById("txtinsurance").value;

        var PRemarks = document.getElementById("txtremrks").value;
        var PApproverType = document.getElementById("txtaprvdt").value;
        var PCreatedby = document.getElementById("txtcrtdby").value;
        var PCreatedOn = document.getElementById("txtcrtdon").value;
        var PSentforapprovalBy = document.getElementById("txtsentaprv").value;
        var PSentforApprovalon = document.getElementById("txtaprvon").value;
        var PApprovedBy = document.getElementById("txtaprovedby").value;
        var PApprovedOn = document.getElementById("txtaprovedon").value;
        var PReasonofRevision = document.getElementById("txtrreason").value;
        var PApproval_RejectionRemarks = document.getElementById("txtreject").value;
        if (modi == "U") {
            var flag = "U";
        }
        else {
            var flag = "I";
        }
        var pextra1 = document.getElementById("txtwarrentyrmk").value; // added by at on 4 march 21
        var pextra2 = "";
        var pextra3 = "";
        var pextra4 = "";
        var pextra5 = "";
        var currency = document.getElementById("drpcurrency").value;
        var conversionfactor = document.getElementById("txtconvervisonfactor").value;
        var connstring = document.getElementById("hdnconnectionstring").value;

        //var warranty_remark = document.getElementById("hdnconnectionstring").value; // added by at on 4 march 21
        var res_vch2 = "";
        if (i == 0) {
            res_vch2 = PurchasesOrder.hdr_save(PPONo, PPoDate, PRevisionNo, Pstatus, PQuatationNo, PQuotationDate, PBPCode, PBPGSTIN, PERPCompany,
        PIsgecGSTIN, PPaymentTerm, PDeliveryTerm, PModeofDispatch, PDestination, PInsurance, PRemarks, PApproverType, PCreatedby,
        PCreatedOn, PSentforapprovalBy, PSentforApprovalon, PApprovedBy, PApprovedOn, PReasonofRevision, PApproval_RejectionRemarks,
        flag, pextra1, pextra2, pextra3, pextra4, pextra5, connstring, currency, conversionfactor);
        }
        if (res_vch2.error != null) {
            alert(res_vch2.error.description);
            return false;
        }
        else {
            var res_vch = "";


            var rivision_no = document.getElementById("txtrevision").value;
            var line_no = jq('#txtpoline_' + i).val();
            var Item_Code = jq('#hdnitemcdgrid_' + i).val();
            var Quantity = jq('#txtqty_' + i).val();
            var Unit = jq('#txtuom_' + i).val();
            currency = document.getElementById("drpcurrency").value;
            var Price_per_unit = jq('#txtpricperunit_' + i).val();
            var Assessable_Value = jq('#txtaccessbleval_' + i).val();
            var Tax_Code = jq('#hdntaxtyocdcdgrid_' + i).val();
            var SGST_rate = jq('#txtsgstrate_' + i).val();
            var CGST_rate = jq('#txtcgstrate_' + i).val();
            var IGST_rate = jq('#txtigstrate_' + i).val();
            var CESS_rate = jq('#txtcessrate_' + i).val();
            var TCS_rate = jq('#txttcsrate_' + i).val();
            var SGST_Amount = jq('#txtsgstamt_' + i).val();
            var CGST_Amount = jq('#txtcgstamt_' + i).val();
            var IGST_Amount = jq('#txtigstamt_' + i).val();
            var CESS_Amount = jq('#txtcessamt_' + i).val();
            var TCS_Amount = jq('#txttcsamt_' + i).val();
            if (modi == "U") {
                var flag = "U";
                ponosave = document.getElementById("txtpo").value;
            }
            else {
                var flag = "I";
                if (i == 0) {
                    ponosave = res_vch2.value.Tables[0].Rows[0].PO_NO;
                    document.getElementById("txtpo").value = res_vch2.value.Tables[0].Rows[0].PO_NO;
                }
            }
            var pextra1 = jq('#txtwarrantyrmk_' + i).val(); // added on 4 march by at
            var pextra2 = "";
            var pextra3 = "";
            var pextra4 = "";
            var pextra5 = "";
            var billtype = document.getElementById("hdnbilltypecdgrid_" + i).value;
            var hsnsac = document.getElementById("hdnhsnsaccdgrid_" + i).value;
            var employee = document.getElementById("hdnemployeegrid_" + i).value;
            var department = document.getElementById("hdndepartmentgrid_" + i).value;
            var costcenter = document.getElementById("hdncostcentergrid_" + i).value;

           // var warranty_rmk = document.getElementById("hdncostcentergrid_" + i).value; // added on 4 march by at

            var connstring = document.getElementById("hdnconnectionstring").value;
            res_vch = PurchasesOrder.hdr_savedet(ponosave, rivision_no, line_no, Item_Code, Quantity, Unit, currency, Price_per_unit, Assessable_Value, Tax_Code, SGST_rate, CGST_rate,
           IGST_rate, CESS_rate, TCS_rate, SGST_Amount, CGST_Amount, IGST_Amount, CESS_Amount, TCS_Amount, flag, pextra1, pextra2, pextra3, pextra4, pextra5, connstring, billtype, hsnsac, employee, department, costcenter);


        }

    }
    if (res_vch.error != null) {
        alert(res_vch.error.description);
        return false;
    }
    else {
        alert(res_vch.value.Tables[0].Rows[0].MSG)
        // clearclick();
        win = window.open('PODetailList.aspx?pono=' + "" + '&us=' + document.getElementById('hdnuserid').value + '&cm=' + document.getElementById('hdncompname').value, '', 'width=' + screen.availWidth + ',height=' + screen.availHeight + ',resizable=1,left=0,top=0,scrollbars=yes');
        return false;
    }
    return false;
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
        var res = PurchasesOrder.Bindbilltypecode(connstring, BindBillTypeCdCallbackgrid);
        return false;
    }
    else if (keycode == 8 || keycode == 46) {
        jq('#' + CurrentTextId, "#hdnbilltypecdgrid_" + id).val('')
    }
    else if (keycode != 13 && keycode != 37 && keycode != 39 && keycode != 9 && keycode != 17 && event.shiftKey == false && event.ctrlKey == false && event.altKey == false) {
        jq('#' + CurrentTextId, "#hdnbilltypecdgrid_" + id).val('')
    }
    if (event.ctrlKey == true && keycode == 88) {
        jq('#' + CurrentTextId, "#hdnbilltypecdgrid_" + id).val('')
    }
}

function BindBillTypeCdCallbackgrid(res) {
    var ds = res.value;
    var pkgitem = document.getElementById('lstbilltype')
    pkgitem.options.length = 0;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        pkgitem.options[0] = new Option("---Select Bill Type---", "0");
        pkgitem.options.length = 1;
        for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].Bill_TypeName + "~" + ds.Tables[0].Rows[i].BILL_TYPECODE, ds.Tables[0].Rows[i].Bill_TypeName + "~" + ds.Tables[0].Rows[i].BILL_TYPECODE);
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
            alert("Please Select Bill Type..!!");
            jq('#lstbilltype').focus();
            return false;
        }
        var activeid = CurrentTextId.split('_')[1];
        var page = jq('#lstbilltype').val()
        var str = page.split("~");
        jq('#txtbilltype_' + id).val(str[0])
        jq('#hdnbilltypecdgrid_' + id).val(str[1])
        jq('#divbilltype').css("display", "none");
        jq('#txtbilltype_' + id).focus();
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
        var billtype = document.getElementById("hdnbilltypecdgrid_" + id).value;
        var hsnsaccd = document.getElementById(CurrentTextId).value;
        var extra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
        var res = PurchasesOrder.Bindhsnsaccode(billtype, hsnsaccd, extra1, extra2, extra3, extra4, extra5, connstring, BindHsnCdCallbackgrid);
        return false;
    }
    else if (keycode == 8 || keycode == 46) {
        jq('#' + CurrentTextId, "#hdnhsnsaccdgrid_" + id).val('')
    }
    else if (keycode != 13 && keycode != 37 && keycode != 39 && keycode != 9 && keycode != 17 && event.shiftKey == false && event.ctrlKey == false && event.altKey == false) {
        jq('#' + CurrentTextId, "#hdnhsnsaccdgrid_" + id).val('')
    }
    if (event.ctrlKey == true && keycode == 88) {
        jq('#' + CurrentTextId, "#hdnhsnsaccdgrid_" + id).val('')
    }
}

function BindHsnCdCallbackgrid(res) {
    var ds = res.value;
    var pkgitem = document.getElementById('lsthsnsaccd')
    pkgitem.options.length = 0;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        pkgitem.options[0] = new Option("---Select HSNSAC Code---", "0");
        pkgitem.options.length = 1;
        for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].HSNSACCode + "~" + ds.Tables[0].Rows[i].Description, ds.Tables[0].Rows[i].HSNSACCode + "~" + ds.Tables[0].Rows[i].Description);
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
            alert("Please Select HSNSAC Code..!!");
            jq('#lstbilltype').focus();
            return false;
        }
        var activeid = CurrentTextId.split('_')[1];
        var page = jq('#lsthsnsaccd').val()
        var str = page.split("~");
        jq('#txthsnsac_' + id).val(str[1])
        jq('#hdnhsnsaccdgrid_' + id).val(str[0])
        jq('#divhsnsaccd').css("display", "none");
        jq('#txthsnsac_' + id).focus();
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
        var res = PurchasesOrder.Bindemployeecode(hsnsaccd, extra1, extra2, extra3, extra4, extra5, connstring, BindEmployeeCdCallbackgrid);
        return false;
    }
    else if (keycode == 8 || keycode == 46) {
        jq('#' + CurrentTextId, "#hdnemployeegrid_" + id).val('')
    }
    else if (keycode != 13 && keycode != 37 && keycode != 39 && keycode != 9 && keycode != 17 && event.shiftKey == false && event.ctrlKey == false && event.altKey == false) {
        jq('#' + CurrentTextId, "#hdnemployeegrid_" + id).val('')
    }
    if (event.ctrlKey == true && keycode == 88) {
        jq('#' + CurrentTextId, "#hdnemployeegrid_" + id).val('')
    }
}

function BindEmployeeCdCallbackgrid(res) {
    var ds = res.value;
    var pkgitem = document.getElementById('lstemployee')
    pkgitem.options.length = 0;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        pkgitem.options[0] = new Option("---Select Employee---", "0");
        pkgitem.options.length = 1;
        for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].Name + "~" + ds.Tables[0].Rows[i].CardNo, ds.Tables[0].Rows[i].Name + "~" + ds.Tables[0].Rows[i].CardNo);
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
            alert("Please Select Employee..!!");
            jq('#lstemployee').focus();
            return false;
        }
        var activeid = CurrentTextId.split('_')[1];
        var page = jq('#lstemployee').val()
        var str = page.split("~");
        jq('#txtemployee_' + id).val(str[0])
        jq('#hdnemployeegrid_' + id).val(str[1])
        jq('#divemployee').css("display", "none");
        jq('#txtemployee_' + id).focus();
        return false;
    }
    else if (keycode == 27) {
        jq('#divemployee').css("display", "none");
        jq('#lstemployee' + id).focus();
        return false;
    }
}

////Department///
function binddepartmentidf2(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var activeid = document.activeElement.id.split('_')[1];
    var id = activeid;//CurrentTextId.split('_')[1];

    CurrentTextId = document.activeElement.id;
    if (event.keyCode == 113) {
        OffSetForGrid(document.activeElement.id, "divdepartment", "lstdepartment", "view");
        var connstring = document.getElementById("hdnconnectionstring").value;
        var department = document.getElementById(CurrentTextId).value;
        var extra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
        var res = PurchasesOrder.Binddepatmentcode(department, extra1, extra2, extra3, extra4, extra5, connstring, BindDepartmentCdCallbackgrid);
        return false;
    }
    else if (keycode == 8 || keycode == 46) {
        jq('#' + CurrentTextId, "#hdndepartmentgrid_" + id).val('')
    }
    else if (keycode != 13 && keycode != 37 && keycode != 39 && keycode != 9 && keycode != 17 && event.shiftKey == false && event.ctrlKey == false && event.altKey == false) {
        jq('#' + CurrentTextId, "#hdndepartmentgrid_" + id).val('')
    }
    if (event.ctrlKey == true && keycode == 88) {
        jq('#' + CurrentTextId, "#hdndepartmentgrid_" + id).val('')
    }
}

function BindDepartmentCdCallbackgrid(res) {
    var ds = res.value;
    var pkgitem = document.getElementById('lstdepartment')
    pkgitem.options.length = 0;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        pkgitem.options[0] = new Option("---Select Deaprtment---", "0");
        pkgitem.options.length = 1;
        for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].Description + "~" + ds.Tables[0].Rows[i].DepartmentID, ds.Tables[0].Rows[i].Description + "~" + ds.Tables[0].Rows[i].DepartmentID);
            pkgitem.options.length;
        }
    }
    else {
        pkgitem.options[0] = new Option("---There is no data accourding your search---", "");
        return false;
    }
    jq('#lstdepartment').focus();
    return false;
}
function filldepartmentcode(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var id = CurrentTextId.split('_')[1];
    if (keycode == 13 || event.type == "click") {
        if (fndnull(jq('#lstdepartment').val()) == "") {
            alert("Please Select Department..!!");
            jq('#lstdepartment').focus();
            return false;
        }
        var activeid = CurrentTextId.split('_')[1];
        var page = jq('#lstdepartment').val()
        var str = page.split("~");
        jq('#txtdepartment_' + id).val(str[0])
        jq('#hdndepartmentgrid_' + id).val(str[1])
        jq('#divdepartment').css("display", "none");
        jq('#txtdepartment_' + id).focus();
        return false;
    }
    else if (keycode == 27) {
        jq('#divdepartment').css("display", "none");
        jq('#lstemployee' + id).focus();
        return false;
    }
}


////CostCenter///
function bindcostcenteridf2(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var activeid = document.activeElement.id.split('_')[1];
    var id = activeid;//CurrentTextId.split('_')[1];

    CurrentTextId = document.activeElement.id;
    if (event.keyCode == 113) {
        OffSetForGrid(document.activeElement.id, "divcostcenter", "lstcostcenter", "view");
        var connstring = document.getElementById("hdnconnectionstring").value;
        var costcenter = document.getElementById(CurrentTextId).value;
        var extra1 = "", extra2 = "", extra3 = "", extra4 = "", extra5 = "";
        var res = PurchasesOrder.Bindcostcentercode(costcenter, extra1, extra2, extra3, extra4, extra5, connstring, BindcostcenCdCallbackgrid);
        return false;
    }
    else if (keycode == 8 || keycode == 46) {
        jq('#' + CurrentTextId, "#hdncostcentergrid_" + id).val('')
    }
    else if (keycode != 13 && keycode != 37 && keycode != 39 && keycode != 9 && keycode != 17 && event.shiftKey == false && event.ctrlKey == false && event.altKey == false) {
        jq('#' + CurrentTextId, "#hdncostcentergrid_" + id).val('')
    }
    if (event.ctrlKey == true && keycode == 88) {
        jq('#' + CurrentTextId, "#hdncostcentergrid_" + id).val('')
    }
}

function BindcostcenCdCallbackgrid(res) {
    var ds = res.value;
    var pkgitem = document.getElementById('lstcostcenter')
    pkgitem.options.length = 0;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        pkgitem.options[0] = new Option("---Select Cost Center---", "0");
        pkgitem.options.length = 1;
        for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].Description + "~" + ds.Tables[0].Rows[i].CostCenterID, ds.Tables[0].Rows[i].Description + "~" + ds.Tables[0].Rows[i].CostCenterID);
            pkgitem.options.length;
        }
    }
    else {
        pkgitem.options[0] = new Option("---There is no data accourding your search---", "");
        return false;
    }
    jq('#lstcostcenter').focus();
    return false;
}
function fillcostcentercode(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var id = CurrentTextId.split('_')[1];
    if (keycode == 13 || event.type == "click") {
        if (fndnull(jq('#lstcostcenter').val()) == "") {
            alert("Please Select Cost Center..!!");
            jq('#lstcostcenter').focus();
            return false;
        }
        var activeid = CurrentTextId.split('_')[1];
        var page = jq('#lstcostcenter').val()
        var str = page.split("~");
        jq('#txtcostcenter_' + id).val(str[0])
        jq('#hdncostcentergrid_' + id).val(str[1])
        jq('#divcostcenter').css("display", "none");
        jq('#txtcostcenter_' + id).focus();
        return false;
    }
    else if (keycode == 27) {
        jq('#divcostcenter').css("display", "none");
        jq('#lstcostcenter' + id).focus();
        return false;
    }
}

function bindtaxtypecodef2(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var activeid = document.activeElement.id.split('_')[1];
    var id = activeid;//CurrentTextId.split('_')[1];
    CurrentTextId = document.activeElement.id;
    if (event.keyCode == 113) {

        OffSetForGrid(document.activeElement.id, "divtaxtypcdgrid", "lsttaxtypcdgrid", "view");
        var connstring = document.getElementById("hdnconnectionstring").value;
        var res = PurchasesOrder.BindTaxtype(jq('#' + CurrentTextId).val().toUpperCase(), "", "", "", "", "", connstring, BindTaxtypcdCallbackgrid);
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
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].TaxCode + "~" + ds.Tables[0].Rows[i].Rate + "~" + ds.Tables[0].Rows[i].Tax_cat, ds.Tables[0].Rows[i].TaxCode + "~" + ds.Tables[0].Rows[i].Rate + "~" + ds.Tables[0].Rows[i].Tax_cat);
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

        var connstring = document.getElementById("hdnconnectionstring").value;
        var res = PurchasesOrder.BindTaxratetype("", str[0], "", "", "", "", "", connstring);
        var dsrate = res.value;
        var rateamt = 0;
        for (var i = 0; i < dsrate.Tables[0].Rows.length; i++) {
            if (dsrate.Tables[0].Rows[i].Tax_cat == "CGST") {
                jq('#txttaxcode_' + id).val(dsrate.Tables[0].Rows[i].Descriptions)
                jq('#txtcgstrate_' + id).val(dsrate.Tables[0].Rows[i].Rate)
                if (jq('#txtsgstrate_' + id).val() == "0") {
                    jq('#txtsgstrate_' + id).val("0")
                    jq('#txtsgstamt_' + id).val("0")
                }
                if (jq('#txtigstrate_' + id).val() == "0") {
                    jq('#txtigstrate_' + id).val("0")
                    jq('#txtigstamt_' + id).val("0")
                }
                if (jq('#txtcessrate_' + id).val() == "0") {
                    jq('#txtcessrate_' + id).val("0")
                    jq('#txtcessamt_' + id).val("0")
                }
                if (jq('#txttcsrate_' + id).val() == "0") {
                    jq('#txttcsrate_' + id).val("0")
                    jq('#txttcsamt_' + id).val("0")
                }
                rateamt = ((parseFloat(jq('#txtaccessbleval_' + id).val()) * parseFloat(dsrate.Tables[0].Rows[i].Rate)) / 100);
                jq('#txtcgstamt_' + id).val(parseFloat(rateamt).toFixed(2))

            }
            if (dsrate.Tables[0].Rows[i].Tax_cat == "SGST") {
                jq('#txttaxcode_' + id).val(dsrate.Tables[0].Rows[i].Descriptions)
                jq('#txtsgstrate_' + id).val(dsrate.Tables[0].Rows[i].Rate)
                if (jq('#txtcgstrate_' + id).val() == "0") {
                    jq('#txtcgstrate_' + id).val("0")
                    jq('#txtcgstamt_' + id).val("0")
                }
                if (jq('#txtigstrate_' + id).val() == "0") {
                    jq('#txtigstrate_' + id).val("0")
                    jq('#txtigstamt_' + id).val("0")
                }
                if (jq('#txtcessrate_' + id).val() == "0") {
                    jq('#txtcessrate_' + id).val("0")
                    jq('#txtcessamt_' + id).val("0")
                }
                if (jq('#txttcsrate_' + id).val() == "0") {
                    jq('#txttcsrate_' + id).val("0")
                    jq('#txttcsamt_' + id).val("0")
                }
                rateamt = ((parseFloat(jq('#txtaccessbleval_' + id).val()) * parseFloat(dsrate.Tables[0].Rows[i].Rate)) / 100);
                jq('#txtsgstamt_' + id).val(parseFloat(rateamt).toFixed(2))
            }
            if (dsrate.Tables[0].Rows[i].Tax_cat == "IGST") {
                jq('#txttaxcode_' + id).val(dsrate.Tables[0].Rows[i].Descriptions)
                jq('#txtigstrate_' + id).val(dsrate.Tables[0].Rows[i].Rate)
                if (jq('#txtcgstrate_' + id).val() == "0") {
                    jq('#txtcgstrate_' + id).val("0")
                    jq('#txtcgstamt_' + id).val("0")
                }
                if (jq('#txtsgstrate_' + id).val() == "0") {
                    jq('#txtsgstrate_' + id).val("0")
                    jq('#txtsgstamt_' + id).val("0")
                }
                if (jq('#txtcessrate_' + id).val() == "0") {
                    jq('#txtcessrate_' + id).val("0")
                    jq('#txtcessamt_' + id).val("0")
                }
                if (jq('#txttcsrate_' + id).val() == "0") {
                    jq('#txttcsrate_' + id).val("0")
                    jq('#txttcsamt_' + id).val("0")
                }
                rateamt = ((parseFloat(jq('#txtaccessbleval_' + id).val()) * parseFloat(dsrate.Tables[0].Rows[i].Rate)) / 100);
                jq('#txtigstamt_' + id).val(parseFloat(rateamt).toFixed(2))
            }
            if (dsrate.Tables[0].Rows[i].Tax_cat == "CESS") {
                jq('#txttaxcode_' + id).val(dsrate.Tables[0].Rows[i].Descriptions)
                jq('#txtcessrate_' + id).val(dsrate.Tables[0].Rows[i].Rate)
                if (jq('#txtcgstrate_' + id).val() == "0") {
                    jq('#txtcgstrate_' + id).val("0")
                    jq('#txtcgstamt_' + id).val("0")
                }
                if (jq('#txtsgstrate_' + id).val() == "0") {
                    jq('#txtsgstrate_' + id).val("0")
                    jq('#txtsgstamt_' + id).val("0")
                }
                if (jq('#txtigstrate_' + id).val() == "0") {
                    jq('#txtigstrate_' + id).val("0")
                    jq('#txtigstamt_' + id).val("0")
                }
                if (jq('#txttcsrate_' + id).val() == "0") {
                    jq('#txttcsrate_' + id).val("0")
                    jq('#txttcsamt_' + id).val("0")
                }
                rateamt = ((parseFloat(jq('#txtaccessbleval_' + id).val()) * parseFloat(dsrate.Tables[0].Rows[i].Rate)) / 100);
                jq('#txtcessamt_' + id).val(parseFloat(rateamt).toFixed(2))
            }
            if (dsrate.Tables[0].Rows[i].Tax_cat == "TCS") {
                jq('#txttaxcode_' + id).val(dsrate.Tables[0].Rows[i].Descriptions)
                jq('#txttcsrate_' + id).val(dsrate.Tables[0].Rows[i].Rate)
                if (jq('#txtcgstrate_' + id).val() == "0") {
                    jq('#txtcgstrate_' + id).val("0")
                    jq('#txtcgstamt_' + id).val("0")
                }
                if (jq('#txtsgstrate_' + id).val() == "0") {
                    jq('#txtsgstrate_' + id).val("0")
                    jq('#txtsgstamt_' + id).val("0")
                }
                if (jq('#txtigstrate_' + id).val() == "0") {
                    jq('#txtigstrate_' + id).val("0")
                    jq('#txtigstamt_' + id).val("0")
                }
                if (jq('#txtcessrate_' + id).val() == "0") {
                    jq('#txtcessrate_' + id).val("0")
                    jq('#txtcessamt_' + id).val("0")
                }
                rateamt = ((parseFloat(jq('#txtaccessbleval_' + id).val()) * parseFloat(dsrate.Tables[0].Rows[i].Rate)) / 100);
                jq('#txttcsamt_' + id).val(parseFloat(rateamt).toFixed(2))
            }
        }
        jq('#hdntaxtyocdcdgrid_' + id).val(str[0]);
        jq('#divtaxtypcdgrid').css("display", "none");
        return false;
    }
    else if (keycode == 27) {
        jq('#divtaxtypcdgrid').css("display", "none");
        jq('#txttaxcode_' + id).focus();
        return false;
    }
}


function binditemcodef2(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var activeid = document.activeElement.id.split('_')[1];
    var id = activeid;//CurrentTextId.split('_')[1];

    CurrentTextId = document.activeElement.id;
    if (event.keyCode == 113) {
        OffSetForGrid(document.activeElement.id, "divitemcode", "lstitemcode", "view");
        var connstring = document.getElementById("hdnconnectionstring").value;
        var res = PurchasesOrder.Binditemcode(jq('#' + CurrentTextId).val().toUpperCase(), "", "", "", "", "", connstring, BinditemcdCallbackgrid);
        return false;
    }
    else if (keycode == 8 || keycode == 46) {
        jq('#' + CurrentTextId, "#hdnitemcdgrid_" + id).val('')
    }
    else if (keycode != 13 && keycode != 37 && keycode != 39 && keycode != 9 && keycode != 17 && event.shiftKey == false && event.ctrlKey == false && event.altKey == false) {
        jq('#' + CurrentTextId, "#hdnitemcdgrid_" + id).val('')
    }
    if (event.ctrlKey == true && keycode == 88) {
        jq('#' + CurrentTextId, "#hdnitemcdgrid_" + id).val('')
    }
}

function BinditemcdCallbackgrid(res) {
    var ds = res.value;
    var pkgitem = document.getElementById('lstitemcode')
    pkgitem.options.length = 0;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        pkgitem.options[0] = new Option("---Select Item Code---", "0");
        pkgitem.options.length = 1;
        for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].DESCRIPTION + "~" + ds.Tables[0].Rows[i].ITEMCode + "~" + ds.Tables[0].Rows[i].UNIT, ds.Tables[0].Rows[i].DESCRIPTION + "~" + ds.Tables[0].Rows[i].ITEMCode + "~" + ds.Tables[0].Rows[i].UNIT);
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
            alert("Please Select Unit Name..!!");
            jq('#lstitemcode').focus();
            return false;
        }
        var activeid = CurrentTextId.split('_')[1];
        var page = jq('#lstitemcode').val()
        var str = page.split("~");
        jq('#txtitemcode_' + id).val(str[0])
        jq('#hdnitemcdgrid_' + id).val(str[1])
        jq('#txtuom_' + id).val(str[2])
        jq('#divitemcode').css("display", "none");
        jq('#txtitemcode_' + id).focus();
        return false;
    }
    else if (keycode == 27) {
        jq('#divitemcode').css("display", "none");
        jq('#txtitemcode_' + id).focus();
        return false;
    }
}


function bindsupliercodef2(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var activeid = document.activeElement.id.split('_')[1];
    var id = activeid;//CurrentTextId.split('_')[1];
    CurrentTextId = document.activeElement.id;
    if (event.keyCode == 113) {
        offset(document.activeElement.id, "divsuplircode", "lstsuplircode");
        var connstring = document.getElementById("hdnconnectionstring").value;
        if (jq("#txtsupcode").val() == "") {
            var res = PurchasesOrder.Bindsuppcode(jq('#' + CurrentTextId).val().toUpperCase(), "", "", "", "", "", connstring, BindsupliercdCallbackgrid);
        }
        else {
            var res = PurchasesOrder.Bindsuppcode(jq('#' + CurrentTextId).val().toUpperCase(), jq("#txtsupcode").val(), "", "", "", "", connstring, BindsupliercdCallbackgrid);
        }
        return false;
    }
    else if (keycode == 8 || keycode == 46) {
        jq('#' + CurrentTextId, "#hdnsupcode" + id).val('')
    }
    else if (keycode != 13 && keycode != 37 && keycode != 39 && keycode != 9 && keycode != 17 && event.shiftKey == false && event.ctrlKey == false && event.altKey == false) {
        jq('#' + CurrentTextId, "#hdnsupcode" + id).val('')
    }
    if (event.ctrlKey == true && keycode == 88) {
        jq('#' + CurrentTextId, "#hdnsupcode" + id).val('')
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
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].NAME + "~" + ds.Tables[0].Rows[i].BPCode + "~" + ds.Tables[0].Rows[i].GSTIN + "~" + ds.Tables[0].Rows[i].Description, ds.Tables[0].Rows[i].NAME + "~" + ds.Tables[0].Rows[i].BPCode + "~" + ds.Tables[0].Rows[i].GSTIN + "~" + ds.Tables[0].Rows[i].Description);
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
        jq('#txtsupname').val(str[0])
        jq('#txtsupcode').val(str[1])
        jq('#hdnsupcode').val(str[1])
        jq('#txtgstin').val(str[3])
        jq('#hdnsuppgstin').val(str[2])
        jq('#divsuplircode').css("display", "none");
        jq('#txtsupcode').focus();
        return false;
    }
    else if (keycode == 27) {
        jq('#divsuplircode').css("display", "none");
        jq('#txtsupcode').focus();
        return false;
    }
}

function EnableExecute() {
    var res_vch12 = "";
    try {
        var ParameterValueArray = [];
        var PPONo = document.getElementById("txtpo").value;
        var PPoDate = document.getElementById("txtpodat").value;
        var PRevisionNo = document.getElementById("txtrevision").value;
        var Pstatus = "";
        var PQuatationNo = document.getElementById("txtquationno").value;
        var PQuotationDate = document.getElementById("txtqudt").value;
        var PBPCode = document.getElementById("txtsupcode").value;
        var PBPGSTIN = document.getElementById("txtgstin").value;
        var PERPCompany = document.getElementById("txterpno").value;
        var PIsgecGSTIN = document.getElementById("txtisgecgstin").value;

        var PPaymentTerm = document.getElementById("txtpymntterm").value;
        var PDeliveryTerm = document.getElementById("txtdelveryon").value;
        var PModeofDispatch = document.getElementById("txtdispacth").value;
        var PDestination = document.getElementById("txtdes").value;
        var PInsurance = document.getElementById("txtinsurance").value;

        var PRemarks = document.getElementById("txtremrks").value;
        var PApproverType = document.getElementById("txtaprvdt").value;
        var PCreatedby = document.getElementById("txtcrtdby").value;
        var PCreatedOn = document.getElementById("txtcrtdon").value;
        var PSentforapprovalBy = document.getElementById("txtsentaprv").value;
        var PSentforApprovalon = document.getElementById("txtaprvon").value;
        var PApprovedBy = document.getElementById("txtaprovedby").value;
        var PApprovedOn = document.getElementById("txtaprovedon").value;
        var PReasonofRevision = document.getElementById("txtrreason").value;
        var PApproval_RejectionRemarks = document.getElementById("txtreject").value;
        var flag = "E";
        var pextra1 = "";
        var pextra2 = "";
        var pextra3 = "";
        var pextra4 = "";
        var pextra5 = "";
        var currency = document.getElementById("drpcurrency").value;
        var conversionfactor = document.getElementById("txtconvervisonfactor").value;
        var connstring = document.getElementById("hdnconnectionstring").value;
        var res_vch2 = PurchasesOrder.hdr_save(PPONo, PPoDate, PRevisionNo, Pstatus, PQuatationNo, PQuotationDate, PBPCode, PBPGSTIN, PERPCompany,
        PIsgecGSTIN, PPaymentTerm, PDeliveryTerm, PModeofDispatch, PDestination, PInsurance, PRemarks, PApproverType, PCreatedby,
        PCreatedOn, PSentforapprovalBy, PSentforApprovalon, PApprovedBy, PApprovedOn, PReasonofRevision, PApproval_RejectionRemarks,
        flag, pextra1, pextra2, pextra3, pextra4, pextra5, connstring, currency, conversionfactor);

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
            jq('#txtsupname,#txtsupcode,#txtrreason,#txtreject,#txterpno,#txtstatus,#txtisgecgstin,#txtquationno,#txtqudt,#txtaprvdt,#txtcrtdby,#txtpymntterm,#txtcrtdon,#txtdelveryon,#txtsentaprv,#txtdispacth,#txtaprvon,#txtdes,#txtaprovedby,#txtinsurance,#txtaprovedon,#txtremrks').prop("disabled", true);
            jq("#txtsupname,#txtquationno,#txtisgecgstin,#txtaprvdt,#txtqudt,#txtpymntterm,#txtdelveryon,#txtdispacth,#txtdes,#txtinsurance,#txtconvervisonfactor,#drpcurrency,#txtremrks").css("background-color", "#C0C0C0");
            executehdr();
            setButtonImages();

            return false;
        }

    }
    return false;
}

function executehdr(val) {

    if (exec_data.Tables[0].Rows[next].PONo != null || exec_data.Tables[0].Rows[next].PONo != "" || exec_data.Tables[0].Rows[next].PONo != "null") {
        document.getElementById("txtpo").value = fndnull(exec_data.Tables[0].Rows[next].PONo);
        document.getElementById("txtpodat").value = fndnull(exec_data.Tables[0].Rows[next].PoDate);
        document.getElementById("txtrevision").value = fndnull(exec_data.Tables[0].Rows[next].RevisionNo);
        document.getElementById("txtstatus").value = fndnull(exec_data.Tables[0].Rows[next].status);
        document.getElementById("txtquationno").value = fndnull(exec_data.Tables[0].Rows[next].QuatationNo);
        document.getElementById("txtqudt").value = fndnull(exec_data.Tables[0].Rows[next].QuotationDate);
        document.getElementById("txtsupname").value = fndnull(exec_data.Tables[0].Rows[next].BPNAME);
        document.getElementById("txtsupcode").value = fndnull(exec_data.Tables[0].Rows[next].BPCode);
        document.getElementById("hdnsuppgstin").value = fndnull(exec_data.Tables[0].Rows[next].BPGSTIN);
        document.getElementById("txtgstin").value = fndnull(exec_data.Tables[0].Rows[next].BPgstin_desc);
        document.getElementById("txterpno").value = fndnull(exec_data.Tables[0].Rows[next].ERPCompany);
        document.getElementById("txtisgecgstin").value = fndnull(exec_data.Tables[0].Rows[next].IsgecGSTIN);
        document.getElementById("txtpymntterm").value = fndnull(exec_data.Tables[0].Rows[next].PaymentTerm);
        document.getElementById("txtdelveryon").value = fndnull(exec_data.Tables[0].Rows[next].DeliveryTerm);
        document.getElementById("txtdispacth").value = fndnull(exec_data.Tables[0].Rows[next].ModeofDispatch);
        document.getElementById("txtdes").value = fndnull(exec_data.Tables[0].Rows[next].Destination);
        document.getElementById("txtinsurance").value = fndnull(exec_data.Tables[0].Rows[next].Insurance);
        document.getElementById("txtaprvdt").value = fndnull(exec_data.Tables[0].Rows[next].ApproverType);
        document.getElementById("txtcrtdby").value = fndnull(exec_data.Tables[0].Rows[next].Createdby);
        document.getElementById("txtcrtdon").value = fndnull(exec_data.Tables[0].Rows[next].CreatedOn);
        document.getElementById("txtsentaprv").value = fndnull(exec_data.Tables[0].Rows[next].SentforapprovalBy);
        document.getElementById("txtaprvon").value = fndnull(exec_data.Tables[0].Rows[next].SentforApprovalon);
        document.getElementById("txtaprovedby").value = fndnull(exec_data.Tables[0].Rows[next].ApprovedBy);
        document.getElementById("txtaprovedon").value = fndnull(exec_data.Tables[0].Rows[next].ApprovedOn);
        document.getElementById("txtrreason").value = fndnull(exec_data.Tables[0].Rows[next].ReasonofRevisior);
        document.getElementById("txtreject").value = fndnull(exec_data.Tables[0].Rows[next].Approval_RejectionRemarks);
        document.getElementById("txtremrks").value = fndnull(exec_data.Tables[0].Rows[next].Remarks);
        document.getElementById("txtwarrentyrmk").value = fndnull(exec_data.Tables[0].Rows[next].item_remarks);

        BindBudgetAccountDetail1(exec_data.Tables[0].Rows[next].PONo);
        if (document.getElementById("txtstatus").value == "Created") {
            document.getElementById('btnsentfrapproval').style.display = "block";
            document.getElementById('btnapproval').style.display = "none";
            document.getElementById('btnreject').style.display = "none";
            document.getElementById("btnModify").disabled = false;
            document.getElementById("txtremrks").disabled = false;
            jq("#txtremrks").css("background-color", "#FFFFFF");
            jq("#txtreject").css("background-color", "#C0C0C0");
            setButtonImages();
        }
        if (document.getElementById("txtstatus").value == "Sent for approval") {
            document.getElementById('btnsentfrapproval').style.display = "none";
            document.getElementById('btnapproval').style.display = "block";
            document.getElementById('btnreject').style.display = "block";
            document.getElementById("btnModify").disabled = true;
            document.getElementById("txtreject").disabled = false;
            jq("#txtremrks").css("background-color", "#C0C0C0");
            jq("#txtreject").css("background-color", "#FFFFFF");
            setButtonImages();
        }
        if (document.getElementById("txtstatus").value == "Approved") {
            document.getElementById('btnsentfrapproval').style.display = "none";
            document.getElementById('btnapproval').style.display = "none";
            document.getElementById('btnreject').style.display = "none";
            document.getElementById("btnModify").disabled = true;
            document.getElementById("txtreject").disabled = false;
            jq("#txtremrks").css("background-color", "#C0C0C0");
            jq("#txtreject").css("background-color", "#FFFFFF");
            setButtonImages();
        }
        if (document.getElementById("txtstatus").value == "Rejected") {
            document.getElementById('btnsentfrapproval').style.display = "none";
            document.getElementById('btnapproval').style.display = "none";
            document.getElementById('btnreject').style.display = "none";
            document.getElementById("btnModify").disabled = true;
            document.getElementById("txtreject").disabled = false;
            jq("#txtreject").css("background-color", "#FFFFFF");
            jq("#txtremrks").css("background-color", "#C0C0C0");
            setButtonImages();
        }
    }


    return false;
}

var count1 = 0;
function BindBudgetAccountDetail1(typecd) {

    jq('#BtnAddRow').attr('disabled', false);
    var PPONo = document.getElementById("txtpo").value;
    var rivision_no = document.getElementById("txtrevision").value;
    var line_no = "";
    var Item_Code = "";
    var Quantity = "";
    var Unit = "";
    var currency = "";
    var Price_per_unit = "";
    var Assessable_Value = "";
    var Tax_Code = "";
    var SGST_rate = "";
    var CGST_rate = "";
    var IGST_rate = "";
    var CESS_rate = "";
    var TCS_rate = "";
    var SGST_Amount = "";
    var CGST_Amount = "";
    var IGST_Amount = "";
    var CESS_Amount = "";
    var TCS_Amount = "";
    var flag = "E";
    var pextra1 = "";
    var pextra2 = "";
    var pextra3 = "";
    var pextra4 = "";
    var pextra5 = "";
    var billtype = "";
    var hsnsac = "";
    var employee = "";
    var department = "";
    var costcenter = "";
    var connstring = document.getElementById("hdnconnectionstring").value;
    var res_vch2 = PurchasesOrder.hdr_savedet(PPONo, rivision_no, line_no, Item_Code, Quantity, Unit, currency, Price_per_unit, Assessable_Value, Tax_Code, SGST_rate, CGST_rate,
   IGST_rate, CESS_rate, TCS_rate, SGST_Amount, CGST_Amount, IGST_Amount, CESS_Amount, TCS_Amount, flag, pextra1, pextra2, pextra3, pextra4, pextra5, connstring, billtype, hsnsac, employee, department, costcenter);


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
            for (count = 0; count < dsmain1.Tables[0].Rows.length; count++) {
                hdsview += ("<tr>")
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtpoline_" + count + " value='" + fndnull(dsmain1.Tables[0].Rows[count].POLine) + "'></td>"
                hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left;' id=txtitemcode_" + count + "  value='" + fndnull(dsmain1.Tables[0].Rows[count].itemdescription) + "' onkeydown='return binditemcodef2(event);' ></td>"
                hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left; ' id=txtqty_" + count + "   value='" + fndnull(dsmain1.Tables[0].Rows[count].Quantity) + "'></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtuom_" + count + "  value='" + fndnull(dsmain1.Tables[0].Rows[count].Unit) + "'  ></td>"
                hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left;' id=txtpricperunit_" + count + " value='" + parseFloat(fndnull(dsmain1.Tables[0].Rows[count].Price)).toFixed(2) + "' onblur='autocalcamt(this.id,this.value,event)'></td>"
                hdsview += "<td><input  name='Enable' class='gridinputclassnew' style='text-align:left; ' id=txtaccessbleval_" + count + "  value='" + parseFloat(fndnull(dsmain1.Tables[0].Rows[count].AssessableValue)).toFixed(2) + "'   ></td>"
                hdsview += "<td><input  name='Enable'  class='gridinputclassnew' style='text-align:left; ' id=txttaxcode_" + count + " value='" + fndnull(dsmain1.Tables[0].Rows[count].taxcddescription) + "'  onkeydown='return bindtaxtypecodef2(event);' ></td>"
                hdsview += "<td><input  name='Enable'  class='gridinputclassnew' style='text-align:left; ' id=txtbilltype_" + count + " value='" + fndnull(dsmain1.Tables[0].Rows[count].Bill_TypeName) + "'  onkeydown='return bindbilltypecodef2(event);' ></td>"
                hdsview += "<td><input  name='Enable'  class='gridinputclassnew' style='text-align:left; ' id=txthsnsac_" + count + " value='" + fndnull(dsmain1.Tables[0].Rows[count].hsncodename) + "'  onkeydown='return bindhsnsaccodef2(event);' ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtsgstrate_" + count + "  value='" + parseFloat(fndnull(dsmain1.Tables[0].Rows[count].SGSTrate)).toFixed(2) + "'   ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtcgstrate_" + count + " value='" + parseFloat(fndnull(dsmain1.Tables[0].Rows[count].CGSTrate)).toFixed(2) + "'></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtigstrate_" + count + "  value='" + parseFloat(fndnull(dsmain1.Tables[0].Rows[count].IGSTrate)).toFixed(2) + "'   ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtcessrate_" + count + " value='" + parseFloat(fndnull(dsmain1.Tables[0].Rows[count].CESSrate)).toFixed(2) + "'></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txttcsrate_" + count + " value='" + parseFloat(fndnull(dsmain1.Tables[0].Rows[count].TCSrate)).toFixed(2) + "'  ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtsgstamt_" + count + " value='" + parseFloat(fndnull(dsmain1.Tables[0].Rows[count].SGSTAmount)).toFixed(2) + "'></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtcgstamt_" + count + "  value='" + parseFloat(fndnull(dsmain1.Tables[0].Rows[count].CGSTAmount)).toFixed(2) + "'   ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtigstamt_" + count + " value='" + parseFloat(fndnull(dsmain1.Tables[0].Rows[count].IGSTAmount)).toFixed(2) + "'></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txtcessamt_" + count + " value='" + parseFloat(fndnull(dsmain1.Tables[0].Rows[count].CESSAmount)).toFixed(2) + "'  ></td>"
                hdsview += "<td><input  name='Disable' class='gridinputclassnew' style='text-align:left; background-color:#C0C0C0;' id=txttcsamt_" + count + " value='" + parseFloat(fndnull(dsmain1.Tables[0].Rows[count].TCSAmount)).toFixed(2) + "'></td>"
                hdsview += "<td><input  name='Enable'  class='gridinputclassnew' style='text-align:left; ' id=txtemployee_" + count + " value='" + fndnull(dsmain1.Tables[0].Rows[count].emp_Name) + "'  onkeydown='return bindemployeef2(event);' ></td>"
                hdsview += "<td><input  name='Enable'  class='gridinputclassnew' style='text-align:left; ' id=txtdepartment_" + count + " value='" + fndnull(dsmain1.Tables[0].Rows[count].depart_Name) + "'  onkeydown='return binddepartmentidf2(event);' ></td>"


                
                hdsview += "<td><input  name='Enable'  class='gridinputclassnew' style='text-align:left; ' id=txtcostcenter_" + count + " value='" + fndnull(dsmain1.Tables[0].Rows[count].costcenter_Name) + "'  onkeydown='return bindcostcenteridf2(event);' ></td>"

                hdsview += "<td><input  name='Enable'  class='gridinputclassnew' style='text-align:left; ' id=txtitemremark_" + count + " value='" + fndnull(dsmain1.Tables[0].Rows[count].item_remarks) + "'  ></td>" //added by at on 4 march 21
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' id=hdntaxtyocdcdgrid_" + count + "  value='" + fndnull(dsmain1.Tables[0].Rows[count].TaxCode) + "'    disabled></td>";
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' id=hdnrategrid_" + count + "        value=''     disabled></td>";
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' id=hdnitemcdgrid_" + count + "      value='" + fndnull(dsmain1.Tables[0].Rows[count].ItemCode) + "'   disabled></td>";
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' id=hdnbilltypecdgrid_" + count + "   value='" + fndnull(dsmain1.Tables[0].Rows[count].BillType) + "'   disabled></td>";
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' id=hdnhsnsaccdgrid_" + count + "     value='" + fndnull(dsmain1.Tables[0].Rows[count].HSNSACCode) + "'   disabled></td>";

                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' id=hdnemployeegrid_" + count + "     value='" + fndnull(dsmain1.Tables[0].Rows[count].EmployeeID) + "'   disabled></td>";
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' id=hdndepartmentgrid_" + count + "   value='" + fndnull(dsmain1.Tables[0].Rows[count].DepartmentID) + "'   disabled></td>";
                hdsview += "<td style='display:none;'><input type = 'text' class='class_disabled1' style='font-size:small;color:black;cursor:pointer;vertical-align:top; padding-right:2px; text-align:left;width:100%; text-transform: uppercase;' id=hdncostcentergrid_" + count + "   value='" + fndnull(dsmain1.Tables[0].Rows[count].CostCenterID) + "'   disabled></td>";

                hdsview += ("</tr>")

            }
            execount = count;
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


function forsentapp() {

    if (confirm("Are you sure you want to send to approve this PO.?") == true) {
        var pono = document.getElementById("txtpo").value;
        var previsionno = document.getElementById("txtrevision").value;
        var status = "Sent for approval";//document.getElementById("txtstatus").value;
        var userby = document.getElementById("hdnusername").value;
        var remarks = document.getElementById("txtremrks").value;
        var connstring = document.getElementById("hdnconnectionstring").value;

        var res_vch = PurchasesOrder.statusupdate(pono, previsionno, status, userby, remarks, connstring);

        if (res_vch.error != null) {
            alert(res_vch.error.description);
            return false;
        }
        else {
            alert(res_vch.value.Tables[0].Rows[0].MSG)
            win = window.open('PODetailList.aspx?pono=' + "" + '&us=' + document.getElementById('hdnuserid').value + '&cm=' + document.getElementById('hdncompname').value, '', 'width=' + screen.availWidth + ',height=' + screen.availHeight + ',resizable=1,left=0,top=0,scrollbars=yes');
            //return false;
            return false;
        }
    }
    else {
        return false;
    }
}


function Approve() {

    var pono1 = document.getElementById("txtpo").value;
    var previsionno1 = document.getElementById("txtrevision").value;
    var status1 = "Approved";//document.getElementById("txtstatus").value;
    var userby1 = document.getElementById("hdnusername").value;
    var remarks1 = document.getElementById("txtreject").value;
    var connstring1 = document.getElementById("hdnconnectionstring").value;
    var res_vch1 = PurchasesOrder.checkupdate(pono1, previsionno1, status1, userby1, remarks1, connstring1);
    

    if (res_vch1.error != null) {
        alert(res_vch1.error.description);
        return false;
    }
    else {

        if (res_vch1.value.Tables[0].Rows.length > 0) {
            var accessbleval = res_vch1.value.Tables[0].Rows[0].accesss_val;
            var limit = res_vch1.value.Tables[0].Rows[0].limit;
            if (limit == null) {limit = 0};
            if (parseFloat(accessbleval) > parseFloat(limit)) {
                alert('You cant not approve this PO.because assessable value cross the approval limit for this user')
                return false
                ;
            }
            else {
                if (confirm("Are you sure you want to approve this PO.?") == true) {
                    var pono = document.getElementById("txtpo").value;
                    var previsionno = document.getElementById("txtrevision").value;
                    var status = "Approved";//document.getElementById("txtstatus").value;
                    var userby = document.getElementById("hdnusername").value;
                    var remarks = document.getElementById("txtreject").value;
                    var connstring = document.getElementById("hdnconnectionstring").value;

                    var res_vch = PurchasesOrder.statusupdate(pono, previsionno, status, userby, remarks, connstring);

                    if (res_vch.error != null) {
                        alert(res_vch.error.description);
                        return false;
                    }
                    else {
                        alert(res_vch.value.Tables[0].Rows[0].MSG)
                        win = window.open('PODetailList.aspx?pono=' + "" + '&us=' + document.getElementById('hdnuserid').value + '&cm=' + document.getElementById('hdncompname').value, '', 'width=' + screen.availWidth + ',height=' + screen.availHeight + ',resizable=1,left=0,top=0,scrollbars=yes');
                        //return false;
                        return false;
                    }
                }
                else {
                    return false;
                }
            }
        }
    }
}

function Reject() {

    if (confirm("Are you sure you want to reject this PO.?") == true) {
        var pono = document.getElementById("txtpo").value;
        var previsionno = document.getElementById("txtrevision").value;
        var status = "Rejected";//document.getElementById("txtstatus").value;
        var userby = document.getElementById("hdnusername").value;
        var remarks = document.getElementById("txtreject").value;
        var connstring = document.getElementById("hdnconnectionstring").value;

        var res_vch = PurchasesOrder.statusupdate(pono, previsionno, status, userby, remarks, connstring);

        if (res_vch.error != null) {
            alert(res_vch.error.description);
            return false;
        }
        else {
            alert(res_vch.value.Tables[0].Rows[0].MSG)
            win = window.open('PODetailList.aspx?pono=' + "" + '&us=' + document.getElementById('hdnuserid').value + '&cm=' + document.getElementById('hdncompname').value, '', 'width=' + screen.availWidth + ',height=' + screen.availHeight + ',resizable=1,left=0,top=0,scrollbars=yes');
            //return false;
            return false;
        }
    }
    else {
        return false;
    }
}


function bindsuplierisgcode(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var activeid = document.activeElement.id.split('_')[1];
    var id = activeid;//CurrentTextId.split('_')[1];
    CurrentTextId = document.activeElement.id;
    if (event.keyCode == 113) {
        offset(document.activeElement.id, "divsupisgccode", "lstsuplierisgccode");
        var connstring = document.getElementById("hdnconnectionstring").value;
        var res = PurchasesOrder.Bindsupisgccode(jq('#' + CurrentTextId).val().toUpperCase(), "", "", "", "", "", connstring, BindsuplierisgcodeCallbackgrid);
        return false;
    }
    else if (keycode == 8 || keycode == 46) {
        jq('#' + CurrentTextId, "#hdnsupisgccode" + id).val('')
    }
    else if (keycode != 13 && keycode != 37 && keycode != 39 && keycode != 9 && keycode != 17 && event.shiftKey == false && event.ctrlKey == false && event.altKey == false) {
        jq('#' + CurrentTextId, "#hdnsupisgccode" + id).val('')
    }
    if (event.ctrlKey == true && keycode == 88) {
        jq('#' + CurrentTextId, "#hdnsupisgccode" + id).val('')
    }
}

function BindsuplierisgcodeCallbackgrid(res) {
    var ds = res.value;
    var pkgitem = document.getElementById('lstsuplierisgccode')
    pkgitem.options.length = 0;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        pkgitem.options[0] = new Option("---Select Supplier Isgc Code---", "0");
        pkgitem.options.length = 1;
        for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].gstid + "~" + ds.Tables[0].Rows[i].gstin, ds.Tables[0].Rows[i].gstid + "~" + ds.Tables[0].Rows[i].gstin);
            pkgitem.options.length;
        }
    }
    else {
        pkgitem.options[0] = new Option("---There is no data accourding your search---", "");
        return false;
    }
    jq('#lstsuplierisgccode').focus();
    return false;
}
function fillsuplierisgeccode(event) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var id = CurrentTextId.split('_')[1];
    if (keycode == 13 || event.type == "click") {
        if (fndnull(jq('#lstsuplierisgccode').val()) == "") {
            alert("Please Select Supplier Code..!!");
            jq('#lstsuplircode').focus();
            return false;
        }
        var activeid = CurrentTextId.split('_')[1];
        var page = jq('#lstsuplierisgccode').val()
        var str = page.split("~");
        // jq('#txtsupname').val(str[0])
        jq('#txtisgecgstin').val(str[1])
        jq('#hdnsupisgccode').val(str[1])
        //  jq('#txtgstin').val(str[2])
        jq('#divsupisgccode').css("display", "none");
        jq('#txtisgecgstin').focus();
        return false;
    }
    else if (keycode == 27) {
        jq('#divsupisgccode').css("display", "none");
        jq('#txtisgecgstin').focus();
        return false;
    }
}

function ConversionFactorChamge() {
    if (jq("#drpcurrency").val() == "INR") {
        jq("#txtconvervisonfactor").val("1");
        jq("#txtconvervisonfactor").css("background-color", "#C0C0C0");
    }
    else {
        jq("#txtconvervisonfactor").val("1");
        jq("#txtconvervisonfactor").css("background-color", "#FFFFFF");
    }
    return false;
}


function clearclick11() {

    jq('#txtpo,#txtsupcode,#txtrreason,#txterpno,#txtstatus,#txtisgecgstin,#txtquationno,#txtqudt,#txtaprvdt,#txtcrtdby,#txtpymntterm,#txtcrtdon,#txtdelveryon,#txtsentaprv,#txtdispacth,#txtaprvon,#txtdes,#txtaprovedby,#txtinsurance,#txtaprovedon,#txtreject,#drpcurrency,#txtconvervisonfactor,#txtsupname,#txtwarrentyrmk').prop("disabled", true);
    jq('#txtpo,#txtsupcode,#txtrreason,#txtgstin,#txtstatus,#txtquationno,#txtqudt,#txtaprvdt,#txtpymntterm,#txtdelveryon,#txtsentaprv,#txtdispacth,#txtaprvon,#txtdes,#txtaprovedby,#txtinsurance,#txtaprovedon,#txtremrks,#txtconvervisonfactor,#txtsupname,#txtwarrentyrmk').val('');
    jq('#btnSave,#btnModify,#btnExecute,#btnfirst,#btnprevious,#btnnext,#btnlast,#txtpodat,#txtrevision,#txtgstin').prop("disabled", true);
    jq('#btnNew,#btnQuery').prop("disabled", false);
    jq('#btnNew,#btnCancel,#btnExit').focus();
    document.getElementById('btnsentfrapproval').style.display = "none";
    document.getElementById('btnapproval').style.display = "none";
    document.getElementById('btnreject').style.display = "none";

    jq("#txtpo,#txtpodat,#txtrevision,#txtsupcode,#txtrreason,#txterpno,#txtstatus,#txtisgecgstin,#txtquationno,#txtqudt,#txtaprvdt,#txtcrtdby,#txtpymntterm,#txtcrtdon,#txtdelveryon,#txtsentaprv,#txtdispacth,#txtaprvon,#txtdes,#txtaprovedby,#txtinsurance,#txtaprovedon,#txtreject,#drpcurrency,#txtconvervisonfactor,#drpcurrency,#txtsupname,#txtsupcode,#txtgstin,#txtremrks").css("background-color", "#C0C0C0");
    if (jq("#drpcurrency").val() == "INR") {
        jq("#txtconvervisonfactor").val("1");
    }
    setButtonImages();
    document.getElementById('divpogrid').innerHTML = "";
    return false;
}


function getrdncheck(rdn) {

    var res_vch12 = "";
    try {
        var ParameterValueArray = [];
        var PPONo = rdn;
        var PPoDate = "";
        var PRevisionNo = "";
        var Pstatus = "";
        var PQuatationNo = "";
        var PQuotationDate = "";
        var PBPCode = "";
        var PBPGSTIN = "";
        var PERPCompany = "";
        var PIsgecGSTIN = "";

        var PPaymentTerm = "";
        var PDeliveryTerm = "";
        var PModeofDispatch = "";
        var PDestination = "";
        var PInsurance = "";

        var PRemarks = "";
        var PApproverType = "";
        var PCreatedby = "";
        var PCreatedOn = "";
        var PSentforapprovalBy = "";
        var PSentforApprovalon = "";
        var PApprovedBy = "";
        var PApprovedOn = "";
        var PReasonofRevision = "";
        var PApproval_RejectionRemarks = "";
        var flag = "E";
        var pextra1 = "";
        var pextra2 = "";
        var pextra3 = "";
        var pextra4 = "";
        var pextra5 = "";
        var currency = "";
        var conversionfactor = "";
        var connstring = document.getElementById("hdnconnectionstring").value;
        var res_vch2 = PurchasesOrder.hdr_save(PPONo, PPoDate, PRevisionNo, Pstatus, PQuatationNo, PQuotationDate, PBPCode, PBPGSTIN, PERPCompany,
        PIsgecGSTIN, PPaymentTerm, PDeliveryTerm, PModeofDispatch, PDestination, PInsurance, PRemarks, PApproverType, PCreatedby,
        PCreatedOn, PSentforapprovalBy, PSentforApprovalon, PApprovedBy, PApprovedOn, PReasonofRevision, PApproval_RejectionRemarks,
        flag, pextra1, pextra2, pextra3, pextra4, pextra5, connstring, currency, conversionfactor);

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
            jq('#txtsupname,#txtsupcode,#txtrreason,#txtreject,#txterpno,#txtstatus,#txtisgecgstin,#txtquationno,#txtqudt,#txtaprvdt,#txtcrtdby,#txtpymntterm,#txtcrtdon,#txtdelveryon,#txtsentaprv,#txtdispacth,#txtaprvon,#txtdes,#txtaprovedby,#txtinsurance,#txtaprovedon,#txtremrks').prop("disabled", true);
            jq("#txtsupname,#txtquationno,#txtisgecgstin,#txtaprvdt,#txtqudt,#txtpymntterm,#txtdelveryon,#txtdispacth,#txtdes,#txtinsurance,#txtconvervisonfactor,#drpcurrency,#txtremrks").css("background-color", "#C0C0C0");
            executehdr();
            setButtonImages();

            return false;
        }

    }
    return false;
}