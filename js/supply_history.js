var browser = navigator.appName;
var jq = jQuery.noConflict();

function OnClickReport() {
    
   
        if (jq("#txt_date").val() == "") {
            alert("Please Select form Date");
            jq("#txtfromdate").focus();
            return false;
        }
    
   
        if (jq("#txttilldate").val() == "") {
            alert("Please Select To Date");
            jq("#txttilldate").focus();
            return false;
        }
   

        var compcode = jq("#hdncomp_code").val()
        var compname = "";

        var unitcode = jq("#hdnloc_id").val();
        var unitname = "";

        var pubtypecode = "";
        var pubtypename = "";

        var pubcode = "";
        var pubname = "";

        var edtncode = "";
        var edtnname = "";

        var subedtncode = "";
    var subedtnname = "";

    var agtypecode = "";
    var agtypename = "";

    var agclasscode = "";
    var agclassname = "";

    var branchcode = "";
    var branchname = "";

    var agencyname = "";
    var agcd = jq("#agency_code").val();
    var dpcd = jq("#agency_subcode").val();

    var routecode = ""
    var routename = ""

    var statecode = ""
    var statename =""

    var districtcode = ""
    var districtname = ""

    var suptypecode = ""
    var suptypename = ""

    var finalflagcode = ""
    var finalflagname = "";

    var billpaycode = "";
    var billpayname = "";

    var fromdate = jq("#txt_date").val()
    var tilldate = jq("#txt_enddate").val()

    var reporttype =""
    var reportname = "";

    var reportforcode = "";
    var reportforname = "";

    var supplementtypecode = "";
    var supplementtypename = "";

    var supplementcode = "";
    var supplementname = "";

    var destination = "";
    var destinationname = "";

    var userid = jq("#hdnuser_id").val()
    var username = "";

    var dateformat = jq("#hdndateformate").val()
    var extra1 = jq("#hdnuser_id").val();
    var extra2 = "";
    var extra3 = "";
    var extra4 = "";
    var extra5 = "";
    var extra6 = "";
    var extra7 = "";
    var extra8 = "";
    var extra9 = "";
    var extra10 = "";

    if (pubtypecode == "") {
        pubtypename = "";
    }
    if (pubcode == "") {
        pubname = "";
    }
    if (edtncode == "") {
        edtnname = "";
    }
    if (subedtncode == "") {
        subedtnname = "";
    }
    if (agtypecode == "") {
        agtypename = "";
    }
    if (agclasscode == "") {
        agclassname = "";
    }
    if (branchcode == "") {
        branchname = "";
    }

    var ans=supply_history.generatereport(compcode, unitcode, branchcode, pubtypecode, pubcode, edtncode, subedtncode, routecode, statecode, districtcode,
            agtypecode, agclasscode, agcd, dpcd, suptypecode, finalflagcode, billpaycode, fromdate, tilldate, dateformat, reporttype, reportforcode, supplementtypecode,
            supplementcode, extra1, extra2, extra3, extra4, extra5, extra6, extra7, extra8, extra9, extra10)
    document.getElementById("gridview_data").innerHTML = ans.value;
    document.getElementById("gridview_data").style.display = "block";
    return false;
}