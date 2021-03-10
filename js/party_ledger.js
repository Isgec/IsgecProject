var browser = navigator.appName;
var jq = jQuery.noConflict();

function runledgerreport() {
    
    var compcode = document.getElementById('hiddencompcode').value;
    var unitcode = document.getElementById('hdnunitcd').value;
    var actype = document.getElementById('NM').value;
    var branchcode = document.getElementById('hdnbrancd').value;
    var agencytype = "";
    var agcd = document.getElementById('hdnagencymaincode_default').value;
    var dpcd = document.getElementById('hdnagencysubcode_default').value;
    var state = "";
    var district = "";
    var city = "";
    var taluka = "";
    var fromdate = document.getElementById('txtfromdt').value;
    var tilldate = document.getElementById('txttodt').value;
    var billadjflag = "";
    var sortedby = "";
    var userid = "";
    var rowbreak = "";
    var dateformat = document.getElementById('hiddendateformat').value;
   
    var extra1 = "";
    var extra2 = "";
    var extra3 = "";
    var extra4 = "";
    var extra5 = "";
    var extra6 = "";
    var extra7 = "";
    var extra8 = "";
    var extra9 = "";
    var extra10 = "";

  

    var ans = party_ledger.generatereport_new(compcode, unitcode, actype, branchcode, agencytype, agcd, dpcd, state, district, city, taluka, fromdate, tilldate, billadjflag, sortedby,
                                               userid, rowbreak, dateformat, extra1, extra2, extra3, extra4, extra5, extra6, extra7, extra8, extra9, extra10)

    document.getElementById("gridview_data").innerHTML = ans.value;
    document.getElementById("gridview_data").style.display = "block";


    return false;
}