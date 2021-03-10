var browser = navigator.appName;


    function report_complaint() 
    {

            if (document.getElementById('drptype').value == "0") {
                alert("Please Select Type");
                document.getElementById('drptype').focus();
                return false;
            }

            var complaintsummary = "";
            if (browser != "Microsoft Internet Explorer") 
            {
                complaintsummary = document.getElementById('txtcomplaintsubject').textContent;
            }
            else 
            {
                complaintsummary = document.getElementById('txtcomplaintsubject').innerText;
            }
            if(complaintsummary =="")
            {
                alert("Please Enter Subject");
                return false;
            }
            
            var complaintdesciption = "";
            if (browser != "Microsoft Internet Explorer") 
            {
                complaintdesciption = document.getElementById('txtcomplaintdesciption').textContent;
            }
            else 
            {
                complaintdesciption = document.getElementById('txtcomplaintdesciption').innerText;
            }
            if(complaintdesciption =="")
            {
                alert("Please Fill Complaint Description");
                return false;
            }
            
        var compcode = document.getElementById('hdncomp_code').value;
        var locid =document.getElementById("hdnloc_id").value;
        var branchcode = document.getElementById('hdnbranchcode').value;
        //var complaintby = document.getElementById("hdnuser_id").value;
        var complaintby = document.getElementById("hdnuser_id").value;
        var complaindate = document.getElementById('hidnCreatedDate').value;
        //var complaintsummary = document.getElementById('txtcomplaintsubject').value;
        //var complaintdesciption = document.getElementById('txtcomplaintdesciption').value;
        var dateformat = "dd/mm/yyyy";
        var extra1 = document.getElementById('drptype').value;
        var extra2 = document.getElementById('hidattach1').value;// compltype
        var extra3 = "";
        var extra4 = "";
        var extra5 = "";

       // var arr = [compcode, locid, branchcode, complaintby, complaindate, complaintsummary, complaintdesciption, dateformat, extra1, extra2, extra3, extra4, extra5];
       // var res = submit_complaints.save_complaints(arr);
        var res = submit_complaints.save_complaints(compcode, locid, branchcode, complaintby, complaindate, complaintsummary, complaintdesciption, dateformat, extra1, extra2, extra3, extra4, extra5);
        if (res.error == null) 
        {
            var complid = res.value.Tables[0].Rows[0]["COMPL_ID"];
            if (document.getElementById('hdnRet_mailoption').value == "Y") 
            {
                submit_complaints.ret_complaint_mail(compcode, complid, complaintby, locid, branchcode, complaindate);
            }

            alert(res.value.Tables[0].Rows[0]["COMPL_MESSAGE"]);
            document.getElementById('txtcomplaintsubject').value = "";
            document.getElementById('txtcomplaintdesciption').value = "";
            document.getElementById('drptype').value = "0";
            document.getElementById('hdnattachment').value = "";
            data_grid();
            return false;
        }
        else 
        {
            alert(res.error);
            return false;
        }
        return false;
    }



    function Exit_menu() 
    {
        if (confirm("Do you want to skip this page ?")) 
        {
            document.location.href = "Default.aspx";
            return false;
        }
        return false;
    }

    function openattach1() 
    {   
        window.open('approvalAttachment.aspx?filename=' + document.getElementById('hidattach1').value, 'Ankur2', 'status=0,toolbar=0,resizable=0,scrollbars=yes,top=144,left=210,width=350px,height=300px');
        return false;
    }

    function openattach_grid(id) 
    {
        var id1 = id.split('_')[1];
        document.getElementById('hidattach1').value = document.getElementById('hdnattach_' + id1).value

        window.open('approvalAttachment.aspx?filename=' + document.getElementById('hidattach1').value, 'Ankur2', 'status=0,toolbar=0,resizable=0,scrollbars=yes,top=144,left=210,width=350px,height=300px');
        return false;
    }
    
    function colorchange() 
    {
        document.getElementById("txtcomplaintdesciption").style.background = "lightgrey";
        return false;
    }
    
    var dslength33333 = "";
    function data_grid() 
    {
        var pcompcode = document.getElementById('hdncomp_code').value;
            var plocid = document.getElementById("hdnloc_id").value;
            var puserid =document.getElementById("hdnuser_id").value;
            var pextra1 = "";
            var pextra2 = "";
            var ds = "";
            var ds = submit_complaints.binddata(pcompcode, plocid, puserid, pextra1, pextra2)
            var i = 0;
            if (ds.value.Tables.length > 0) 
            {   
                if (ds.value.Tables[0].Rows.length > 0) 
                {           
                    var str = "";
                    str += "<table id='table_data' runat='server' class='table table-bordered table-hover' style='width:100%;'>";
                    str += "<thead>"
                    str += "<tr style='background-color:lightgrey;'>"; //#efefef          
                    str += "<td style='text-align:center;width: 50px; font-size: larger'><b>" + "Id" + "</b></td>";
                    str += "<td style='text-align:center;width: 50px; font-size: larger'><b>" + "Type" + "</b></td>";
                    str += "<td style='display:none;text-align:center;width: 50px; font-size: larger'><b>" + "Unit" + "</b></td>";
                    str += "<td style='text-align:center;width: 150px; font-size: larger'><b>" + "Date" + "</b></td>";
                    str += "<td style='text-align:center;width: 150px; font-size: larger'><b>" + "Subject" + "</b></td>";
                    str += "<td style='text-align:center;width: 50px; font-size: larger'><b>" + "Status" + "</b></td>";           
                    str += "<td style='text-align:center;width: 50px; font-size: larger'><b>" + "Attachment" + "</b></td>";
                    str += "</tr>";
                    str += "</thead>"
                    str += "<tbody>"
                     dslength33333 =ds.value.Tables[0].Rows.length;
                    for (i = 0; i < ds.value.Tables[0].Rows.length; i++) 
                    {

                        str += "<tr id = comptrrr_" + i + " onclick='javascript:return changecolour(this.id);'>";
                        str += "<td Disable style='text-align:center; font-size: small;  cursor:pointer; color:Blue; background-color:#efefef;'  id=compid_" + i + " onclick='javascript:return compl_id(this.id);'>" + fndnull(ds.value.Tables[0].Rows[i].COMPL_ID) + "</td>";
                        str += "<td name='Disable' id='comptype_" + i + "' style='text-align:left; '>" + fndnull(ds.value.Tables[0].Rows[i].COMPL_TYPE) + "</td>";
                        str += "<td name='Disable' id='comptype_" + i + "' style='text-align:left; display:none;'>" + fndnull(ds.value.Tables[0].Rows[i].unit_NAME) + "</td>";
                        str += "<td name='Disable' id='compdesc_" + i + "' style='text-align:left;'>" + fndnull(ds.value.Tables[0].Rows[i].COMPL_DT) + "</td>";
                        str += "<td name='Disable' id='compdate_" + i + "' style='text-align:left;'>" + fndnull(ds.value.Tables[0].Rows[i].COMPLAINT_SUBJECT) + "</td>";
                        str += "<td name='Disable' id='compsub_" + i + "' style='text-align:left; '>" + fndnull(ds.value.Tables[0].Rows[i].COMP_STATUS_NAME) + "</td>";
                       // str += "<td style='background-color:#efefef;'><img id =Imgattch_" + i + "onclick='javascript:return openattach_grid(this.id);'>" + fndnull(ds.value.Tables[0].Rows[i].COMPL_ATTACHMENT) + "<input type=hidden id=hdnattach_" + i + " value=" + fndnull(ds.value.Tables[0].Rows[i].COMPL_ATTACHMENT) + "></td>";
                        str += "<td style='text-align:center; font-size: small; cursor:pointer; color:Blue; background-color:#efefef;'  id=Imgattch_" + i + " onclick='javascript:return openfile(this.id);'>" + fndnull(ds.value.Tables[0].Rows[i].COMPL_ATTACHMENT) + "</td>";
                        str += "<td style='display:none;'><input  name='Disable'  class='gridinputclass' style='text-align:right;' value='" + ds.value.Tables[0].Rows[i].COMPL_ATTACHMENT + "' id=hdnattach_" + i + "  disabled type='hidden'></td>"

                        str += "</tr>";
                    }
                 }
                    str += "</tbody>"
                    str += "</table >"
                    document.getElementById("gridview_data").innerHTML = str;
                    document.getElementById("gridview_data").style.display = "block";
            }
            
            document.getElementById('drptype').value = "0";
            document.getElementById('hdnattachment').value = "";
            document.getElementById('hidattach1').value = "";
            
            if (browser != "Microsoft Internet Explorer") 
            {
                document.getElementById('txtcomplaintsubject').textContent = "";
                document.getElementById('txtcomplaintdesciption').textContent = "";
                document.getElementById('lblattachmentname').textContent = "";
            }
            else 
            {
                document.getElementById('txtcomplaintsubject').innerText = "";
                document.getElementById('txtcomplaintdesciption').innerText = "";
                document.getElementById('lblattachmentname').innerText = "";
            }
            return false;
    }

        function changecolour(rowid)
        {
            var o = rowid.split('_')[1];
            var idnameo = rowid.split('_')[0];
            for(j=0;j<dslength33333;j++)
            {
                document.getElementById("comptrrr_" + j).style.color = "Black";
            }
            document.getElementById(rowid).style.color = "Red";
            return false;
        }
    
        function openfile(id) 
        {

            var id1 = id.split('_')[1];
            document.getElementById('hidattach1').value = document.getElementById('hdnattach_' + id1).value
            //    if (document.getElementById('hidfilepth').value == "") {
                window.open("ApprovalAttachment/" + document.getElementById('hidattach1').value);
            //    }
            //    else {
                //var filevalue = document.getElementById('hidfilepth').value + document.getElementById('hidattach1').value;
            //      window.open(filevalue);
            //}
        return false;
        }
        
    function compl_id(id) 
    {
        var dd = id.split('_')
        var index = dd[1];
        var PCOMP_CODE = "";
        var complainid = document.getElementById("compid_" + index).innerHTML;
        var schemeid = "";
        var customercode = "";
        var readerid = "";
        var complfrom = 'S';
        win = window.open('crm_feedback_resolution.aspx?complainid=' + complainid + '&schemeid=' + schemeid + '&customercode=' + customercode + '&readerid=' + readerid + '&complfrom=' + complfrom + '&id=' + id + '&PCOMP_CODE=' + PCOMP_CODE, '', 'width=1250px,height=400px,resizable=0,left=50px,top=100px, scrollbars=yes');
        win.focus();
        return false;
    }


    function onpageload() 
    {
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

        var res = crm_feedback_resolution.getcompltails(PCOMP_CODE, PLOCATION_CODE, PSCH_ID, PCUSTID, PCOMPLID, PEXTRA1, PEXTRA2, PEXTRA3, PEXTRA4, PEXTRA5, complain_from);
        callback_grid123(res)
        if (document.getElementById('hidden1').value.substring(0, 3) == "act") 
        {
            Clock()
        }
        else if (document.getElementById('hidden1').value.substring(0, 6) == "as_act") 
        {
            Clock1()
        }
        return false;
    }

function callback_grid123(res) 
{
    if (document.getElementById('hidden1').value.substring(0, 3) == "act") {
        document.getElementById('Button4').style.display = "block";
    }
    else if (document.getElementById('hidden1').value.substring(0, 6) == "as_act") {
        document.getElementById('Button4').style.display = "block";
    }
    else {        
    }
    var ds = res.value;
    document.getElementById('hiddenlength123').value = ds.Tables[0].Rows.length;
    document.getElementById('hdsviewgrid').innerHTML = "";

    document.getElementById('hdsviewgrid').style.display = "block";
    document.getElementById('dv_grid').style.display = "block";
    document.getElementById('tbl123').style.display = "block";
    if (document.getElementById('hiddencompl_from').value == 'S') {
        if (ds != null && ds.Tables[0].Rows.length > 0) {
            var hdsview = "";
            hdsview += "<table width='800px'; class='table table-bordered table-hover' style=width:100%;  border='0' >"

            hdsview += "<tr style='background-color:lightgrey;'>";
            //==============================
            hdsview += "<td style='width: 100px; text-align:center;'>Subject</td>";
            hdsview += "<td style='width: 100px; text-align:center;'>Description</td>";
            hdsview += "<td style='width: 100px; text-align:center;'>Status Remark</td>";
            hdsview += "<td style='width: 100px; text-align:center;'>Status</td>";
            hdsview += "<td style='width: 100px; text-align:center;'>Status Changed By</td>";
            hdsview += "<td style='width: 100px; text-align:center;'>Status Changed Date</td>";
            hdsview += "<td style='width: 100px; text-align:center;'>Attachment</td>";
            
            hdsview += "</tr>";
            var i = 0;
            for (i = 0; i < ds.Tables[0].Rows.length; i++) 
            {

                hdsview += "<tr id=rowid_" + i + " >";
                //===================================================
                hdsview += "<td name='Disable' id='sch_" + i + "' style='text-align:center; background-color:#efefef; font-size: small'>" + ds.Tables[0].Rows[i].complaint_subject  + "</td>";
                hdsview += "<td name='Disable' id='sch_" + i + "' style='text-align:center; background-color:#efefef; font-size: small'>" + ds.Tables[0].Rows[i].COMPL_DESC  + "</td>";
                hdsview += "<td name='Disable' id='sch_" + i + "' style='text-align:center; background-color:#efefef; font-size: small'>" + ds.Tables[0].Rows[i].COMPL_STATUS_REMARK + "</td>";
                hdsview += "<td name='Disable' id='sch_" + i + "' style='text-align:center; background-color:#efefef; font-size: small'>" + ds.Tables[0].Rows[i].COMPL_STATUS + "</td>";
                hdsview += "<td name='Disable' id='complstatuschangedby_" + i + "' style='text-align:center; background-color:#efefef; font-size: small'>" + document.getElementById('hidnUsername').value + "</td>";
                hdsview += "<td name='Disable' id='complstatuschangedby_" + i + "' style='text-align:center; background-color:#efefef; font-size: small'>" + date_fun(ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT) + "</td>";
                
                hdsview += "<td style='text-align:center; font-size: small; cursor:pointer; color:Blue; background-color:#efefef;'  id=Imgattch_" + i + " onclick='javascript:return openfilepopup(this.id);'>" + fndnull(ds.Tables[0].Rows[i].COMPL_ATTACHMENT) + "</td>";
                hdsview += "<td style='display:none;'><input  name='Disable'  class='gridinputclass' style='text-align:right;' value='" + ds.Tables[0].Rows[i].COMPL_ATTACHMENT + "' id=hdnattach_" + i + "  disabled type='hidden'></td>"
                hdsview += "</tr>"
            }
            greidpera = i          
            if (document.getElementById('hidden1').value.substring(0, 3) == "act") 
            {
                hdsview += "<tr id=rowid_" + i + " >";
                //===================================================
                hdsview += "<td name='Disable' id='sch_" + i + "' style='text-align:center; background-color:#efefef; font-size: small'>" + ds.Tables[0].Rows[i].COMP_DESC + "</td>";
                hdsview += "<td name='Disable' id='sch_" + i + "' style='text-align:center; background-color:#efefef; font-size: small'>" + ds.Tables[0].Rows[i].COMP_STATUS_REMARK + "</td>";
                hdsview += "<td name='Disable' id='sch_" + i + "' style='text-align:center; background-color:#efefef; font-size: small'>" + ds.Tables[0].Rows[i].COMPL_STATUS + "</td>";
                hdsview += "<td name='Disable' id='sch_" + i + "' style='text-align:center; background-color:#efefef; font-size: small'>" + ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_BY_NAME + "</td>";
                hdsview += "<td name='Disable' id='sch_" + i + "' style='text-align:center; background-color:#efefef; font-size: small'>" + date_fun(ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT) + "</td>";
                //==================================================
                hdsview += "</tr>"
            }
            hdsview += "</table>";
            document.getElementById('hdsviewgrid').innerHTML = hdsview;
            return false;
        }
    }
    if (document.getElementById('hiddencompl_from').value == 'A') {
        if (ds != null && ds.Tables[0].Rows.length > 0) {
            var hdsview = "";
            hdsview += "<table width='1200px' style='border:1px; solid #7DAAE3;margin-top:0px;margin-bottom:1px;margin-left:60px;' cellpadding='0' border='0'cellspacing='0'>"
            hdsview += "<tr>"
            hdsview += "<td width='90px' class='grid2' bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:center;border:0px solid #ffffff;cursor:hand;font-size:9px;font-family:Verdana;vertical-align:top;'>Booking Id</td>";
            hdsview += "<td  width='75px' class='grid2' bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:9px;font-family:Verdana;vertical-align:top;'>Complaint No.</td>";
            hdsview += "<td  width='75px' class='grid2'   bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:9px;font-family:Verdana;vertical-align:top;'>Status</td>";
            hdsview += "<td  width='90px' class='grid2'   bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:9px;font-family:Verdana;vertical-align:top;'>Assigned To</td>";
            hdsview += "<td  width='125px'  class='grid2'  bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:9px;font-family:Verdana;vertical-align:top;'>Current Status Remark</td>";
            hdsview += "<td  width='90px' class='grid2' bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:9px;font-family:Verdana;vertical-align:top;'>Complaint Type</td>";
            hdsview += "<td  width='90px' class='grid2' bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:9px;font-family:Verdana;vertical-align:top;'>Complaint Mode</td>";
            hdsview += "<td width='125px' class='grid2'   bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:9px;font-family:Verdana;vertical-align:top;'>Complaint Description</td>";
            hdsview += "<td width='75px' class='grid2'   bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:9px;font-family:Verdana;vertical-align:top;'>Complaint Date</td>";
            hdsview += "<td  width='90px' class='grid2'  bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:9px;font-family:Verdana;vertical-align:top;'>Status Changed By</td>";
            hdsview += "<td  width='90px' class='grid2'  bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:9px;font-family:Verdana;vertical-align:top;'>Status Changed Date</td>";
            hdsview += "<td  width='125px' class='grid2'  bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:9px;font-family:Verdana;vertical-align:top;'>From Assigning Time</td>";
            hdsview += "<td  width='75px' class='grid2'  bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:9px;font-family:Verdana;vertical-align:top;'>No. of Hours</td>";
            hdsview += "<td  width='125px' class='grid2'  bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:center;border:0px solid #ffffff;font-size:9px;font-family:Verdana;vertical-align:top;'>To Assigning Time</td>";
            hdsview += "<td  width='0px' class='grid2'  bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:left;border:0px solid #ffffff;display:none;'>schcode</td>";
            hdsview += "<td width='0px' class='grid2'  bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:left;border:0px solid #ffffff;display:none;'>custcode</td>";
            hdsview += "<td width='0px' class='grid2'  bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:left;border:0px solid #ffffff;display:none;'>cmtype</td>";
            hdsview += "<td  width='0px' class='grid2'  bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:left;border:0px solid #ffffff;display:none;'>comode</td>";
            hdsview += "<td  width='0px' class='grid2'  bgcolor=#7DAAE3 style='height:5px;font-size:10px;font-weight:bold;text-align:left;border:0px solid #ffffff;display:none;'>tranid</td>";
            hdsview += "<td  width='0px' class='grid2'  bgcolor=#7DAAE3 style='height:5px;font-size:5px;font-weight:bold;text-align:left;border:0px solid #ffffff;display:none;'>assigntocode</td>";
            hdsview += "<td  width='0px' class='grid2'  bgcolor=#7DAAE3 style='height:5px;font-size:5px;font-weight:bold;text-align:left;border:0px solid #ffffff;display:none;'>statuscode</td>";
            hdsview += "</tr>";
            var i = 0;

            for (i = 0; i < ds.Tables[0].Rows.length; i++) {
                hdsview += "<tr id=rowid_" + i + " >";
                hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                hdsview += "<input type='textbox' id=assch_" + i + "  disabled   style='width:90px;border:0px;text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].SCHEME_OPT + "' title='" + ds.Tables[0].Rows[i].SCHEME_OPT + "' >"
                hdsview += "</td>"

                hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=complid_" + i + " disabled style='width:75px;border:0px;text-align:left;font-size:9px;font-family:Verdana;' value=" + ds.Tables[0].Rows[i].COMPL_ID + "  title=" + ds.Tables[0].Rows[i].COMPL_ID + ">"
                hdsview += "</td>"
                if (i == 0) {
                    if (ds.Tables[0].Rows[i].COMPL_STATUS != null) {
                        hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                        hdsview += "<input type='textbox'id=ascomplstatus_" + i + " disabled style='width:75px;border:0px; text-align:left;font-size:9px;font-family:Verdana;' value='Open' title='Open'>"
                        hdsview += "</td>"
                    }
                    else {
                        hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                        hdsview += "<input type='textbox'id=ascomplstatus_" + i + " disabled style='width:75px;border:0px; text-align:left;font-size:9px;font-family:Verdana;' >"
                        hdsview += "</td>"
                    }
                }
                else {
                    if (ds.Tables[0].Rows[i].COMPL_STATUS != null) {
                        hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                        hdsview += "<input type='textbox'id=ascomplstatus_" + i + " disabled style='width:75px;border:0px; text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_STATUS_NAME + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_NAME + "'>"
                        hdsview += "</td>"
                    }
                    else {
                        hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                        hdsview += "<input type='textbox'id=ascomplstatus_" + i + " disabled style='width:75px;border:0px; text-align:left;font-size:9px;font-family:Verdana;' >"
                        hdsview += "</td>"
                    }
                }
                if (ds.Tables[0].Rows[i].ASSIGNTO_NAME != null) {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asassignto_" + i + " disabled style='width:90px;border:0px; text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].ASSIGNTO_NAME + "'  title='" + ds.Tables[0].Rows[i].ASSIGNTO_NAME + "'>"
                    hdsview += "</td>"
                }
                else {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asassignto_" + i + " disabled style='width:90px;border:0px; text-align:left;font-size:9px;font-family:Verdana;' >"
                    hdsview += "</td>"
                }
                if (ds.Tables[0].Rows[i].COMPL_STATUS_REMARK != null) {

                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:125px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascomplstatusremark_" + i + " disabled style='width:125px;border:0px; text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_STATUS_REMARK + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_REMARK + "'>"
                    hdsview += "</td>"
                }
                else {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:125px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascomplstatusremark_" + i + " disabled style='width:125px;border:0px; text-align:left;font-size:9px;font-family:Verdana;' >"
                    hdsview += "</td>"
                }
                if (ds.Tables[0].Rows[i].COMPL_TYPE != null) {

                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascompltype_" + i + "  disabled style='width:90px;border:0px;text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPLTYPE_NAME + "'  title='" + ds.Tables[0].Rows[i].COMPLTYPE_NAME + "'>"
                    hdsview += "</td>"
                }
                else {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascompltype_" + i + "  disabled style='width:90px;border:0px;text-align:left;font-size:9px;font-family:Verdana;' >"
                    hdsview += "</td>"
                }
                if (ds.Tables[0].Rows[i].MODE_OF_COMPL != null) {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascomplmode_" + i + " disabled style='width:90px;border:0px;text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].MODEOFCMPLNAME + "'  title='" + ds.Tables[0].Rows[i].MODEOFCMPLNAME + "'>"
                    hdsview += "</td>"
                }
                else {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascomplmode_" + i + " disabled style='width:90px;border:0px;text-align:left;font-size:9px;font-family:Verdana;' >"
                    hdsview += "</td>"
                }
                if (ds.Tables[0].Rows[i].COMPL_DESC != null) {

                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:125px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascompldesc_" + i + " disabled style='width:125px;border:0px;text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_DESC + "' title='" + ds.Tables[0].Rows[i].COMPL_DESC + "'>"
                    hdsview += "</td>"
                }
                else {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:125px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascompldesc_" + i + " disabled style='width:125px;border:0px;text-align:left;font-size:9px;font-family:Verdana;' >"
                    hdsview += "</td>"
                }
                if (ds.Tables[0].Rows[i].COMPL_DT != null) {

                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascompldate_" + i + " disabled style='width:75px;border:0px;text-align:left;font-size:9px;font-family:Verdana;' value='" + date_fun(ds.Tables[0].Rows[i].COMPL_DT) + "'  title='" + ds.Tables[0].Rows[i].COMPL_DT + "'>"
                    hdsview += "</td>"
                }
                else {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascompldate_" + i + " disabled style='width:75px;border:0px;text-align:left;font-size:9px;font-family:Verdana;' >"
                    hdsview += "</td>"
                }

                if (ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_BY_NAME != null) {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascomplstatuschangedby_" + i + " disabled style='width:90px;border:0px; text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_BY_NAME + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_BY_NAME + "'>"
                    hdsview += "</td>"
                }
                else {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascomplstatuschangedby_" + i + " disabled style='width:90px;border:0px; text-align:left;font-size:9px;font-family:Verdana;' >"
                    hdsview += "</td>"
                }

                if (ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT != null) {

                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascomplstatuschangeddate_" + i + " disabled style='width:90px;border:0px; text-align:left;font-size:9px;font-family:Verdana;' value='" + date_fun(ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT) + "' title='" + ds.Tables[0].Rows[i].COMPL_STATUS_CHANGED_DT + "'>"
                    hdsview += "</td>"
                }
                else {

                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascomplstatuschangeddate_" + i + " disabled style='width:90px;border:0px; text-align:left;font-size:9px;font-family:Verdana;' >"
                    hdsview += "</td>"
                }

                if (ds.Tables[0].Rows[i].Column1 != null) {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:125px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascurrenttime_" + i + " disabled style='width:125px;border:0px;text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].Column1 + "' title='" + ds.Tables[0].Rows[i].Column1 + "'>"
                    hdsview += "</td>"
                }
                else {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:125px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascurrenttime_" + i + " disabled style='width:125px;border:0px;text-align:left;font-size:9px;font-family:Verdana;'>"
                    hdsview += "</td>"
                }
                if (ds.Tables[0].Rows[i].Column2 != null) {


                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asnoofhours_" + i + " disabled style='width:75px;border:0px;text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].Column2 + "' title='" + ds.Tables[0].Rows[i].Column2 + "' >"
                    hdsview += "</td>"
                }
                else {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asnoofhours_" + i + " disabled style='width:75px;border:0px;text-align:left;font-size:9px;font-family:Verdana;'>"
                    hdsview += "</td>"
                }
                if (ds.Tables[0].Rows[i].Column3 != null) {

                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:125px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asdeadline_" + i + " disabled style='width:125px;border:0px;text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[i].Column3 + "' title='" + ds.Tables[0].Rows[i].Column3 + "'>"
                    hdsview += "</td>"
                }
                else {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:125px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asnoofhours_" + i + " disabled style='width:125px;border:0px;text-align:left;font-size:9px;font-family:Verdana;'>"
                    hdsview += "</td>"
                }

                hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=asvcustcode_" + i + "  style='width:0px;border:0px; text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' value=" + ds.Tables[0].Rows[i].CUST_ID + ">"
                hdsview += "</td>"
                if (ds.Tables[0].Rows[i].COMPL_TYPE != null) {

                    hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascmptype_" + i + "  style='width:0px;border:0px; text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' value=" + ds.Tables[0].Rows[i].COMPL_TYPE + ">"
                    hdsview += "</td>"
                }
                else {

                    hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascmptype_" + i + "  style='width:0px;border:0px; text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' >"
                    hdsview += "</td>"
                }
                if (ds.Tables[0].Rows[i].MODE_OF_COMPL != null) {

                    hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asvcomode_" + i + "  style='width:0px;border:0px; text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' value=" + ds.Tables[0].Rows[i].MODE_OF_COMPL + ">"
                    hdsview += "</td>"
                }
                else {
                    hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asvcomode_" + i + "  style='width:0px;border:0px; text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' >"
                    hdsview += "</td>"
                }

                hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=asvtranid_" + i + "  style='width:0px;border:0px; text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' >"
                hdsview += "</td>"


                hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=asvassintocode_" + i + "  style='width:0px;border:0px; text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' >"
                hdsview += "</td>"


                hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=asvstatuscode_" + i + "  style='width:0px;border:0px; text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' value='" + ds.Tables[0].Rows[i].COMPL_STATUS + "'>"
                hdsview += "</td>"

                hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=asvcompltype_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' value='" + ds.Tables[0].Rows[i].COMPL_TYPE + "'>"
                hdsview += "</td></tr>"
            }
            greidpera = i
            if (document.getElementById('hidden1').value.substring(0, 6) == "as_act") {

                hdsview += "<tr id=rowid_" + i + " >";
                hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=assch_" + i + "  disabled style='width:90px;border:0px; background-color:	#FFFFFF ;text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[0].SCHEME_OPT + "' title='" + ds.Tables[0].Rows[0].SCHEME_OPT + "' >"
                hdsview += "</td>"

                hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=ascomplid_" + i + " disabled style='width:75px;border:0px; background-color:#FFFFFF ;text-align:left;font-size:9px;font-family:Verdana;' value=" + ds.Tables[0].Rows[0].COMPL_ID + "  title=" + ds.Tables[0].Rows[0].COMPL_ID + ">"
                hdsview += "</td>"

                hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=ascomplstatus_" + i + "  style='width:75px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' onkeydown=\"return bindcomplstatus(event,this.id);\" >"
                hdsview += "</td>"

                hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=asassignto_" + i + "  style='width:90px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' onkeydown=\"return bindassignto(event,this.id);\">"
                hdsview += "</td>"

                hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:125px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=ascomplstatusremark_" + i + "  style='width:125px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' >"
                hdsview += "</td>"

                if (ds.Tables[0].Rows[0].COMPL_TYPE != null) {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascompltype_" + i + "  disabled style='width:90px;border:0px; background-color:#FFFFFF ;text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[0].COMPLTYPE_NAME + "'  title='" + ds.Tables[0].Rows[0].COMPLTYPE_NAME + "'>"
                    hdsview += "</td>"
                }
                else {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascompltype_" + i + "  disabled style='width:90px;border:0px; background-color:#FFFFFF ;text-align:left;font-size:9px;font-family:Verdana;' >"
                    hdsview += "</td>"

                }
                if (ds.Tables[0].Rows[0].MODE_OF_COMPL != null) {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascomplmode_" + i + " disabled style='width:90px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[0].MODEOFCMPLNAME + "'  title='" + ds.Tables[0].Rows[0].MODEOFCMPLNAME + "'>"
                    hdsview += "</td>"
                }
                else {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascomplmode_" + i + " disabled style='width:90px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' >"
                    hdsview += "</td>"
                }

                if (ds.Tables[0].Rows[0].COMPL_DESC != null) {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:125px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascompldesc_" + i + " disabled style='width:125px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' value='" + ds.Tables[0].Rows[0].COMPL_DESC + "' title='" + ds.Tables[0].Rows[0].COMPL_DESC + "'>"
                    hdsview += "</td>"
                }
                else {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:125px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascompldesc_" + i + " disabled style='width:125px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' >"
                    hdsview += "</td>"
                }
                if (ds.Tables[0].Rows[0].COMPL_DT != null) {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascompldate_" + i + " disabled style='width:75px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' value='" + date_fun(ds.Tables[0].Rows[0].COMPL_DT) + "'  title='" + ds.Tables[0].Rows[0].COMPL_DT + "'>"
                    hdsview += "</td>"
                }
                else {

                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascompldate_" + i + " disabled style='width:75px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;'  >"
                    hdsview += "</td>"
                }

                if (ds.Tables[0].Rows[0].COMPL_FROM != null) {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;display:none;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascomplfrom_" + i + "  style='width:90px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;' value='" + ds.Tables[0].Rows[0].COMPL_FROM_NAME + "'  title='" + ds.Tables[0].Rows[0].COMPL_FROM_NAME + "'>"
                    hdsview += "</td>"
                }
                else {
                    hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;display:none;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascomplfrom_" + i + "  style='width:90px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;'>"
                    hdsview += "</td>"
                }

                hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=ascomplstatuschangedby_" + i + " disabled style='width:90px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' value='" + document.getElementById('hidnUsername').value + "' title='" + document.getElementById('hidnUsername').value + "'>"
                hdsview += "</td>"

                hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:90px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=ascomplstatuschangeddate_" + i + "  style='width:90px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' value='" + document.getElementById('hidnCreatedDate').value + "' title='" + document.getElementById('hidnCreatedDate').value + "'>"
                hdsview += "</td>"

                hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:125px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=ascurrenttime_" + i + "  style='width:125px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' value=''>"
                hdsview += "</td>"

                hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:75px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=asnoofhours_" + i + "  style='width:75px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' value=''>"
                hdsview += "</td>"

                hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:125px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=asdeadline_" + i + "  style='width:125px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;' value=''>"
                hdsview += "</td>"
               
                hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=asvcustcode_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;' value=" + ds.Tables[0].Rows[0].CUST_ID + ">"
                hdsview += "</td>"

                if (ds.Tables[0].Rows[0].COMPL_TYPE != null) {
                    hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascmptype_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;' value=" + ds.Tables[0].Rows[0].COMPL_TYPE + ">"
                    hdsview += "</td>"
                }
                else {

                    hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=ascmptype_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;' >"
                    hdsview += "</td>"
                }


                if (ds.Tables[0].Rows[0].MODE_OF_COMPL != null) {

                    hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asvcomode_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;' value=" + ds.Tables[0].Rows[0].MODE_OF_COMPL + ">"
                    hdsview += "</td>"
                }
                else {
                    hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                    hdsview += "<input type='textbox'id=asvcomode_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;' >"
                    hdsview += "</td>"
                }

                hdsview += "<td align='center' style='border:1px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=asvtranid_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;' >"
                hdsview += "</td>"

                hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=asvassintocode_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' >"
                hdsview += "</td>"

                hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=asvstatuscode_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' >"
                hdsview += "</td>"

                hdsview += "<td align='center' style='border:0px solid #7DAAE3;width:0px;'   class='Grid_report' >"
                hdsview += "<input type='textbox'id=asvcompltype_" + i + "  style='width:0px;border:0px; background-color:#FFFFFF;text-align:left;font-size:9px;font-family:Verdana;display:none;disabled:true;' >"
                hdsview += "</td></tr>"
            }
            hdsview += "</table>";
            document.getElementById('hdsviewgrid').innerHTML = hdsview;
            return false;
        }
    }
    return false;
}

function openfilepopup(id) 
        {

            var id1 = id.split('_')[1];
            document.getElementById('hidattach1').value = document.getElementById('hdnattach_' + id1).value
            //    if (document.getElementById('hidfilepth').value == "") {
                window.open("ApprovalAttachment/" + document.getElementById('hidattach1').value);
            //    }
            //    else {
                //var filevalue = document.getElementById('hidfilepth').value + document.getElementById('hidattach1').value;
            //      window.open(filevalue);
            //}
        return false;
        }

    function date_fun(str_date) 
    {
        var final_date = new Date(str_date);

        if (final_date != "" && final_date != null) 
        {
            var month = final_date.getMonth() + 1
            var day = final_date.getDate()
            var year = final_date.getFullYear()

            if (day.toString().length < 2)
                day = "0" + day

            if (month.toString().length < 2)
                month = "0" + month

            if (document.getElementById('hiddendateformat').value == "dd/mm/yyyy")
                final_date = day + "/" + month + "/" + year;

            else if (document.getElementById('hiddendateformat').value == "mm/dd/yyyy")
                final_date = month + "/" + day + "/" + year;

            else if (document.getElementById('hiddendateformat').value == "yyyy/mm/dd")
                final_date = year + "/" + month + "/" + day;
        }
        if (final_date == "01/01/1900") 
        {
            return "";
        }
        else 
        {
            return final_date;
        }
    }

    function fndnull(myval) 
    {
        if (myval == "undefined") 
        {
            myval = "";
        }
        else if (myval == null) 
        {
            myval = "";
        }
        return myval
    }

    function winclose() 
    {
        window.close()
        return false;
    }

