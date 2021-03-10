var browser = navigator.appName;
var jq = jQuery.noConflict();

function OnClickReport()
{
    
   
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
   

        var compcode = jq("#hdncomp_code").val();
        var compname = "";

        var unitcode = jq("#hdnloc_id").val();
        var unitname = "";



        var branchcode = "";
        var branchname = "";

        var pubcode = "";
        var pubname = "";


  
    var agcd = jq("#agency_code").val();
    var dpcd = jq("#agency_subcode").val();

    var agetype = "";
    var agename = "";

    var statecode = "";
    var statename = "";

    var citycode = "";
    var citytname = "";

    var pexeccode = "";

    var fromdate = jq("#txt_date").val();
    var tilldate = jq("#txt_enddate").val();

    var dateformat = "dd/mm/yy";
      
    var userid = jq("#hdnuser_id").val();
    var username = "";

    var extra1 = "";
    var extra2 = "";
    var extra3 = "";
    var extra4 = "";
    var extra5 = "";
  

  

    var ans = Monthely_billing.generatereport(compcode, unitcode, branchcode, pubcode, agcd, dpcd, agetype, statecode,
                                                         citycode,pexeccode, fromdate, tilldate, dateformat, userid,
                                                           extra1, extra2, extra3, extra4, extra5)
    document.getElementById("gridview_data").innerHTML = ans.value;
    document.getElementById("gridview_data").style.display = "block";
    return false;
}



