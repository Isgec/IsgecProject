var browser = navigator.appName;
var jq = jQuery.noConflict();
function onload() {

    var today = new Date();
    var date = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();

    var mon = date.split('-')[1];
    var year = date.split('-')[0];

    if (mon.length < 2) {
        mon = "0" + mon;
    }


    document.getElementById('ddlmonth').value = mon;
    document.getElementById('ddlyear').value = year;
    document.getElementById('drpformat').value = "C";
    document.getElementById('ddlmonth').focus();
    return false;
}


function forattendancereport() {
    var unitname = document.getElementById('txtunitname').value;
    var compcode = document.getElementById('hdncompcode').value;
    var unitcode = document.getElementById('hdnunit').value;
    var branchcode = document.getElementById('Hiddenbranchcode').value;
    var userid = document.getElementById('hdnuserid').value;
    var month = document.getElementById('ddlmonth').value;


    var monthSelect = document.getElementById("ddlmonth");
    var monthText = monthSelect.options[monthSelect.selectedIndex].text;

    var year = document.getElementById('ddlyear').value;
    var dateformat = document.getElementById('hiddendateformat').value;
    var format = document.getElementById('drpformat').value;
    var extra1 = document.getElementById('txtfromdate').value;
    var extra2 = document.getElementById('txttodate').value;
    var rpttype = document.getElementById('drprpttype').value;
    var extra3 = document.getElementById('drpformat').value;
    var extra4 = document.getElementById('hdnexecutive').value;
    var extra5 = "";
    if (document.getElementById("drpformat").value == "C" || document.getElementById("drpformat").value == "D" || document.getElementById("drpformat").value == "E" || document.getElementById("drpformat").value == "F") {

        if (unitname == "") {
            alert("please select unit");
            document.getElementById('txtunitname').focus();
            return false;
        }
    }

    window.open("Attendance_rpt_view.aspx?compcode=" + compcode + "&unitcode=" + unitcode +
    "&branchcode=" + branchcode + "&userid=" + userid + "&month=" + month + "&monthText=" + monthText + "&year=" + year +
    "&dateformat=" + dateformat + "&format=" + format + "&extra1=" + extra1 + "&extra2=" + extra2 + "&extra3=" + extra3 +
    "&extra4=" + extra4 + "&extra5=" + extra5 + "&rpttype=" + rpttype);
    return false;

}


function forcancel() {
    var today = new Date();
    var date = today.getFullYear() + '-' + (today.getMonth() + 1) + '-' + today.getDate();

    var mon = date.split('-')[1];
    var year = date.split('-')[0];

    if (mon.length < 2) {
        mon = "0" + mon;
    }


    document.getElementById('ddlmonth').value = mon;
    document.getElementById('ddlyear').value = year;
    document.getElementById('drpformat').value = "C";
    document.getElementById('ddlmonth').focus();
    return false;
}


function Exit() {

    window.close();
    return false;
}

//function onload()
//{
//    document.getElementById('ddlyear').disabled = false;
//    document.getElementById('ddlyear').focus();
//    document.getElementById('ddlmonth').disabled = false;
//    document.getElementById('txtfromdate').disabled = true;
//    document.getElementById('txttodate').disabled = true;

//}

//function onchange_report()
//{
//    //alert(document.getElementById('drpformat').value);
//    if (document.getElementById('drpformat').value == "C" || document.getElementById('drpformat').value == "D")
//    {
//        document.getElementById('ddlyear').disabled = false;
//        document.getElementById('ddlmonth').disabled = false;
//        document.getElementById('txtfromdate').disabled = true;
//        document.getElementById('txttodate').disabled = true;
//        //document.getElementById('monthlydetails').style.display = 'block';
//       // document.getElementById('daily').style.display = 'none';
//    }
//    else if (document.getElementById('drpformat').value == "E" || document.getElementById('drpformat').value == "F" || document.getElementById('drpformat').value == "G")
//    {
//        document.getElementById('ddlyear').disabled = true;
//        document.getElementById('ddlmonth').disabled = true;
//        document.getElementById('txtfromdate').disabled = false;
//        document.getElementById('txtfromdate').focus();
//        document.getElementById('txttodate').disabled = false;
//        //document.getElementById('monthlydetails').style.display = 'none';
//       // document.getElementById('daily').style.display = 'block';
//    }

//}


//smart search start unit name
jq(document).ready(function () {
    jq("#txtunitname").autocomplete({
        source: function (request, response) {
            document.getElementById("dpunitcode").value = "";
            document.getElementById("dpunitcode").value;
            var extra1 = document.getElementById("txtunitname").value;


            jq.ajax({
                url: "Attendance_rpt.aspx/fill_unit_one",
                data: JSON.stringify({ extra1: extra1 }),
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                autoFocus: true,
                success: function (data) {
                    response(data.d);

                },
                error: function (response) {
                    alert(response.responseText);
                },
                failure: function (response) {
                    alert(response.responseText);
                }

            });
        },
        select: function (event, ui) {
            event.preventDefault();
            jq("#txtunitname").val(ui.item.label.split("~")[1]);
            jq("#dpunitcode").val(ui.item.label.split("~")[0]);

        },
        minLength: 1
    });

});
//smart search end

//smart search start executive name
jq(document).ready(function () {
    jq("#txtexecutive").autocomplete({
        source: function (request, response) {
            //document.getElementById("dpunitcode").value = "";
            //document.getElementById("dpunitcode").value;
            var compcode = document.getElementById("hdncompcode").value;
            var punitcode = document.getElementById("hdnunit").value;
            var pbranchcode = document.getElementById("hdnbranch").value;
            var puserid = document.getElementById("hdnuserid").value;
            var pusername = document.getElementById("txtexecutive").value;
            var pdateformat = document.getElementById("hiddendateformat").value;
            var pextra1 = "";
            var pextra2 = "";
            var pextra3 = "";
            var pextra4 = "";
            var pextra5 = "";


            jq.ajax({
                url: "Attendance_rpt.aspx/fill_executive_one",
                data: JSON.stringify({ compcode: compcode, punitcode: punitcode, pbranchcode: pbranchcode, puserid: puserid, pusername: pusername, pdateformat: pdateformat, pextra1: pextra1, pextra2: pextra2, pextra3: pextra3, pextra4: pextra4, pextra5: pextra5 }),
                dataType: "json",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                autoFocus: true,
                success: function (data) {
                    response(data.d);

                },
                error: function (response) {
                    alert(response.responseText);
                },
                failure: function (response) {
                    alert(response.responseText);
                }

            });
        },
        select: function (event, ui) {
            event.preventDefault();
            jq("#txtexecutive").val(ui.item.label.split("~")[0]);
            jq("#hdnexecutive").val(ui.item.label.split("~")[1]);

        },
        minLength: 1
    });

});
//smart search end