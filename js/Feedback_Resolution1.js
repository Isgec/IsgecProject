//javascript
var browser = navigator.appName;
var jq = jQuery.noConflict();
//for users

jq(document).ready(function () {
    jq("#txtuser").autocomplete({
        source: function (request, response) {

            var compcode = document.getElementById('hdncompcode').value
            var locid = document.getElementById('hdnloc').value
            var extra1 = document.getElementById('txtuser').value;
            var extra2 = "";
            var extra3 = "";

            jq.ajax({
                url: "feedback_resolution.aspx/bindusers",
                data: JSON.stringify({ compcode: compcode, locid: locid, extra1: extra1, extra2: extra2, extra3: extra3 }),
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
            jq("#txtuser").val(ui.item.label.split("~")[0]);


           jq("#hdnassignedto").val(ui.item.label.split("~")[1]);
        },
        minLength: 1 //This is the Char length of inputTextBox  
    });

});




function data_grid1() {

    var compcode = document.getElementById("hdncompcode").value;
    var userid = document.getElementById("hdnuser_id").value;
    var dateformat = "dd/mm/yyyy";//document.getElementById("hdndateformate").value;
    var unitcode = "";
    var IndexValue = document.getElementById("drpstatus").selectedIndex;
    var status = document.getElementById("drpstatus").options[IndexValue].value;
    
    var status1 = document.getElementById("drpstatus").value;
    if (status1 == "0") {
        status1 = "";
    }
    var assignedto = document.getElementById("txtuser").value;
    var compl_desc = "";
    var compl_type = "";
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
    var ds = "";
    var remark = "";
    ds =  Feedback_Resolution.binddata(compcode, unitcode, status, compl_desc, compl_type, userid, dateformat, extra1, extra2, extra3, extra4, extra5, extra6, extra7, extra8, extra9, extra10)
    var i = 0;

   

    if (ds.value.Tables.length > 0) {
        if (ds.value.Tables[0].Rows.length > 0) {            
            var str = "";
            str += "<table id='table_data' runat='server' class='table table-bordered table-hover' style=width:100%;>";
            str += "<thead>"
            str += "<tr style='background-color:#2596c8;'>";          
            str += "<td style='text-align:center;width: 80px;padding:0px;'>" + "ID" + "</td>";
            str += "<td style='text-align:center;width: 200px;padding:0px;'>" + "TYPE" + "</td>";
            str += "<td style='text-align:center;width: 100px;padding:0px;;'>" + "DATE" + "</td>";
            str += "<td style='text-align:center;padding:0px;'>" + "DESCRIPTION" + "</td>";
            str += "<td style='text-align:center;padding:0px;'>" + "STATUS" + "</td>";           
            str += "<td style='text-align:center;padding:0px;'>" + "ASSIGNED" + "</td>";
            str += "<td style='text-align:left;padding:0px;'>" + "REMARK" + "</td>";           
            str += "</tr>";
            str += "</thead>"
            str += "<tbody>"
            for (i = 0; i < ds.value.Tables[0].Rows.length; i++) {

                str += "<tr>";
                str += "<td style='text-align:left; font-size: small;'  id=compid_" + i + " onclick='javascript:return compl_id(this.id);'>" + ds.value.Tables[0].Rows[i].COMPL_ID + "</td>";
                str += "<td id='comptype_" + i + "' style='text-align:left; font-size: small;padding:0px;'>" + ds.value.Tables[0].Rows[i].COMPL_TYPE_NAME + "</td>";
                str += "<td id='compdesc_" + i + "' style='text-align:left; font-size: small;padding:0px;'>" + ds.value.Tables[0].Rows[i].COMPL_DT + "</td>";
                str += "<td id='compdate_" + i + "' style='text-align:left; font-size: small;padding:0px;'>" + ds.value.Tables[0].Rows[i].COMPL_DESC + "</td>";
                str += "<td id='compstatus_" + i + "' style='text-align:left; font-size: small;padding:0px;'>" + ds.value.Tables[0].Rows[i].COMPL_STATUS + "</td>";               
                str += "<td id='assignedto_" + i + "' style='text-align:left; font-size: small;padding:0px;'>" + ds.value.Tables[0].Rows[i].ASSIGNTO_NAME + "</td>";               
                str += "<td id='remark" + i + "' style='text-align:left; font-size: small;padding:0px;'>" + ds.value.Tables[0].Rows[i].COMPL_LAST_REMARK + "</td>";              

                str += "<td    style='border:0px solid #7DAAE3; width 20px'  align='left' >"
                str += "<Button  id=as_action_" + i + " style='width:20px;background-color: #7DAAE3' align='left' AutoPostBack='true' onClick='javascript:return assignbook(id);' >A</Button>"
                str += "</td>"
             
                str += "</tr>";              
            }
            str += "</tbody>"
            str += "</table >"
        }
      
        document.getElementById("gridview_data").innerHTML = str;
        document.getElementById("gridview_data").style.display = "block";
        return false;
        //if (ds.value.Tables[0].Rows.length > 0) {
        //    document.getElementById("assigntotd").value = assignedto;//Now you get the js variable inside your form
        //}
    } 
    return false;
}

function compl_id(id) {
    var dd = id.split('_')
    var index = dd[1];
    var PCOMP_CODE = "";
    var complainid = document.getElementById("compid_" + index).innerHTML;
    var schemeid = "";
    var customercode = "";
    var readerid = "";
    var complfrom = 'A';
    win = window.open('crm_feedback_resolution1.aspx?complainid=' + complainid + '&schemeid=' + schemeid + '&customercode=' + customercode + '&readerid=' + readerid + '&complfrom=' + complfrom + '&id=' + id + '&PCOMP_CODE=' + PCOMP_CODE, '', 'width=1250px,height=400px,resizable=0,left=50px,top=100px, scrollbars=yes');
    win.focus();
    return false;
}


function updatecustomer(id) {
    var dd = id.split('_')
    var index = dd[1];
    var complainid = document.getElementById("compid_" + index).innerHTML;
    var schemeid = "";
    var customercode = "";
    var readerid = "";
    var complfrom = 'S';
    win = window.open('crm_feedback_resolution1.aspx?complainid=' + complainid + '&schemeid=' + schemeid + '&customercode=' + customercode + '&readerid=' + readerid + '&complfrom=' + complfrom + '&id=' + id, '', 'width=1250px,height=400px,resizable=1,left=50px,top=100px, scrollbars=yes');
    win.focus();
    return false;
}


function onpageload() {
    var PCOMP_CODE = document.getElementById('hdncompcode').value;
    var PLOCATION_CODE = document.getElementById('hdnloc').value;
    var PSCH_ID = document.getElementById('hiddenschemeid').value;
    var PCUSTID = document.getElementById('hiddencustomerid').value;
    var PCOMPLID = document.getElementById('hiddencomplainid').value;
    var PEXTRA1 = "";
    var PEXTRA2 = "";
    var PEXTRA3 = "";
    var PEXTRA4 = "";
    var PEXTRA5 = "";
    var complain_from = document.getElementById('hiddencompl_from').value;

    var res = crm_feedback_resolution1.getcompltails(PCOMP_CODE, PLOCATION_CODE, PSCH_ID, PCUSTID, PCOMPLID, PEXTRA1, PEXTRA2, PEXTRA3, PEXTRA4, PEXTRA5, complain_from);
    callback_grid123(res)
    if ($('hidden1').value.substring(0, 3) == "act") {
      //  Clock()
    }
    else if ($('hidden1').value.substring(0, 6) == "as_act") {
        //Clock1()
    }
    return false;
}

//function Clock() {
//    setInterval("displaytime()", 1000);
//}

function assignbook(id) {
    var dd = id.split('_')
    var index = dd[2];
    var complainid = document.getElementById("compid_" + index).innerHTML;
    var schemeid = "";
    var customercode = "";
    var readerid = "";
    var complfrom = 'A';
    win = window.open('crm_feedback_resolution1.aspx?complainid=' + complainid + '&schemeid=' + schemeid + '&complfrom=' + complfrom + '&customercode=' + customercode + '&readerid=' + readerid + '&id=' + id, '', 'width=1250px,height=400px,resizable=1,left=50px,top=100px, scrollbars=yes');
    win.focus();
    return false;
}

function callback_grid123(res) {
    if ($('hidden1').value.substring(0, 3) == "act") {
        document.getElementById('Button4').style.display = "block";
    }
    else if ($('hidden1').value.substring(0, 6) == "as_act") {
        document.getElementById('Button4').style.display = "block";
    }
    else {
    }
    var ds = res.value;
    document.getElementById('hiddenlength123').value = ds.Tables[0].Rows.length;
    $('hdsviewgrid').innerHTML = "";

    $('hdsviewgrid').style.display = "block";
    $('dv_grid').style.display = "block";
    $('tbl123').style.display = "block";
    if (document.getElementById('hiddencompl_from').value == 'S') {
        if (ds != null && ds.Tables[0].Rows.length > 0) {
            var hdsview = "";
            hdsview += "<table width='800px'; style='border:1px; solid #7DAAE3;margin-top:0px;margin-bottom:1px;margin-left:60px;' cellpadding='0' border='0'cellspacing='0'>"

            hdsview += "<tr>";
            //==============================
            hdsview += "<td  width='100px' class='grid2' bgcolor=#7DAAE3 style='height:5px;font-size:13px;font-weight:bold;text-align:center;border:0px solid #ffffff;cursor:hand;font-size:14px;font-family:Verdana;vertical-align:top;'>Description</td>";
            hdsview += "<td  width='100px' class='grid2' bgcolor=#7DAAE3 style='height:5px;font-size:13px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:14px;font-family:Verdana;vertical-align:top;'>Status Remark</td>";
            hdsview += "<td  width='100px' class='grid2' bgcolor=#7DAAE3 style='height:5px;font-size:13px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:14px;font-family:Verdana;vertical-align:top;'>Status</td>";
            hdsview += "<td  width='100px' class='grid2' bgcolor=#7DAAE3 style='height:5px;font-size:13px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:14px;font-family:Verdana;vertical-align:top;'>Created By</td>";
            hdsview += "<td  width='100px' class='grid2'   bgcolor=#7DAAE3 style='height:5px;font-size:13px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:14px;font-family:Verdana;vertical-align:top;'>Status Changed By</td>";
            hdsview += "<td  width='100px' class='grid2'   bgcolor=#7DAAE3 style='height:5px;font-size:13px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:14px;font-family:Verdana;vertical-align:top;'>Status Changed Date</td>";
            hdsview += "<td  width='100px'  class='grid2'  bgcolor=#7DAAE3 style='height:5px;font-size:13px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:14px;font-family:Verdana;vertical-align:top;'>Subject</td>";

            //==============================
            hdsview += "</tr>";
            var i = 0;
            for (i = 0; i < ds.Tables[0].Rows.length; i++) {

                hdsview += "<tr id=rowid_" + i + " >";

                //===================================================
                hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                hdsview += "<input type='textbox' id=sch_" + i + "  disabled   style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_DESC + "' title='" + ds.Tables[0].Rows[i].COMPL_DESC + "' >"
                hdsview += "</td>"

                hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                hdsview += "<input type='textbox' id=sch_" + i + "  disabled   style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_STATUS_REMARK + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_REMARK + "' >"
                hdsview += "</td>"

                //if (ds.Tables[0].Rows[0].COMPL_STATUS_REMARK != null) {
                //    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                //    hdsview += "<input type='textbox'id=ascompltype_" + i + "  disabled style='width:90px;border:0px; background-color:#FFFFFF ;text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[0].COMPL_STATUS_REMARK + "'  title='" + ds.Tables[0].Rows[0].COMPL_STATUS_REMARK + "'>"
                //    hdsview += "</td>"
                //}
                //else {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascomplstatus_" + i + "  style='width:75px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' onkeydown=\"return bindcomplstatus(event,this.id);\" >"
                    hdsview += "</td>"
                //}

                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asassignto_" + i + "  style='width:90px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' onkeydown=\"return bindassignto(event,this.id);\">"
                    hdsview += "</td>"

                //hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                //hdsview += "<input type='textbox' id=sch_" + i + "     style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_STATUS_CREATED_BY_NAME + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_CREATED_BY_NAME + "' >"
                //hdsview += "</td>"

                hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                hdsview += "<input type='textbox' id=sch_" + i + "     style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_BY_NAME + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_BY_NAME + "' >"
                hdsview += "</td>"

                if (ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT != null) {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=complstatuschangeddate_" + i + " disabled style='width:90px;border:0px; background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + date_fun(ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT) + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT + "'>"
                    hdsview += "</td>"
                }
                else {

                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=complstatuschangeddate_" + i + " disabled style='width:90px;border:0px; background-color:#f3f6fd;text-align:left;font-size:9px;font-family:Verdana;' >"
                    hdsview += "</td>"
                }

                hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                hdsview += "<input type='textbox' id=sch_" + i + "     style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPLAINT_SUBJECT + "' title='" + ds.Tables[0].Rows[i].COMPLAINT_SUBJECT + "' >"
                hdsview += "</td>"
                hdsview += "</tr>"

                if ($('hidden1').value.substring(0, 3) == "act") {
                    hdsview += "<tr id=rowid_" + i + " >";
                    //===================================================
                    hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                    hdsview += "<input type='textbox' id=sch_" + i + "     style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_DESC + "' title='" + ds.Tables[0].Rows[i].COMPL_DESC + "' >"
                    hdsview += "</td>"

                    hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                    hdsview += "<input type='textbox' id=sch_" + i + "     style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_STATUS_REMARK + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_REMARK + "' >"
                    hdsview += "</td>"


                    if (ds.Tables[0].Rows[0].COMPL_STATUS_REMARK != null) {
                        hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                        hdsview += "<input type='textbox'id=ascompltype_" + i + "   style='width:90px;border:0px; background-color:#FFFFFF ;text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[0].COMPL_STATUS_REMARK + "'  title='" + ds.Tables[0].Rows[0].COMPL_STATUS_REMARK + "'>"
                        hdsview += "</td>"
                    }
                    else {
                        hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                        hdsview += "<input type='textbox'id=ascomplstatus_" + i + "  style='width:75px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' onkeydown=\"return bindcomplstatus(event,this.id);\" >"
                        hdsview += "</td>"
                    }

                    hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                    hdsview += "<input type='textbox' id=sch_" + i + "     style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_STATUS_CREATED_BY_NAME + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_CREATED_BY_NAME + "' >"
                    hdsview += "</td>"

                    hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                    hdsview += "<input type='textbox' id=sch_" + i + "     style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_BY_NAME + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_BY_NAME + "' >"
                    hdsview += "</td>"

                    if (ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT != null) {
                        hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_reportNEW' >"
                        hdsview += "<input type='textbox'id=complstatuschangeddate_" + i + " disabled style='width:90px;border:0px; background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + date_fun(ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT) + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT + "'>"
                        hdsview += "</td>"
                    }
                    else {

                        hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_reportNEW' >"
                        hdsview += "<input type='textbox'id=complstatuschangeddate_" + i + " disabled style='width:90px;border:0px; background-color:#f3f6fd;text-align:left;font-size:9px;font-family:Verdana;' >"
                        hdsview += "</td>"
                    }

                    hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                    hdsview += "<input type='textbox' id=sch_" + i + "     style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPLAINT_SUBJECT + "' title='" + ds.Tables[0].Rows[i].COMPLAINT_SUBJECT + "' >"
                    hdsview += "</td>"

                    hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asvassintocode_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' >"
                    hdsview += "</td>"

                    hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asvstatuscode_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' >"
                    hdsview += "</td>"

                    hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asvcompltype_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' >"
                    hdsview += "</td>"

                    hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=vcompltype_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' >"
                    hdsview += "</td>"

                    hdsview += "</tr>"
                }
            }
            hdsview += "</table>";
            $('hdsviewgrid').innerHTML = hdsview;
            return false;
        }
    }
    if (document.getElementById('hiddencompl_from').value == 'A') {
        if (ds != null && ds.Tables[0].Rows.length > 0) {
           

            var hdsview = "";
            hdsview += "<table width='800px'; style='border:1px; solid #7DAAE3;margin-top:0px;margin-bottom:1px;margin-left:60px;' cellpadding='0' border='0'cellspacing='0'>"

            hdsview += "<tr>";
            //==============================
            hdsview += "<td  width='100px' class='grid2' bgcolor=#7DAAE3 style='height:5px;font-size:13px;font-weight:bold;text-align:center;border:0px solid #ffffff;cursor:hand;font-size:14px;font-family:Verdana;vertical-align:top;'>Description</td>";
            hdsview += "<td  width='100px' class='grid2' bgcolor=#7DAAE3 style='height:5px;font-size:13px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:14px;font-family:Verdana;vertical-align:top;'>Status Remark</td>";
            hdsview += "<td  width='100px' class='grid2' bgcolor=#7DAAE3 style='height:5px;font-size:13px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:14px;font-family:Verdana;vertical-align:top;'>Status</td>";
            hdsview += "<td  width='100px' class='grid2' bgcolor=#7DAAE3 style='height:5px;font-size:13px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:14px;font-family:Verdana;vertical-align:top;'>Created By</td>";
            hdsview += "<td  width='100px' class='grid2'   bgcolor=#7DAAE3 style='height:5px;font-size:13px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:14px;font-family:Verdana;vertical-align:top;'>Status Changed By</td>";
            hdsview += "<td  width='100px' class='grid2'   bgcolor=#7DAAE3 style='height:5px;font-size:13px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:14px;font-family:Verdana;vertical-align:top;'>Status Changed Date</td>";
            hdsview += "<td  width='100px'  class='grid2'  bgcolor=#7DAAE3 style='height:5px;font-size:13px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:14px;font-family:Verdana;vertical-align:top;'>Subject</td>";

            //==============================
            hdsview += "</tr>";
            var i = 0;
            for (i = 0; i < ds.Tables[0].Rows.length; i++) {

                hdsview += "<tr id=rowid_" + i + " >";

                //===================================================
                hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                hdsview += "<input type='textbox' id=sch_" + i + "  disabled   style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_DESC + "' title='" + ds.Tables[0].Rows[i].COMPL_DESC + "' >"
                hdsview += "</td>"

                hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                hdsview += "<input type='textbox' id=sch_" + i + "  disabled   style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_STATUS_REMARK + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_REMARK + "' >"
                hdsview += "</td>"

                //if (ds.Tables[0].Rows[0].COMPL_STATUS_REMARK != null) {
                //    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                //    hdsview += "<input type='textbox'id=ascompltype_" + i + "  disabled style='width:90px;border:0px; background-color:#FFFFFF ;text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[0].COMPL_STATUS_REMARK + "'  title='" + ds.Tables[0].Rows[0].COMPL_STATUS_REMARK + "'>"
                //    hdsview += "</td>"
                //}
                //else {
                hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=ascomplstatus_" + i + "  style='width:75px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' onkeydown=\"return bindcomplstatus(event,this.id);\" >"
                hdsview += "</td>"
                //}

                hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=asassignto_" + i + "  style='width:90px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' onkeydown=\"return bindassignto(event,this.id);\">"
                hdsview += "</td>"

                hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=complstatuschangedby_" + i + " disabled style='width:90px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' value='" + document.getElementById('hidnUsername').value + "' title='" + document.getElementById('hidnUsername').value + "'>"
                    hdsview += "</td>"

                hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                hdsview += "<input type='textbox' id=sch_" + i + "     style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_BY_NAME + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_BY_NAME + "' >"
                hdsview += "</td>"

                if (ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT != null) {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=complstatuschangeddate_" + i + " disabled style='width:90px;border:0px; background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + date_fun(ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT) + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT + "'>"
                    hdsview += "</td>"
                }
                else {

                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=complstatuschangeddate_" + i + " disabled style='width:90px;border:0px; background-color:#f3f6fd;text-align:left;font-size:9px;font-family:Verdana;' >"
                    hdsview += "</td>"
                }

                hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                hdsview += "<input type='textbox' id=sch_" + i + "     style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPLAINT_SUBJECT + "' title='" + ds.Tables[0].Rows[i].COMPLAINT_SUBJECT + "' >"
                hdsview += "</td>"
                hdsview += "</tr>"

                if ($('hidden1').value.substring(0, 6) == "as_act") {
                    hdsview += "<tr id=rowid_" + i + " >";
                    //===================================================
                    hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                    hdsview += "<input type='textbox' id=sch_" + i + "     style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_DESC + "' title='" + ds.Tables[0].Rows[i].COMPL_DESC + "' >"
                    hdsview += "</td>"

                    hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                    hdsview += "<input type='textbox' id=sch_" + i + "     style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_STATUS_REMARK + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_REMARK + "' >"
                    hdsview += "</td>"


                    if (ds.Tables[0].Rows[0].COMPL_STATUS_REMARK != null) {
                        hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                        hdsview += "<input type='textbox'id=ascompltype_" + i + "   style='width:90px;border:0px; background-color:#FFFFFF ;text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[0].COMPL_STATUS_REMARK + "'  title='" + ds.Tables[0].Rows[0].COMPL_STATUS_REMARK + "'>"
                        hdsview += "</td>"
                    }
                    else {
                        hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                        hdsview += "<input type='textbox'id=ascomplstatus_" + i + "  style='width:75px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' onkeydown=\"return bindcomplstatus(event,this.id);\" >"
                        hdsview += "</td>"
                    }

                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                        hdsview += "<input type='textbox'id=complstatuschangedby_" + i + " disabled style='width:90px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' value='" + document.getElementById('hidnUsername').value + "' title='" + document.getElementById('hidnUsername').value + "'>"
                        hdsview += "</td>"

                    hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                    hdsview += "<input type='textbox' id=sch_" + i + "     style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_BY_NAME + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_BY_NAME + "' >"
                    hdsview += "</td>"

                    if (ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT != null) {
                        hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_reportNEW' >"
                        hdsview += "<input type='textbox'id=complstatuschangeddate_" + i + " disabled style='width:90px;border:0px; background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + date_fun(ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT) + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT + "'>"
                        hdsview += "</td>"
                    }
                    else {

                        hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_reportNEW' >"
                        hdsview += "<input type='textbox'id=complstatuschangeddate_" + i + " disabled style='width:90px;border:0px; background-color:#f3f6fd;text-align:left;font-size:9px;font-family:Verdana;' >"
                        hdsview += "</td>"
                    }

                    hdsview += "<td   align='center' style='border:1px solid #7DAAE3;width:100px;'   class='Grid_reportNEW''>"
                    hdsview += "<input type='textbox' id=sch_" + i + "     style='width:90px;border:0px;background-color:#f3f6fd;text-align:left;font-size:12px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPLAINT_SUBJECT + "' title='" + ds.Tables[0].Rows[i].COMPLAINT_SUBJECT + "' >"
                    hdsview += "</td>"

                    hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asvassintocode_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' >"
                    hdsview += "</td>"

                    hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asvstatuscode_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' >"
                    hdsview += "</td>"

                    hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asvcompltype_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' >"
                    hdsview += "</td>"

                    hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=vcompltype_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' >"
                    hdsview += "</td>"

                    hdsview += "</tr>"
                }
                hdsview += "</table>";
                $('hdsviewgrid').innerHTML = hdsview;
                return false;
            }
        }
    }
    return false;
}



function date_fun(str_date) {
    var final_date = new Date(str_date);

    if (final_date != "" && final_date != null) {
        var month = final_date.getMonth() + 1
        var day = final_date.getDate()
        var year = final_date.getFullYear()

        if (day.toString().length < 2)
            day = "0" + day

        if (month.toString().length < 2)
            month = "0" + month

        if ($('hiddendateformat').value == "dd/mm/yyyy")
            final_date = day + "/" + month + "/" + year;

        else if ($('hiddendateformat').value == "mm/dd/yyyy")
            final_date = month + "/" + day + "/" + year;

        else if ($('hiddendateformat').value == "yyyy/mm/dd")
            final_date = year + "/" + month + "/" + day;
    }
    if (final_date == "01/01/1900") {
        return "";
    }
    else {
        return final_date;
    }
}

function fndnull(myval) {
    if (myval == "undefined") {
        myval = "";
    }
    else if (myval == null) {
        myval = "";
    }
    return myval
}

function winclose() {
    window.close()
    return false;
}


function inscompldet(event) {
    for (var i = document.getElementById('hiddenlength123').value; i <= parseInt(document.getElementById('hiddenlength123').value) ; i++) {
        var COMP_CODE = document.getElementById('hdncompcode').value;
        var LOC_ID = document.getElementById('hdnloc').value
        var SCHEME_ID = "AU"
        var SCHEME_OPT = document.getElementById('hiddenschemeid').value
        var COMPL_ID = document.getElementById('hiddencomplainid').value
        var COMPL_DT = "";
        if (document.getElementById('hiddencompl_from').value == 'S') {
            var COMPL_TYPE = document.getElementById('cmptype_' + i).value
        }
        else if (document.getElementById('hiddencompl_from').value == 'A') {
            //var COMPL_TYPE = document.getElementById('ascmptype_' + i).value
            var COMPL_TYPE = "";
        }
        if (document.getElementById('hiddencompl_from').value == 'C') {
        }
        var R_ID = document.getElementById('hiddenreaderid').value

        if (document.getElementById('hiddencompl_from').value == 'S') {
            var CUST_ID = document.getElementById('vcustcode_' + i).value
        }
        else if (document.getElementById('hiddencompl_from').value == 'A') {
            var CUST_ID = "";
        }
        else if (document.getElementById('hiddencompl_from').value == 'C') {
        }
        var DPCD = ""
        var AGCD = "";
        var BRANCH = ""
        var resss = crm_feedback_resolution1.generatetranid(COMP_CODE, LOC_ID, SCHEME_OPT, COMPL_ID, "", "", "", "");

        var COMPL_TRN_ID = resss.value.Tables[0].Rows[0].v_tran_code;
        if (document.getElementById('hiddencompl_from').value == 'S') {
            var COMPL_DESC = document.getElementById('compldesc_' + i).value
        }
        else if (document.getElementById('hiddencompl_from').value == 'A') {
            var COMPL_DESC = document.getElementById('ascompldesc_' + i).value
        }
        else if (document.getElementById('hiddencompl_from').value == 'C') {
            //var COMPL_DESC = document.getElementById('compldesc_' + i).value
        }
        if (document.getElementById('hiddencompl_from').value == 'S') {
            var MODE_OF_COMPL = document.getElementById('vcomode_' + i).value
        }
        else if (document.getElementById('hiddencompl_from').value == 'A') {
            var MODE_OF_COMPL = "";
        }
        else if (document.getElementById('hiddencompl_from').value == 'C') {
            //var MODE_OF_COMPL = document.getElementById('vcomode_' + i).value 
        }
        var COMPL_FROM = document.getElementById('hiddencompl_from').value

        if (document.getElementById('hiddencompl_from').value == 'S') {
            var COMPL_STATUS = document.getElementById('vstatuscode_' + i).value
        }
        else if (document.getElementById('hiddencompl_from').value == 'A') {
            var COMPL_STATUS = document.getElementById('asvstatuscode_' + i).value
        }
        else if (document.getElementById('hiddencompl_from').value == 'C') {
            //var COMPL_STATUS = document.getElementById('vstatuscode_' + i).value
        }
        if (document.getElementById('hiddencompl_from').value == 'S') {
            var COMPL_STATUS_REMARK = document.getElementById('complstatusremark_' + i).value.toUpperCase()
        }
        else if (document.getElementById('hiddencompl_from').value == 'A') {
            var COMPL_STATUS_REMARK = document.getElementById('ascomplstatusremark_' + i).value.toUpperCase()
        }
        else if (document.getElementById('hiddencompl_from').value == 'C') {
        }
        var COMPL_STATUS_CHANGED_BY = document.getElementById('hiddenuserid').value
        var COMPL_STATUS_CHANGED_DT = ""
        var CREATED_BY = document.getElementById('hiddenuserid').value
        var CREATED_DATE = ""
        var UPDATED_BY = ""
        var UPDATED_DATE = ""

        if (document.getElementById('hiddencompl_from').value == 'S') {
            var ASSIGN_TO = document.getElementById('vassintocode_' + i).value
        }
        else if (document.getElementById('hiddencompl_from').value == 'A') {
            var ASSIGN_TO = document.getElementById('asvassintocode_' + i).value
        }
        else if (document.getElementById('hiddencompl_from').value == 'C') {
            //var ASSIGN_TO = document.getElementById('vassintocode_' + i).value
        }
        if (document.getElementById('hiddencompl_from').value == 'S') {
            var EXTRA1 = document.getElementById('currenttime_' + i).value
        }
        else if (document.getElementById('hiddencompl_from').value == 'A') {
            var EXTRA1 = "";
        }
        else if (document.getElementById('hiddencompl_from').value == 'C') {
        }
        if (document.getElementById('hiddencompl_from').value == 'S') {
            var EXTRA2 = document.getElementById('noofhours_' + i).value
        }
        else if (document.getElementById('hiddencompl_from').value == 'A') {
            var EXTRA2 = "";
        }
        else if (document.getElementById('hiddencompl_from').value == 'C') {
        }
        if (document.getElementById('hiddencompl_from').value == 'S') {
            var EXTRA3 = "";
        }
        else if (document.getElementById('hiddencompl_from').value == 'A') {
            var EXTRA3 = "";
        }
        else if (document.getElementById('hiddencompl_from').value == 'C') {            
        }

        if (ASSIGN_TO == "" && COMPL_STATUS == "") {

            alert("Plesse fill Assign To or Complaint Status By Pressing F2 key!");
            return false;
        }
        crm_feedback_resolution1.insertdetailincomplain(COMP_CODE, COMPL_TRN_ID, LOC_ID, SCHEME_ID, SCHEME_OPT, COMPL_ID, COMPL_DT, COMPL_TYPE, R_ID, CUST_ID, DPCD, AGCD, BRANCH, COMPL_DESC, MODE_OF_COMPL, COMPL_FROM, COMPL_STATUS, COMPL_STATUS_REMARK, COMPL_STATUS_CHANGED_BY, COMPL_STATUS_CHANGED_DT, CREATED_BY, CREATED_DATE, UPDATED_BY, UPDATED_DATE, ASSIGN_TO, EXTRA1, EXTRA2, EXTRA3);
        if (document.getElementById('chkbox1').checked == true) {
            var re156 = crm_feedback_resolution1.getlogindetails($('hdncompcode').value, document.getElementById('vassintocode_' + i).value);
            var mailid = re156.value.Tables[1].Rows[0]["EMAIL"]
           
            var message = document.getElementById('hiddenmessage111').value           
            if (mailid != "") {
                crm_feedback_resolution1.send_mail(message, mailid);
            }
        }
        if (document.getElementById('chkbox2').checked == true) {
            var message = document.getElementById('hiddenmessage111').value
            var re156 = crm_feedback_resolution1.getlogindetails($('hdncompcode').value, document.getElementById('vassintocode_' + i).value);
            var number = re156.value.Tables[1].Rows[0]["MOBILENO"]
            if (re156.value.Tables[1].Rows[0]["MOBILENO"] != null) {
                number = "91" + number;
                crm_feedback_resolution1.SendSMS(number, message);
            }
        }
        alert("Data Updated Successfully");
        window.close();
        return false;
    }
}

function tabvalue145(event) {
    var iid = document.activeElement.id;
    if (browser != "Microsoft Internet Explorer") {
        var key = event.which;
    }
    else {
        var key = event.keyCode;
    }

    if (key == 13) {        
        if (document.activeElement.type == "button" || document.activeElement.type == "submit" || document.activeElement.type == "image") {
            event.keyCode = 13;
            return event.keyCode;
        }
        else {
            event.keyCode = 9;
            return event.keyCode;
        }
    }
}

function bindcomplstatus(event, id) {
    var divid = "divstatus";
    var listboxid = "lststatus";
    document.getElementById('hiddenactiveid').value = id;
    activeid = document.getElementById('hiddenactiveid').value;
    if (browser != "Microsoft Internet Explorer") {
        var key = event.which;
    }
    else {
        var key = event.keyCode;
    }
    if (key == 113) {
        var extra1 = "";
        var extra2 = $('hdncompcode').value;
        var locid = $('hdnloc').value;
        var Rtype = "CST";
        document.getElementById("divstatus").style.display = "block";       
        document.getElementById('lststatus').value = "0";
        document.getElementById('lststatus').focus();

        var ds = crm_feedback_resolution1.bindpaymode(locid, Rtype, extra1, extra2);
        if (ds == null) {
            return false;
        }
        var objadscat = document.getElementById(listboxid);
        objadscat.options.length = 0;
        objadscat.style.width = "254px"
        objadscat.options[0] = new Option("-Select Status-", "0");
        objadscat.options.length = 1;
        for (var i = 0; i < ds.value.Tables[0].Rows.length; ++i) {
            if ($('hiddenconnection1').value == "orcl") {
                objadscat.options[objadscat.options.length] = new Option(ds.value.Tables[0].Rows[i].REASON + "--" + ds.value.Tables[0].Rows[i].RES_ID, ds.value.Tables[0].Rows[i].RES_ID);
            }
            else {
                objadscat.options[objadscat.options.length] = new Option(ds.value.Tables[0].Rows[i].reason + "--" + ds.value.Tables[0].Rows[i].res_id, ds.value.Tables[0].Rows[i].res_id);
            }
            objadscat.options.length;
        }
        aTag = eval(document.getElementById(id))
        var btag;      
        var leftpos = 0;
        var toppos = 0;
        do {
            aTag = eval(aTag.offsetParent);
            leftpos += aTag.offsetLeft;
            toppos += aTag.offsetTop;
            btag = eval(aTag)
        } while (aTag.tagName != "BODY" && aTag.tagName != "HTML");
        var tot = document.getElementById('divstatus').scrollLeft;
        var scrolltop = document.getElementById('divstatus').scrollTop;
        document.getElementById(divid).style.left = document.getElementById(activeid).offsetLeft + leftpos - tot + "px";
        document.getElementById(divid).style.top = document.getElementById(activeid).offsetTop + toppos - scrolltop + "px"; //"510px";       
        document.getElementById(divid).style.display = "block";
        document.getElementById(listboxid).focus();

    }

    else if (key == 8) {
        $(id).value = "";
        $(id).focus();
        return false;
    }

    return false;
}
function fillcomplstatus(event) {

    var kk = document.getElementById('hiddenactiveid').value.split('_')
    var index = kk[1];
    var keycode = event.keyCode ? event.keyCode : event.which;
    if (keycode == 13 || event.type == "click") {
        if (document.activeElement.id == "lststatus") {
            if (document.getElementById('lststatus').value == "0") {
                alert("Please select Complain Status");
                return false;
            }
            document.getElementById("divstatus").style.display = "none";
            var page = document.getElementById('lststatus').value;
            loccode = page;

            for (var k = 0; k <= document.getElementById("lststatus").length - 1; k++) {
                if (document.getElementById('lststatus').options[k].value == page) {
                    if (browser != "Microsoft Internet Explorer") {
                        var abc = document.getElementById('lststatus').options[k].textContent;
                    }
                    else {
                        var abc = document.getElementById('lststatus').options[k].innerText;
                    }
                    var splitpub = abc;
                    var str = splitpub.split("--");
                    var pubname = str[0];
                    var pubspace = str[1];
                    $(document.getElementById('hiddenactiveid').value).value = pubname;
                    document.getElementById('hiddenactiveid').value = pubname;
                    if (document.getElementById('hiddencompl_from').value == 'S') {
                        //document.getElementById('vstatuscode_' + index).value = pubspace;
                    }
                    else if (document.getElementById('hiddencompl_from').value == 'A') {

                        //document.getElementById('asvstatuscode_' + index).value = pubspace;
                    }
                    else if (document.getElementById('hiddencompl_from').value == 'C') {
                    }

                    break;
                }
            }
            if (document.getElementById('hiddencompl_from').value == 'S') {
               // document.getElementById('complstatus_' + index).focus();
            }
            else if (document.getElementById('hiddencompl_from').value == 'A') {
                document.getElementById('ascomplstatus_' + index).focus();
            }
            else if (document.getElementById('hiddencompl_from').value == 'C') {
                //document.getElementById('complstatus_' + index).focus();
            }
            document.getElementById("divstatus").style.display = 'none';
            return false;
        }
    }
    else if (keycode == 27) {
        document.getElementById("divstatus").style.display = "none";
        if (document.getElementById('hiddencompl_from').value == 'S') {
            document.getElementById('complstatus_' + index).focus();
        }
        else if (document.getElementById('hiddencompl_from').value == 'A') {
            document.getElementById('ascomplstatus_' + index).focus();
        }
        else if (document.getElementById('hiddencompl_from').value == 'C') {
            //document.getElementById('complstatus_' + index).focus();
        }
        //document.getElementById('complstatus_' + index).focus();
        return false;
    }
}

function callbackstatus(res) {
    ds = res.value;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        var pkgitem = document.getElementById("lststatus");
        pkgitem.options.length = 0;
        pkgitem.options[0] = new Option("-Select Status-", "0");

        for (var i = 0; i < ds.Tables[0].Rows.length; ++i) {
            if ($('hiddenconnection1').value == "orcl") {
                pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].REASON + "--" + ds.Tables[0].Rows[i].RES_ID, ds.Tables[0].Rows[i].RES_ID);

            }
            else {
                pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].reason + "--" + ds.Tables[0].Rows[i].res_id, ds.Tables[0].Rows[i].res_id);

            }
        }
    }
  
    return false;
}

function bindassignto(event, id) {
    document.getElementById('hiddenactiveid').value = id;
    if (browser != "Microsoft Internet Explorer") {
        var key = event.which;
    }
    else {
        var key = event.keyCode;
    }
    var kk = id.split('_')
    var index = kk[1];
    if (key == 113) {
        var compcode = document.getElementById('hdncompcode').value
        var locid = document.getElementById('hdnloc').value
        if (document.getElementById('hiddencompl_from').value == 'S') {
            var extra1 = "";
        }
       
       else if (document.getElementById('hiddencompl_from').value == 'A') {
        var extra1 = "";
           // var extra1 = document.getElementById('asvcompltype_' + parseInt(parseInt(index) - parseInt(1))).value
        }
        else if (document.getElementById('hiddencompl_from').value == 'C') {           
        }
        if (document.getElementById('hiddencompl_from').value == 'S') {
            var extra2 = "";
        }
        else if (document.getElementById('hiddencompl_from').value == 'A') {
            var extra2 = document.getElementById('asvstatuscode_' + index).value
        }
        else if (document.getElementById('hiddencompl_from').value == 'C') {
            var extra2
        }
        var extra3 = ""
        document.getElementById("divassignto").style.display = "block";
        document.getElementById('divassignto').style.top = findPos($(document.getElementById('hiddenactiveid').value), "top");
        document.getElementById('divassignto').style.left = findPos($(document.getElementById('hiddenactiveid').value), "left");
        document.getElementById('lstassignto').value = "0";
        document.getElementById('lstassignto').focus();
        crm_feedback_resolution1.fillassignto(compcode, locid, extra1, extra2, extra3, callbackassignto);
        return false;
            }
}


function callbackassignto(res) {
    ds = res.value;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        var pkgitem = document.getElementById("lstassignto");
        pkgitem.options.length = 0;
        pkgitem.options[0] = new Option("-Select Assign To-", "0");

        for (var i = 0; i < ds.Tables[0].Rows.length; ++i) {
            if ($('hiddenconnection1').value == "orcl") {
                pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].ASSIGNTO_NAME + "--" + ds.Tables[0].Rows[i].ASSIGNTO_CODE, ds.Tables[0].Rows[i].ASSIGNTO_CODE);

            }
            else {
                pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].ASSIGNTO_NAME + "--" + ds.Tables[0].Rows[i].ASSIGNTO_CODE, ds.Tables[0].Rows[i].ASSIGNTO_CODE);

            }
        }
    }

    return false;
}

function fillassigntopress(event) {
    var kk = document.getElementById('hiddenactiveid').value.split('_')
    var index = kk[1];
    var keycode = event.keyCode ? event.keyCode : event.which;
    if (keycode == 13 || event.type == "click") {
        if (document.activeElement.id == "lstassignto") {
            if (document.getElementById('lstassignto').value == "0") {
                alert("Please select Assign To");
                return false;
            }
            document.getElementById("divassignto").style.display = "none";
            var page = document.getElementById('lstassignto').value;
            loccode = page;
            for (var k = 0; k <= document.getElementById("lstassignto").length - 1; k++) {
                if (document.getElementById('lstassignto').options[k].value == page) {
                    if (browser != "Microsoft Internet Explorer") {
                        var abc = document.getElementById('lstassignto').options[k].textContent;
                    }
                    else {
                        var abc = document.getElementById('lstassignto').options[k].innerText;
                    }
                    var splitpub = abc;
                    var str = splitpub.split("--");
                    var pubname = str[0];
                    var pubspace = str[1];
                    $(document.getElementById('hiddenactiveid').value).value = pubname;
                    document.getElementById('hiddenactiveid').value = pubname;
                    if (document.getElementById('hiddencompl_from').value == 'S') {
                        //document.getElementById('vassintocode_' + index).value = pubspace;
                    }
                    else if (document.getElementById('hiddencompl_from').value == 'A') {
                        document.getElementById('asvassintocode_' + index).value = pubspace;
                    }
                    else if (document.getElementById('hiddencompl_from').value == 'C') {
                        // document.getElementById('vassintocode_' + index).value = pubspace; 
                    }
                    break;
                }
            }
            if (document.getElementById('hiddencompl_from').value == 'S') {
                //document.getElementById('assignto_' + index).focus();
            }
            else if (document.getElementById('hiddencompl_from').value == 'A') {
                document.getElementById('asassignto_' + index).focus();
            }
            else if (document.getElementById('hiddencompl_from').value == 'C') {
            }

            document.getElementById("divassignto").style.display = 'none';
            return false;
        }
    }
    else if (keycode == 27) {
        document.getElementById("divassignto").style.display = "none";
        document.getElementById('assignto_' + index).focus();
        return false;
    }
}


function findPos(obj, val) {
    var curleft = curtop = 0;
    if (obj.offsetParent) {
        curleft = obj.offsetLeft
        curtop = obj.offsetTop
        while (obj = obj.offsetParent) {
            curleft += obj.offsetLeft
            curtop += obj.offsetTop
        }
    }
    curtop = curtop += 5;
    if (val == "top")
        return curtop + "px";
    else
        return curleft + "px";
}