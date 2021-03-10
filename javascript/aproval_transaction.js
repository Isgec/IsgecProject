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
function Exit() {
    if (confirm("Do You Want To Skip This Page")) {
        window.close();
        return false;
    }
    return false;
}

function EnableExecute() {
    var res_vch12 = "";
    try {
        var ParameterValueArray = [];
        var PPONo = document.getElementById("txtpono").value;
        var PPoDate = document.getElementById("txtpodt").value;
        var PRevisionNo = "";//document.getElementById("txtrevision").value;
        var Pstatus = "";
        var PQuatationNo = "";//document.getElementById("txtquationno").value;
        var PQuotationDate = "";// document.getElementById("txtqudt").value;
        var PBPCode = "";// document.getElementById("txtsupcode").value;
        var PBPGSTIN = "";// document.getElementById("txtgstin").value;
        var PERPCompany = "";//document.getElementById("txterpno").value;
        var PIsgecGSTIN = "";// document.getElementById("txtisgecgstin").value;

        var PPaymentTerm = "";// document.getElementById("txtpymntterm").value;
        var PDeliveryTerm = "";// document.getElementById("txtdelveryon").value;
        var PModeofDispatch = "";// document.getElementById("txtdispacth").value;
        var PDestination = "";//document.getElementById("txtdes").value;
        var PInsurance = "";//document.getElementById("txtinsurance").value;

        var PRemarks = "";//document.getElementById("txtremrks").value;
        var PApproverType = "";// document.getElementById("txtaprvdt").value;
        var PCreatedby = "";//document.getElementById("txtcrtdby").value;
        var PCreatedOn = "";// document.getElementById("txtcrtdon").value;
        var PSentforapprovalBy = "";// document.getElementById("txtsentaprv").value;
        var PSentforApprovalon = "";// document.getElementById("txtaprvon").value;
        var PApprovedBy = "";//document.getElementById("txtaprovedby").value;
        var PApprovedOn = "";// document.getElementById("txtaprovedon").value;
        var PReasonofRevision = "";//document.getElementById("txtrreason").value;
        var PApproval_RejectionRemarks = "";// document.getElementById("txtreject").value;
        var flag = "E";
        var pextra1 = "";
        var pextra2 = "";
        var pextra3 = "";
        var pextra4 = "";
        var pextra5 = "";
        var res_vch2 = aproval_transaction.hdr_save(PPONo, PPoDate, PRevisionNo, Pstatus, PQuatationNo, PQuotationDate, PBPCode, PBPGSTIN, PERPCompany,
        PIsgecGSTIN, PPaymentTerm, PDeliveryTerm, PModeofDispatch, PDestination, PInsurance, PRemarks, PApproverType, PCreatedby,
        PCreatedOn, PSentforapprovalBy, PSentforApprovalon, PApprovedBy, PApprovedOn, PReasonofRevision, PApproval_RejectionRemarks,
        flag, pextra1, pextra2, pextra3, pextra4, pextra5);

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
            jq('#txtsupcode,#txtrreason,#txtreject,#txterpno,#txtstatus,#txtisgecgstin,#txtquationno,#txtqudt,#txtaprvdt,#txtcrtdby,#txtpymntterm,#txtcrtdon,#txtdelveryon,#txtsentaprv,#txtdispacth,#txtaprvon,#txtdes,#txtaprovedby,#txtinsurance,#txtaprovedon,#txtremrks').prop("disabled", true);
            executehdr();
            setButtonImages();

            return false;
        }

    }
    return false;
}