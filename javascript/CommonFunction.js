var browser = navigator.appName;
var jq = jQuery.noConflict();
function fndnull(val) {
    if (val == null || val == undefined || val == "undefined")
        val = ""
    return val
}
function blank_space(val) {
    if (val == "" || val == null || val == undefined || val == "null") {
        val = "&nbsp";
    }
    return val
}
function blank_to_zero(val) {
    if (val == "" || val == null || val == undefined || val == "null") {
        val = 0
    }
    return val
}
function chackvalue(value){
    var value = value;
    if(value == "" || value == null|| value == "null" || value == undefined || value == "undefined"){
        value = "";
    }
    return value;
}

function CheckDate(txtDate) {
    var currVal = txtDate;
    if (currVal == '')
        return false;

    var rxDatePattern = /^(\d{2,2})(\/|)(\d{2,2})(\/|)(\d{4})$/;
    var dtArray = currVal.match(rxDatePattern);

    if (dtArray == null)
        return false;

    dtDay = dtArray[1];
    dtMonth = dtArray[3];
    dtYear = dtArray[5];

    if (dtMonth < 1 || dtMonth > 12)
        return false;
    else if (dtDay < 1 || dtDay > 31)
        return false;
    else if ((dtMonth == 4 || dtMonth == 6 || dtMonth == 9 || dtMonth == 11) && dtDay == 31)
        return false;
    else if (dtMonth == 2) {
        var isleap = (dtYear % 4 == 0 && (dtYear % 100 != 0 || dtYear % 400 == 0));
        if (dtDay > 29 || (dtDay == 29 && !isleap))
            return false;
    }
    return true;
}


function CheckDateForGrid(id) {
    var currVal = document.getElementById(id).value;
    if (currVal == '')
        return false;

    var rxDatePattern = /^(\d{2,2})(\/|)(\d{2,2})(\/|)(\d{4})$/;
    var dtArray = currVal.match(rxDatePattern);

    if (dtArray == null) {
        alert('The date format should be : dd/mm/yyyy');
        jq('#' + id).val('')
        jq('#' + id).focus();
        return false;
    }
    dtDay = dtArray[1];
    dtMonth = dtArray[3];
    dtYear = dtArray[5];

    if (dtMonth < 1 || dtMonth > 12) {
        alert('The date format should be : dd/mm/yyyy');
        jq('#' + id).val('')
        jq('#' + id).focus();
        return false;
    }
    else if (dtDay < 1 || dtDay > 31) {
        alert('The date format should be : dd/mm/yyyy');
        jq('#' + id).val('')
        jq('#' + id).focus();
        return false;
    }
    else if ((dtMonth == 4 || dtMonth == 6 || dtMonth == 9 || dtMonth == 11) && dtDay == 31) {
        alert('The date format should be : dd/mm/yyyy');
        jq('#' + id).val('')
        jq('#' + id).focus();
        return false;
    }
    else if (dtMonth == 2) {
        var isleap = (dtYear % 4 == 0 && (dtYear % 100 != 0 || dtYear % 400 == 0));
        if (dtDay > 29 || (dtDay == 29 && !isleap)) {
            alert('The date format should be : dd/mm/yyyy');
            jq('#' + id).val('')
            jq('#' + id).focus();
            return false;
        }
    }
    return true;
}

function offset(activeid, divid, listboxid) {
    jq('#' + listboxid).empty();

    aTag = eval(document.getElementById(activeid))
    var btag;
    var leftpos = 0;
    var toppos = 18;
    do {
        aTag = eval(aTag.offsetParent);
        leftpos += aTag.offsetLeft;
        toppos += aTag.offsetTop;
        btag = eval(aTag)
    } while (aTag.tagName != "BODY" && aTag.tagName != "HTML");
    var tot = document.getElementById(divid).scrollLeft;
    var scrolltop = document.getElementById(divid).scrollTop;
    document.getElementById(divid).style.left = document.getElementById(activeid).offsetLeft + leftpos - tot + "px";
    document.getElementById(divid).style.top = document.getElementById(activeid).offsetTop + toppos - scrolltop + "px";
    jq('#' + divid).show("slow");
    document.getElementById(listboxid).focus();
}
function OffSetForGrid(activeid, divid, listboxid, griddivid) {
    jq('#' + listboxid).empty();

    var a11 = document.activeElement
    var a111 = document.activeElement
    var curtop = 0;
    var curleft = 0;
    if (a11.offsetParent) {
        while (1) {
            curtop += a11.offsetTop;
            if (!a11.offsetParent)
                break;
            a11 = a11.offsetParent;
        }
    }
    else if (a11.y) {
        curtop += a11.y;
    }
    if (a111.offsetParent) {
        while (1) {
            curleft += a111.offsetLeft
            if (!a111.offsetParent)
                break;
            a111 = a111.offsetParent;
        }
    }
    else if (a111.x) {
        curleft += a111.x;
    }
    curleft = curleft - document.getElementById(griddivid).scrollLeft;
    curtop = curtop - document.getElementById(griddivid).scrollTop;
    document.getElementById(divid).style.top = curtop + 18 + "px";
    document.getElementById(divid).style.left = curleft + "px";
    jq('#' + divid).show("slow");
    document.getElementById(listboxid).focus();
}

function check_mendetory(id) {
    var label_text = jq('#' + id).text();
    return label_text;
}

function OnClickExit() {
    if (confirm('Do you want skip the page')) {
        window.close();
        return false;
    }
    return false;
}

function ConvertJsonDate(dt) {
    var newdt = CHKDATE(eval(dt.replace(/\/Date\((\d+)\)\//gi, "new Date($1)")));
    return newdt;
}

function CHKDATE(userdate) {
    var mycondate = ""
    if (userdate == null || userdate == "") {
        mycondate = ""
        userdate = "";
        return mycondate
    }
    var dateformate = document.getElementById('hiddendateformat').value;
    if (document.getElementById('hiddendateformat').value == "dd/mm/yyyy") {
        var spmonth = "'" + userdate + "'";
        var pp = spmonth.split(" ");
        var mon = pp[1];
        var myDate = new Date(userdate);
        var date = myDate.getDate();

        if (date == 1 || date == 2 || date == 3 || date == 4 || date == 5 || date == 6 || date == 7 || date == 8 || date == 9)
            date = "0" + date;
        var month = myDate.getMonth() + 1;
        if (month == 1 || month == 2 || month == 3 || month == 4 || month == 5 || month == 6 || month == 7 || month == 8 || month == 9)
            month = "0" + month;
        var year = myDate.getFullYear();
        mycondate = date + "/" + month + "/" + year;
        return mycondate;
    }
    else if (document.getElementById('hiddendateformat').value == "mm/dd/yyyy") {
        var spmonth = "'" + userdate + "'";
        var pp = spmonth.split(" ");
        var mon = pp[1];
        var myDate = new Date(userdate);
        var date = myDate.getDate();
        var month = myDate.getMonth() + 1;
        var year = myDate.getFullYear();
        mycondate = month + "/" + date + "/" + year;
        return mycondate;
    }
    else if (document.getElementById('hiddendateformat').value == "yyyy/mm/dd") {
        var spmonth = "'" + userdate + "'";
        var pp = spmonth.split(" ");
        var mon = pp[1];
        var myDate = new Date(userdate);
        var date = myDate.getDate();
        var month = myDate.getMonth() + 1;
        var year = myDate.getFullYear();
        mycondate = year + "/" + month + "/" + date;
        return mycondate;
    }
}


function trim(stringToTrim) {
    return stringToTrim.replace(/^\s+|\s+$/g, "");
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



function EnterTab(evt, id) {
    var evt = (evt) ? evt : ((event) ? event : null);
    var node = (evt.target) ? evt.target : ((evt.srcElement) ? evt.srcElement : null);
    if ((evt.keyCode == 13) && (node.className != "btextlist") && ((node.type == "text") || (node.type == "select-one") || (node.type == "radio") || (node.type == "checkbox") || (node.type == "button"))) {
        getNextElement(node).focus();
        return false;
    }
}
function getNextElement(field) {
    var form = field.form;
    for (var e = 0; e < form.elements.length; e++) {
        if (field == form.elements[e]) {
            break;
        }
    }
    e++;
    while (form.elements[e % form.elements.length].type == undefined || form.elements[e % form.elements.length].type == "hidden" || form.elements[e % form.elements.length].disabled == true) {
        e++;
    }
    return form.elements[e % form.elements.length]; ;
}

function get_diffdate(t1, t2) { //t2 < t1 chack From Date and To Date
    var one_day = 1000 * 60 * 60 * 24;
    var x = t1.split("/");
    var y = t2.split("/");
    var date1 = new Date(x[2], (x[1] - 1), x[0]);
    var date2 = new Date(y[2], (y[1] - 1), y[0])
    var month1 = x[1] - 1;
    var month2 = y[1] - 1;
    _Diff = Math.ceil((date2.getTime() - date1.getTime()) / (one_day));
    if (_Diff < "0" && _Diff != "NaN" && t2 != "") {
        return false;
    }
    return true;
}

/*---------------------------change date formate----------------------------------------------------------------*/
function GetDate(str){
var formatddate = "";
if(str.indexOf('-')>0){
    var arr = str.split('-');
    var months = ['January', 'February', 'March', 'April', 'May', 'June','July', 'August', 'September', 'October', 'November', 'December'];
    var countmonths = 0;
    for (var i=0; i < months.length; i++) {
        countmonths++;
        if (months[i] == arr[1])
        {
            break;
        }
    }
        formatddate = arr[0]  + '/' + countmonths + '/' + arr[2];
    }
else{
    formatddate = str;
}
    return formatddate;
}
 
 /*-------------------------------------------------------Time formate----------------------------------------------------------------*/
function time_check(input){
    var validformat=/^\d{2}\:\d{2}\:\d{2}$/ //Basic check for format validity
    if(!validformat.test(input)){
        alert('Value should be in "00:00:00" format');
        document.getElementById(document.activeElement.id).value="00:00:00";
        document.getElementById(document.activeElement.id).focus();
        return false;
    }
    else{
        var val=input
        val=val.split(':');
        var val1=val[0];
        var val2=parseInt(val[1]);
        var val3=parseInt(val[2]);
        val1=parseInt(val1);
        if(val1<=24 && val2<=60 && val3<=60){
        }
        else if(val1>24 || val2>60 || val3>60){
            alert('The hour should be upto 24, minute and second value should be upto 60');
            document.getElementById(document.activeElement.id).value="00:00:00";
            document.getElementById(document.activeElement.id).focus();
            return false;
        }
        else{
        return true;
        }
    }
}
/*------------------------------------------------------- Type Number----------------------------------------------------------------*/

function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;

    return true;
}
/*------------------------------------------------------- chack mail id----------------------------------------------------------------*/
function ClientEmailCheck(val) {
    var theurl = document.getElementById(val).value

    if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(theurl) || document.getElementById(val).value == "") {
        return (true)
    }
    alert("Invalid E-mail address! Please re-enter.")
    document.getElementById(val).value = "";
    document.getElementById(val).focus();
    return (false)
}
/*------------------------------------------------------- Chack Mobile number----------------------------------------------------------------*/
function ChkMobNumber(val) {
    if (document.getElementById(val).value != "") {
        if (document.getElementById(val).value.length > parseInt("11") || document.getElementById(val).value.length < parseInt("10")) {
            alert("Mobile number should be between 10 to 11 digit")
            document.getElementById(val).focus()
            return false
        }
    }
    return false;
}
/*-------------------------------------------------------------------------------------------------------------------------------------------*/