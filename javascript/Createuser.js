// JScript File
var hiddentext;
var mod = "0";
var z = 0;
var znk = "0";
var auto = "";
var hiddentext1 = "";
var glaobalusername;
var glaobaluserid;
var glaobalcompcode;
var glaobal1 = '';
//var glaobalcatalias;
//var glaobalsubcatname;
//var glbruserid;
var glbrcomcode;
var dsexecute;
var dsbranch;
var y;
var dscatdelete;
function disablefield()
 {
//    if (document.getElementById("hdn_user_right").value == "0" || document.getElementById("hdn_user_right").value == "") {
//        alert("You are not Authorized to see this form")
//        window.close();
//        return false;
//    }
//    else {
        document.getElementById('rbuser').disabled = true;
        document.getElementById('rbadmin').disabled = true;
        document.getElementById('drpuser_type').disabled = true;
        //givebuttonpermission('Createuser');
        document.getElementById('btnNew').focus();
      
        setButtonImages();
        return false;
    }
//}
function newclick() {
    cancelclick('Createuser');
    document.getElementById('txtdatestatus').disabled = false;
    document.getElementById('txtdatestatus').value = "";
    document.getElementById('drpstatus').value = "A";
    document.getElementById('txtusername').value = "";
    document.getElementById('tbcashier').value = "";
    document.getElementById('txtfirstname').value = "";
    document.getElementById('txtlastname').value = "";
    document.getElementById('txtpwd').value = "";
    document.getElementById('txtuserid').value = "";
    document.getElementById('drpdateformate').value = "0";
    //  document.getElementById('txtcompname').value="Hindustan GRAMEDIA";
    // document.getElementById('txtcompcode').value="HT001";
    document.getElementById('drpcompany').value = "0";
    document.getElementById('drpstatus').disabled = false;
    document.getElementById('tbcashier').disabled = false;
    document.getElementById('drpcompany').disabled = false;
    document.getElementById('drpcompanylist').value = "0";
    document.getElementById('drpcompanylist').disabled = false;
    document.getElementById('drpcurrencycode').value = "0";
    document.getElementById('drpretainer').value = "0";
    document.getElementById('txtemail').value = "";
    document.getElementById('txtdisc').value = "";
    document.getElementById('txtemcode').value = "";
    document.getElementById('drpfilter').value = "0";
    document.getElementById('drprole').value = "0";
    document.getElementById('txtbranchpermission').value = "0";
    document.getElementById('txtbranchpermission').disabled = false;
    document.getElementById('drpuser_type').disabled = false;
    //     document.getElementById('drpeditlines').value="0";
    document.getElementById('drpeditlines').disabled = false;
    /*new click ankur*/
    //if(document.getElementById('tdagencylabel').style.display=="block")
    //{
    document.getElementById('drpagency').value = "";
    document.getElementById('drpagency').disabled = false;

    //}

    if (document.getElementById('hiddenauto').value == "1") {
        document.getElementById('txtuserid').disabled = true;
    }
    else {
        document.getElementById('txtuserid').disabled = false;
    }
    document.getElementById('txtemcode').disabled = false;
    document.getElementById('txtusername').disabled = false;
    document.getElementById('txtpwd').disabled = false;
    document.getElementById('drpdateformate').disabled = false;
    document.getElementById('txtemail').disabled = false;
    document.getElementById('txtdisc').disabled = false;
    document.getElementById('drpfilter').disabled = false;
    //document.getElementById('txtcompcode').disabled=true;
    document.getElementById('drpcurrencycode').disabled = false;
    document.getElementById('drpretainer').disabled = false;
    document.getElementById('drprole').disabled = false;
    document.getElementById('rbadmin').disabled = false;
    document.getElementById('rbuser').disabled = false;
    document.getElementById('txtfirstname').disabled = false;
    document.getElementById('txtlastname').disabled = false;

    document.getElementById('txtmob').disabled = false;
    document.getElementById('txtmob').value = "";
    //             if(document.getElementById('hiddenauto').value==1)
    //               {
    //                        document.getElementById('txtusername').focus();
    //               }
    //             else
    //              {
    //                       document.getElementById('txtuserid').focus();
    //               }
    hiddentext = "new";
    chkstatus(FlagStatus);
    document.getElementById('drpuser_type').disabled = false;
    document.getElementById('btnSave').disabled = false;
    document.getElementById('btnNew').disabled = true;
    document.getElementById('btnQuery').disabled = true;
    document.getElementById('txtusername').focus();
    setButtonImages();
    return false;
}

//***************************************save Button**********************************//
function saveclick() {
    //alert('rinki');

    var datasend = "";
    document.getElementById('txtusername').value = trim(document.getElementById('txtusername').value);
    document.getElementById('txtfirstname').value = trim(document.getElementById('txtfirstname').value);
    document.getElementById('txtlastname').value = trim(document.getElementById('txtlastname').value);
    if (chk_password(trim(document.getElementById('txtpwd').value)) == false) {
        document.getElementById('txtpwd').focus();
        return false;
    }

    document.getElementById('txtuserid').value = trim(document.getElementById('txtuserid').value);
    document.getElementById('drpdateformate').value = trim(document.getElementById('drpdateformate').value);
    document.getElementById('txtemail').value = trim(document.getElementById('txtemail').value);
    document.getElementById('txtdisc').value = trim(document.getElementById('txtdisc').value);
    //document.getElementById('txtcompcode').value=trim(document.getElementById('txtcompcode').value);
    document.getElementById('drpcurrencycode').value = trim(document.getElementById('drpcurrencycode').value);
    document.getElementById('drpretainer').value = trim(document.getElementById('drpretainer').value);
    //document.getElementById('txtdatestatus').value = trim(document.getElementById('txtdatestatus').value);s

    if (document.getElementById('txtusername').value == "") {
        alert("Please Enter the User Name ");
        document.getElementById('txtusername').focus();
        return false;
    }
    else if (document.getElementById('txtfirstname').value == "") {
        alert("Please Enter the First Name");
        document.getElementById('txtfirstname').focus();
        return false;
    }
    else if (document.getElementById('txtlastname').value == "") {
        alert("Please Enter the Last Name");
        document.getElementById('txtlastname').focus();
        return false;
    }
    else if (document.getElementById('txtpwd').value == "") {
        alert("Please Enter the Password");
        document.getElementById('txtpwd').focus();
        return false;
    }
    else if (document.getElementById('txtuserid').value == "") {
        alert("Please Enter the User Id");
        document.getElementById('txtuserid').focus();
        return false;
    }
    else if (document.getElementById('txtemail').value == "") {
        alert("Please Enter Email");
        document.getElementById('txtemail').focus();
        return false;
    }
    else if (document.getElementById('txtmob').value == "") {
        alert("Please Enter Mobile No.");
        document.getElementById('txtmob').focus();
        return false;
    }
    else if (document.getElementById('txtdatestatus').value == "") {
        alert("Please Enter Date");
        document.getElementById('txtdatestatus').focus();
        return false;

    }
    else if (document.getElementById('Hiddagency').value == "") {
        //	    alert("Please Select Agency with F2");
        //	    document.getElementById('drpagency').focus();
        //	    return false;
    }
    /*  if(document.getElementById('rbuser').checked==true)
    {
	  
    if(document.getElementById('drpagency').value=="0" && document.getElementById('drpagency').disabled==false)
    {
    alert("Please select Agency ");
    document.getElementById('drpagency').focus();
    return false;
    }
    }*/
    if (document.getElementById('drpretainer').value == "0" && document.getElementById('drpretainer').disabled == false) {
        alert("Please Enter the Branch Name");
        document.getElementById('drpretainer').focus();
        return false;
    }

    //// document.getElementById('retainer').style.display=="block";
    //document.getElementById('retainerdrp').style.display=="block";
    //	else if(document.getElementById('tdagencylabel').style.display=="block")
    //	{
    //	   if(document.getElementById('drpagency').value=="0")
    //	   {
    //	        alert("Please select Agency ");
    //	        document.getElementById('drpagency').focus();
    //	   
    //	   }
    //	}
    if (document.getElementById('drpcurrencycode').value == "0" && document.getElementById('drpcurrencycode').disabled == false) {
        alert("Please Enter the Currency Name");
        document.getElementById('drpcurrencycode').focus();
        return false;
    }

    var bc = "";
    if (browser != "Microsoft Internet Explorer") {
        bc = document.getElementById('lbemcode').textContent;
    }
    else {
        bc = document.getElementById('lbemcode').innerText;
    }

    if (bc.indexOf('*') >= 0) {
        if (trim(document.getElementById('txtemcode').value) == "") {
            alert('Please Enter ' + (bc.replace('*', "")));
            ValidateStatus = 0;
            document.getElementById('txtemcode').focus();
            return false;
        }
        else
        { ValidateStatus = 1; }

    }

    var group = "";
    if (browser != "Microsoft Internet Explorer") {
        group = document.getElementById('rolename').textContent;
    }
    else {
        group = document.getElementById('rolename').innerText;
    }

    if (group.indexOf('*') >= 0) {
        if (trim(document.getElementById('drprole').value) == "0") {
            alert('Please Enter ' + (group.replace('*', "")));
            document.getElementById('drprole').focus();
            return false;
        }


    }

    if (document.getElementById('drpdateformate').value == "0" && document.getElementById('drpdateformate').disabled == false) {
        alert("Please Enter Date Format");
        document.getElementById('drpdateformate').focus();
        return false;
    }

    if (document.getElementById('drpcompany').value == "0" && document.getElementById('drpcompany').disabled == false) {
        alert("Please Enter the Default Company Name");
        document.getElementById('drpcompany').focus();
        return false;
    }
    if (document.getElementById('drpcompanylist').value == "0" && document.getElementById('drpcompanylist').disabled == false) {
        alert("Please Enter the Company Name");
        document.getElementById('drpcompanylist').focus();
        return false;
    }
    var f_chk = 0;
    for (var t = 1; t < document.getElementById('drpcompanylist').options.length; t++) {
        if (document.getElementById('drpcompanylist').options[t].selected == true && document.getElementById('drpcompanylist').options[t].value == document.getElementById('drpcompany').value) {
            f_chk = 0;
            break;
        }
        else {
            f_chk = 1;
        }
    }
    if (f_chk == 1) {
        alert("Default Company Name does not Exist in the Selected Company List");
        document.getElementById('drpcompanylist').focus();
        return false;
    }
    var branchname = "";
    for (var li = 1; li < document.getElementById('txtbranchpermission').options.length; li++) {

        if (document.getElementById('txtbranchpermission').options[li].selected == true) {
            if (branchname == "")
                branchname = document.getElementById('txtbranchpermission').options[li].text;
            else
                branchname = branchname + "," + document.getElementById('txtbranchpermission').options[li].text;
        }

    }
    if (branchname != "") {
        if (!confirm("You have selected Branches :" + branchname + " Do you want to continue")) {
            return false;
        }
    }
    else {
        if (!confirm("No Branch is seleted, Do you want to continue")) {
            return false;
        }
    }
    //	else if(document.getElementById('txtcompcode').value=="0")
    //	{
    //	    alert("Please Enter the Company Code");
    //	    document.getElementById('txtcompcode').focus();
    //	    return false;
    //	}

    //dan
    var strtextd = "";
    var httpRequest = null;
    httpRequest = new XMLHttpRequest();
    if (httpRequest.overrideMimeType) {
        httpRequest.overrideMimeType('text/xml');
    }
    //httpRequest.onreadystatechange = function() {alertContents(httpRequest) };

    httpRequest.open("GET", "checksessiondan.aspx", false);
    httpRequest.send('');
    //alert(httpRequest.readyState);
    if (httpRequest.readyState == 4) {
        //alert(httpRequest.status);
        if (httpRequest.status == 200) {
            strtextd = httpRequest.responseText;
        }
        else {
            //alert('There was a problem with the request.');
            if (browser != "Microsoft Internet Explorer") {
                //alert(xmlObjMessage.childNodes[1].childNodes[21].childNodes[0].nodeValue);
            }
        }
    }
    if (strtextd != "sess") {
        alert('session expired');
        window.location.href = "Default.aspx";
        return false;
    }
    var username = document.getElementById('txtusername').value;
    var firstname = document.getElementById('txtfirstname').value;
    var lastname = document.getElementById('txtlastname').value;
    var password = document.getElementById('txtpwd').value;
    var userid = document.getElementById('txtuserid').value;
    var date_for = document.getElementById('drpdateformate').value;
    var company = document.getElementById('drpcompany').options[document.getElementById('drpcompany').selectedIndex].text;
    var companycode = document.getElementById('drpcompany').value;
    var mailid = document.getElementById('txtemail').value;
    var disc = document.getElementById('txtdisc').value;
    var filter = document.getElementById('drpfilter').value;
    var rolename = document.getElementById('drprole').value; 
    var editlines = document.getElementById('drpeditlines').value;
    var status = document.getElementById('drpstatus').value;
    var datestatus = document.getElementById('txtdatestatus').value;
    var dateformate = document.getElementById('hiddendateformat').value;
    if (disc == "")
        disc = "0";
    var companylist = "";
    for (t = 0; t < document.getElementById('drpcompanylist').options.length; t++) {
        if (document.getElementById('drpcompanylist').options[t].selected == true) {
            if (companylist == "")
                companylist = document.getElementById('drpcompanylist').options[t].value;
            else
                companylist = companylist + "," + document.getElementById('drpcompanylist').options[t].value;
        }
    }


    var currname = document.getElementById('drpcurrencycode').value;
    var retainername = document.getElementById('drpretainer').value;
    var agencycode = "";
    var comp_user = "";
    if (agencycode != "0" && agencycode != "") {
        comp_user = "Agency";
    }
    var user = "";
    var admin = "";
    if (document.getElementById('rbadmin').checked == true) {
        admin = "yes";
    }
    if (document.getElementById('rbuser').checked == true) {
        user = "yes";
    }

    // 	alert('rinki');
    var ip2 = document.getElementById('ip1').value;
    var empcode = document.getElementById('hdempcode').value;
    var acccode = document.getElementById('hdncashier').value;
    var mobno = document.getElementById('txtmob').value;
    var user_type = document.getElementById('drpuser_type').value;

    if (mod != "1" && mod != null) {

        Createuser.save(username, password, userid, date_for, company, companycode, currname, retainername, agencycode, user, admin, comp_user, companylist, mailid, disc, filter, rolename, editlines, ip2, firstname, lastname, status, empcode, acccode, mobno, user_type, datestatus, dateformate);
        var length = document.getElementById('txtbranchpermission').options.length;
        for (var li = 1; li < length; li++) {

            if (document.getElementById('txtbranchpermission').options[li].selected == true) {
                userflag = "Y";
                var branchcode = document.getElementById('txtbranchpermission').options[li].value;
            }
            else {
                userflag = "N";
                var branchcode = document.getElementById('txtbranchpermission').options[li].value;
            }
            datasend = datasend + userid + "~" + branchcode + "~" + userflag + "~" + companycode + "$$$";
            Createuser.savebranchpermission(userid, branchcode, userflag, companycode);
        }
        Createuser.insertlogData(datasend);


        document.getElementById('btnNew').disabled = false;
        document.getElementById('btnQuery').disabled = false;
        document.getElementById('btnCancel').disabled = false;
        document.getElementById('btnExit').disabled = false;
        document.getElementById('btnSave').disabled = true;
        document.getElementById('btnModify').disabled = true;
        document.getElementById('btnDelete').disabled = true;
        document.getElementById('btnExecute').disabled = true;
        document.getElementById('btnfirst').disabled = true;
        document.getElementById('btnnext').disabled = true;
        document.getElementById('btnprevious').disabled = true;
        document.getElementById('btnlast').disabled = true;
        /*new change ankur*/
        //if(document.getElementById('tdagencylabel').style.display=="block")
        //{
        document.getElementById('drpagency').value = "";

        document.getElementById('Hiddagency').value = "";
        document.getElementById('drpagency').disabled = true;
        document.getElementById('drpcompany').value = "0";
        document.getElementById('drpcompany').disabled = true;
        document.getElementById('drpcompanylist').value = "0";
        document.getElementById('drpcompanylist').disabled = true;
        document.getElementById('txtemail').value = "";
        document.getElementById('txtdisc').value = "";
        document.getElementById('drpfilter').value = "0";
        document.getElementById('txtemail').disabled = true;
        document.getElementById('txtdisc').disabled = true;
        document.getElementById('txtbranchpermission').value = "0";
        document.getElementById('txtbranchpermission').disabled = true;
        //document.getElementById('txtmob').value = "";
        document.getElementById('txtmob').disabled = true;
        alert("Data Saved Successfully");
        cancelclick('Createuser');
        return false;

    }
    else {

        if (glaobal1 != mailid)
        checkEmail(mailid);
        var acccode = document.getElementById('hdncashier').value;
        var empcode = document.getElementById('hdempcode').value;
        var acccode = document.getElementById('hdncashier').value;
        var executive= "";
        var mail="";
        var extra1 = document.getElementById('txtmob').value;
        var extra2 ="";
        var extra3 = "";
        var extra4 = "";
        var extra5 = "";
        var u_type = document.getElementById('drpuser_type').value;

       Createuser.modify(username, password, userid, date_for, company, companycode, currname, retainername, agencycode, user, admin, comp_user, companylist, mailid, disc, filter, rolename, editlines, firstname, lastname, status, extra1, extra2, extra3, extra4, extra5,ip2, empcode,acccode,u_type,datestatus,dateformate);
       
        var length = document.getElementById('txtbranchpermission').options.length;
        for (var li = 1; li < length; li++) {

            if (document.getElementById('txtbranchpermission').options[li].selected == true) {
                userflag = "Y";
                var branchcode = document.getElementById('txtbranchpermission').options[li].value;
            }
            else {
                userflag = "N";
                var branchcode = document.getElementById('txtbranchpermission').options[li].value;
            }
            datasend = datasend + userid + "~" + branchcode + "~" + userflag + "~" + companycode + "$$$";
            Createuser.updatebranchpermission(userid, branchcode, userflag, companycode);


        }
        Createuser.insertlogData(datasend);
        dsexecute.Tables[0].Rows[z].username = document.getElementById('txtusername').value;
        dsexecute.Tables[0].Rows[z].FIRSTNAME = document.getElementById('txtfirstname').value;
        dsexecute.Tables[0].Rows[z].LASTNAME = document.getElementById('txtlastname').value;
        dsexecute.Tables[0].Rows[z].userid = document.getElementById('txtuserid').value;
        dsexecute.Tables[0].Rows[z].comp_name = document.getElementById('drpcompany').options[document.getElementById('drpcompany').selectedIndex].text;
        dsexecute.Tables[0].Rows[z].COM_CODE = document.getElementById('drpcompany').value;
        //dsexecute.Tables[0].Rows[z].EMAIL=document.getElementById('txtemail').value;
        dsexecute.Tables[0].Rows[z].retainer_code = document.getElementById('drpretainer').value;
        dsexecute.Tables[0].Rows[z].curr_code = document.getElementById('drpcurrencycode').value;
        dsexecute.Tables[0].Rows[z].password = document.getElementById('drpcurrencycode').value;
        dsexecute.Tables[0].Rows[z].date_format = document.getElementById('drpdateformate').value;
        dsexecute.Tables[0].Rows[z].USER_COMPANY = document.getElementById('drpcompanylist').value;
        dsexecute.Tables[0].Rows[z].DISCOUNT = document.getElementById('txtdisc').value;
        dsexecute.Tables[0].Rows[z].FILTER = document.getElementById('drpfilter').value;
        dsexecute.Tables[0].Rows[z].ROLEID = document.getElementById('drprole').value;
        dsexecute.Tables[0].Rows[z].STATUS = document.getElementById('drpstatus').value;
        dsexecute.Tables[0].Rows[z].HE_CODE = document.getElementById('txtemcode').value;
        alert("Data Updated Successfully");
        cancelclick('Createuser');
        document.getElementById('tbcashier').disabled = true;
        document.getElementById('txtusername').disabled = true;
        document.getElementById('txtfirstname').disabled = true;
        document.getElementById('txtlastname').disabled = true;
        document.getElementById('txtpwd').disabled = true;
        document.getElementById('drpdateformate').disabled = true;
        document.getElementById('drpcompany').disabled = true;
        document.getElementById('drpcompanylist').disabled = true;
        document.getElementById('txtbranchpermission').disabled = true;
        document.getElementById('txtemail').disabled = true;
        document.getElementById('txtdisc').disabled = true;
        document.getElementById('drpfilter').disabled = true;
        document.getElementById('drpcurrencycode').disabled = true;
        document.getElementById('drpeditlines').disabled = true;
        document.getElementById('drpretainer').disabled = true;
        document.getElementById('drprole').disabled = true;
        document.getElementById('drpstatus').disabled = true;
        document.getElementById('txtemcode').disabled = true;
        /*new change ankur*/
        // if(document.getElementById('tdagencylabel').style.display=="block")
        //{

        document.getElementById('drpagency').disabled = true;
        document.getElementById('drpcompany').disabled = true;
        //document.getElementById('drpagency').value=
        //}
        document.getElementById('rbadmin').disabled = true;
        document.getElementById('rbuser').disabled = true;

        document.getElementById('btnSave').disabled = true;



        updateStatus();
        if (z == 0) {
            document.getElementById('btnfirst').disabled = true;
            document.getElementById('btnprevious').disabled = true;
        }

        if (z == (dsexecute.Tables[0].Rows.length - 1)) {
            document.getElementById('btnnext').disabled = true;
            document.getElementById('btnlast').disabled = true;
        }

        mod = "0";
        document.getElementById('btnModify').disabled = false;

    }
    glaobal1 = '';
    setButtonImages();
    return false;
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

/*********************************************Auto Generate***********************/
function autoornot() {

    //    if(hiddentext=="new" )
    //    {
    document.getElementById('txtusername').value = document.getElementById('txtusername').value.toUpperCase();
    if (document.getElementById('hiddenauto').value == 1) {
        changeoccured();
        //return false;
    }
    else {
        userdefine();

        // return false;
    }
    //}
    //return false;
}

function changeoccured() {
    if (hiddentext == "new") {

        document.getElementById('txtusername').value = trim(document.getElementById('txtusername').value);
        lstr = document.getElementById('txtusername').value;
        cstr = lstr.substring(0, 1);
        var mstr = "";

        if (lstr.indexOf(" ") == 1) {
            var leng = lstr.length;
            mstr = cstr + lstr.substring(2, leng);
        }
        else {
            var leng = lstr.length;
            mstr = cstr + lstr.substring(1, leng);
        }

        if (document.getElementById('txtusername').value != "") {

            //document.getElementById('txtusername').value=document.getElementById('txtusername').value.toUpperCase();

            // str=document.getElementById('txtzonename').value;
            str = mstr;
            Createuser.userauto(str, document.getElementById('drpretainer').value, fillcall);
            //return false;
        }
    }
    //    else
    //    {
    //        document.getElementById('txtusername').value=document.getElementById('txtusername').value.toUpperCase();
    //    }
    return false;
}


function fillcall(res) {
    var ds = res.value;
    var newstr;
    if (hiddentext == "new") {
        if (ds.Tables[0].Rows.length != 0) {
            alert("This User Name has already been assigned !! ");

            document.getElementById('txtusername').value = "";
            document.getElementById('txtpwd').value = "";
            document.getElementById('txtuserid').value = "";
            document.getElementById('drpdateformate').value = "0";
            document.getElementById('drpcompany').value = "0";
            document.getElementById('drpcompanylist').value = "0";
            //            document.getElementById('txtcompname').value="";
            //            document.getElementById('txtcompcode').value="";
            document.getElementById('drpcurrencycode').value = "0";
            document.getElementById('drpretainer').value = "0";
            document.getElementById('txtusername').focus();


            return false;
        }
        else {
            if (ds.Tables[1].Rows.length == 0) {
                newstr = null;
            }
            else {
                newstr = ds.Tables[1].Rows[0].userid;
            }
            if (newstr == 0) {
                document.getElementById('txtuserid').value = str.substr(0, 2) + "1";

            }
            else if (newstr >= 1) {
                var Autoincrement = parseInt(ds.Tables[1].Rows[0].userid) + 1;
                document.getElementById('txtuserid').value = str.substr(0, 2) + Autoincrement;
            }
            else if (newstr != null) {
                document.getElementById('txtusername').value = trim(document.getElementById('txtusername').value);
                var code = newstr.substr(2, 4);
                var code = newstr;
                code++;
                document.getElementById('txtuserid').value = str.substr(0, 2) + code;

            }
            else {
                document.getElementById('txtuserid').value = str.substr(0, 2) + "0";

            }

        }
    }
}

function userdefine() {
    if (hiddentext == "new") {
        var admin = "";
        if (document.getElementById('rbadmin').checked == true) {
            admin = "yes";
        }
        document.getElementById('txtuserid').disabled = false;
        document.getElementById('txtusername').value = document.getElementById('txtusername').value.toUpperCase();
        auto = document.getElementById('hiddenauto').value;
        var cuserid = document.getElementById('txtuserid').value;
        var cusername = document.getElementById('txtusername').value;
        var branchname = document.getElementById('drpretainer').value;
        Createuser.chkuserid(cuserid, cusername, branchname, callBack_userdefine);
        // return false;
    }

    return;
}

function callBack_userdefine(response) {
    var ds = response.value;
    if (ds.Tables[0].Rows.length > 0) {
        //         if(ds.Tables[0].Rows[0].userid==document.getElementById('txtuserid').value)
        //        {
        //            alert("This User Id has already been assigned !! ");
        //            document.getElementById('txtuserid').value="";
        //            document.getElementById('drpretainer').value="0";
        //            document.getElementById('txtuserid').focus();
        //            return false;
        //        }
        //        else   
        if (ds.Tables[0].Rows[0].username == document.getElementById('txtusername').value) {
            alert("This User Name has already been assigned !! ");
            document.getElementById('txtusername').value = "";
            document.getElementById('drpretainer').value = "0";
            document.getElementById('txtusername').focus();
            return false;
        }
    }

}
function callBack_userdefine1(response) {
    var ds = response.value;
    if (ds.Tables[0].Rows.length > 0) {

        if (ds.Tables[0].Rows[0].username == document.getElementById('txtusername').value) {
            alert("This User Name has already been assigned !! ");
            document.getElementById('drpretainer').value = "0";
            document.getElementById('drpretainer').focus();
            return false;
        }
    }

}
function chkuserid() {
    var cuserid = document.getElementById('txtuserid').value;
    var cusername = document.getElementById('txtusername').value;
    var branchname = document.getElementById('drpretainer').value;
    var res2 = Createuser.chkuserid(cuserid, cusername, branchname);
    var ds = res2.value;
    if (ds.Tables[0].Rows.length > 0) {
        if (ds.Tables[0].Rows[0].userid == document.getElementById('txtuserid').value) {
            alert("This User Id has already been assigned !! ");
            document.getElementById('txtuserid').value = "";
            document.getElementById('drpretainer').value = "0";
            document.getElementById('txtuserid').focus();
            return false;
        }
    }
}

function LTrim(value) {

    var re = /\s*((\S+\s*)*)/;
    return value.replace(re, "$1");

}

// Removes ending whitespaces
function RTrim(value) {

    var re = /((\s*\S+)*)\s*/;
    return value.replace(re, "$1");

}

// Removes leading and ending whitespaces
function trim(value) {

    return LTrim(RTrim(value));

}

function queryclick() {
    cancelclick('Createuser');
    document.getElementById('tbcashier').value = "";
    document.getElementById('txtdatestatus').disabled = true;
    document.getElementById('txtdatestatus').value = "";
    document.getElementById('txtusername').value = "";
    document.getElementById('txtfirstname').value = "";
    document.getElementById('txtlastname').value = "";
    document.getElementById('txtuserid').value = "";
    document.getElementById('drpcompany').value = "0";
    document.getElementById('drpcompanylist').value = "0";
    z = 0;
    document.getElementById('rbadmin').disabled = false;
    document.getElementById('tbcashier').disabled = true;
    document.getElementById('rbuser').disabled = false;
    document.getElementById('txtusername').disabled = false;
    document.getElementById('txtuserid').disabled = false;
    //document.getElementById('txtemail').disabled=false;
    document.getElementById('drpcompany').disabled = false;
    document.getElementById('drpuser_type').disabled = true;
    chkstatus(FlagStatus);
    document.getElementById('txtemcode').disabled = true;
    document.getElementById('btnQuery').disabled = true;
    document.getElementById('txtdisc').disabled = true;
    document.getElementById('drpfilter').disabled = true;
    document.getElementById('btnExecute').disabled = false;
    document.getElementById('btnNew').disabled = true;
    document.getElementById('btnSave').disabled = true;
    
    setButtonImages();
    hiddentext = "query";
    document.getElementById('txtemcode').value = "";
    setButtonImages();
    return false;
}

function executeclick() {


    z = 0;
    glaobal1 = ''
    glaobusername = document.getElementById('txtusername').value;
    glaobaluserid = document.getElementById('txtuserid').value; ;
    glaobalcompcode = document.getElementById('drpcompany').value;
    if (glaobalcompcode == "0")
        glaobalcompcode = "";
    //glaobusername=subcatname;

    var admin = "";
    if (document.getElementById('rbadmin').checked == true) {
        admin = "yes";
    }

    //dan
    var strtextd = "";
    var httpRequest = null;
    httpRequest = new XMLHttpRequest();
    if (httpRequest.overrideMimeType) {
        httpRequest.overrideMimeType('text/xml');
    }
    //httpRequest.onreadystatechange = function() {alertContents(httpRequest) };

    httpRequest.open("GET", "checksessiondan.aspx", false);
    httpRequest.send('');
    //alert(httpRequest.readyState);
    if (httpRequest.readyState == 4) {
       // alert(httpRequest.status);
        if (httpRequest.status == 200) {
            strtextd = httpRequest.responseText;
        }
        else {
          //  alert('There was a problem with the request.');
            if (browser != "Microsoft Internet Explorer") {
                //alert(xmlObjMessage.childNodes[1].childNodes[21].childNodes[0].nodeValue);
            }
        }
    }
    if (strtextd != "sess") {
        alert('session expired');
        window.location.href = "Default.aspx";
        return false;
    }
    //BillStatus.billexecute1(companycode,zonecode,zonename,alias,UserId,checkcall);
    var res = Createuser.userexecute(glaobusername, glaobaluserid, glaobalcompcode, admin);

    checkcall(res)

    updateStatus();
    document.getElementById('drpstatus').disabled = true;
    document.getElementById('rbadmin').disabled = true;
    document.getElementById('rbuser').disabled = true;
    document.getElementById('txtusername').disabled = true;
    document.getElementById('txtuserid').disabled = true;
    document.getElementById('drpcompany').disabled = true;
    document.getElementById('drpcompanylist').disabled = true;
    mod = "0";
    document.getElementById('btnfirst').disabled = true;
    document.getElementById('btnnext').disabled = false;
    document.getElementById('btnprevious').disabled = true;
    document.getElementById('btnlast').disabled = false;
    document.getElementById('btnModify').disabled = false;

    document.getElementById('btnNew').disabled = true;
    document.getElementById('btnExecute').disabled = true;


    document.getElementById('btnDelete').disabled = false;

    setButtonImages();
    return false;
}
function CHKDATE(userdate) {
    var mycondate = ""

    if (userdate == null || userdate == "") {
        mycondate = ""
        return mycondate
    }
    else {
        var spmonth = "'" + userdate + "'";
        var pp = spmonth.split(" ");
        var mon = pp[1];
        var myDate = new Date(userdate);
        var date = myDate.getDate();
        var month = myDate.getMonth() + 1;
        var year = myDate.getFullYear();

        var dateformat = document.getElementById('hiddendateformat').value;
        if (dateformat == "dd/mm/yyyy") {
            if (date == "8") {
                date = "0" + date;
            }
            else if (date == "1") {
                date = "0" + date;
            }
            else if (date == "2") {
                date = "0" + date;
            }
            else if (date == "3") {
                date = "0" + date;
            }
            else if (date == "4") {
                date = "0" + date;
            }
            else if (date == "5") {
                date = "0" + date;
            }
            else if (date == "6") {
                date = "0" + date;
            }
            else if (date == "7") {
                date = "0" + date;
            }
            else if (date == "8") {
                date = "0" + date;
            }
            else if (date == "9") {
                date = "0" + date;
            }
            if (month == "1") {
                month = "0" + month;
            }
            else if (month == "2") {
                month = "0" + month;
            }
            else if (month == "3") {
                month = "0" + month;
            }
            else if (month == "4") {
                month = "0" + month;
            }
            else if (month == "5") {
                month = "0" + month;
            }
            else if (month == "6") {
                month = "0" + month;
            }
            else if (month == "7") {
                month = "0" + month;
            }
            else if (month == "8") {
                month = "0" + month;
            }
            else if (month == "9") {
                month = "0" + month;
            }

            mycondate = date + "/" + month + "/" + year;
        }
        else if (dateformat == "mm/dd/yyyy") {
            mycondate = month + "/" + date + "/" + year;
        }
        else {
            mycondate = year + "/" + month + "/" + date;
        }
        return mycondate;

    }
}
//*******************************************************************************//
//********************This Is The Responce Of The Execute Button*****************//
//*******************************************************************************//	
function checkcall(response) {
    dsexecute = response.value;
    if (dsexecute.Tables[0].Rows.length > 0) {


        if (dsexecute.Tables[0].Rows[0].STATUS_CHANGE_DATE != null && dsexecute.Tables[0].Rows[0].STATUS_CHANGE_DATE != "")
            document.getElementById('txtdatestatus').value = CHKDATE(dsexecute.Tables[0].Rows[0].STATUS_CHANGE_DATE);
        else
            document.getElementById('txtdatestatus').value = "";




        if (dsexecute.Tables[0].Rows[0].STATUS != null && dsexecute.Tables[0].Rows[0].STATUS != "")
            document.getElementById('drpstatus').value = dsexecute.Tables[0].Rows[0].STATUS;
        else
            document.getElementById('drpstatus').value = "A";

        document.getElementById('txtusername').value = dsexecute.Tables[0].Rows[0].username;
        if (dsexecute.Tables[0].Rows[0].FIRSTNAME == null)
            document.getElementById('txtfirstname').value = "";
        else
            document.getElementById('txtfirstname').value = dsexecute.Tables[0].Rows[0].FIRSTNAME;
        if (dsexecute.Tables[0].Rows[0].LASTNAME == null)
            document.getElementById('txtlastname').value = "";
        else
            document.getElementById('txtlastname').value = dsexecute.Tables[0].Rows[0].LASTNAME;
        document.getElementById('txtuserid').value = dsexecute.Tables[0].Rows[0].userid;
        document.getElementById('drpcompany').value = dsexecute.Tables[0].Rows[0].COM_CODE;

        var glbruserid = dsexecute.Tables[0].Rows[0].userid;
        glbrcomcode = dsexecute.Tables[0].Rows[0].COM_CODE;
        //document.getElementById('txtemail').value=dsexecute.Tables[0].Rows[0].EMAIL;
        if (dsexecute.Tables[0].Rows[0].EMAIL == null) {
            document.getElementById('txtemail').value = "";
        }
        else {
            document.getElementById('txtemail').value = dsexecute.Tables[0].Rows[0].EMAIL;
        }
        if (dsexecute.Tables[0].Rows[0].MOBILENO == null) {
            document.getElementById('txtmob').value = "";
        }
        else {
            document.getElementById('txtmob').value = dsexecute.Tables[0].Rows[0].MOBILENO;
        }

        if (dsexecute.Tables[0].Rows[0].DISCOUNT == null) {
            document.getElementById('txtdisc').value = "";
        }
        else {
            document.getElementById('txtdisc').value = dsexecute.Tables[0].Rows[0].DISCOUNT;
        }

        if (dsexecute.Tables[0].Rows[0].FILTER == null) {
            document.getElementById('drpfilter').value = "0";
        }
        else {
            document.getElementById('drpfilter').value = dsexecute.Tables[0].Rows[0].FILTER;
        }


        if ((dsexecute.Tables[0].Rows[0].HR_CODE != null) && (dsexecute.Tables[0].Rows[0].HR_CODE != "")) {
            document.getElementById('txtemcode').value = dsexecute.Tables[0].Rows[0].HR_CODE;
            var empcode1 = dsexecute.Tables[0].Rows[0].HR_CODE; ;
            var empcodearr = empcode1.split("(");
            var empcodesplit = empcodearr[1];
            empcodesplit = empcodesplit.replace(")", "");
            document.getElementById("hdempcode").value = empcodesplit;
        }
        else {
            document.getElementById('txtemcode').value = "";
        }


        if (dsexecute.Tables[0].Rows[0].ACC_CODE == null) {
            document.getElementById('hdncashier').value = "";
        }
        else {
            document.getElementById('hdncashier').value = dsexecute.Tables[0].Rows[0].ACC_CODE;
        }


        if (dsexecute.Tables[0].Rows[0].ACC_NAME == null) {
            document.getElementById('tbcashier').value = "";
        }
        else {
            document.getElementById('tbcashier').value = dsexecute.Tables[0].Rows[0].ACC_NAME;
        }
        if (dsexecute.Tables[0].Rows[0].USER_TYPE == null) {
            document.getElementById('drpuser_type').value = "W";
        }
        else {
            document.getElementById('drpuser_type').value = dsexecute.Tables[0].Rows[0].USER_TYPE;
        }





        //         if(dsexecute.Tables[0].Rows[0].retainer_code!=null)
        //			        document.getElementById('drpretainer').options[0]=new Option(dsexecute.Tables[0].Rows[0].retainer_name,dsexecute.Tables[0].Rows[0].retainer_code);

        document.getElementById('drpretainer').value = dsexecute.Tables[0].Rows[0].retainer_code;
        document.getElementById('drpcurrencycode').value = dsexecute.Tables[0].Rows[0].curr_code;
        document.getElementById('txtpwd').value = ConveretPassword(dsexecute.Tables[0].Rows[0].password);
        document.getElementById('drpdateformate').value = dsexecute.Tables[0].Rows[0].date_format;
        
        document.getElementById('drprole').value = dsexecute.Tables[0].Rows[0].ROLEID;
        document.getElementById('drpeditlines').value = dsexecute.Tables[0].Rows[0].BOOKING_EDITLINES;

        var companylist = dsexecute.Tables[0].Rows[0].USER_COMPANY;
        for (var t = 0; t < document.getElementById('drpcompanylist').options.length; t++) {
            document.getElementById('drpcompanylist').options[t].selected = false;
        }
        if (companylist != "" && companylist != null) {
            var data = companylist.split(",");
            for (var t = 0; t < data.length; t++) {
                for (var n = 1; n < document.getElementById('drpcompanylist').options.length; n++) {
                    if (data[t] == document.getElementById('drpcompanylist').options[n].value) {
                        document.getElementById('drpcompanylist').options[n].selected = true;
                    }

                }
            }
        }
        //if(document.getElementById('tdagencylabel').style.display=="block")
        //{
        document.getElementById('txtemail').disabled = true;
        document.getElementById('txtdisc').disabled = true;
        document.getElementById('drpfilter').disabled = true;
        document.getElementById('drpuser_type').disabled = true;
         document.getElementById('drpagency').disabled = true;
        document.getElementById('drpcompany').disabled = true;
        document.getElementById('drprole').disabled = true;
        document.getElementById('drpeditlines').disabled = true;
        document.getElementById('drpuser_type').disabled = false;
        document.getElementById('drpagency').value = dsexecute.Tables[0].Rows[0].AGENCY_NAME;
        document.getElementById('Hiddagency').value = dsexecute.Tables[0].Rows[0].Agency_code;
        //}			

        if (dsexecute.Tables[0].Rows[0].Admin == "yes") {
            document.getElementById('rbadmin').checked = true;
            document.getElementById('rbuser').checked = false;
        }
        else {
            document.getElementById('rbuser').checked = true;
            document.getElementById('rbadmin').checked = false;
        }
        //------------------------new added--------------------------------------------------//

        var dsbranch = Createuser.branchexecute(glbruserid, dsexecute.Tables[0].Rows[0].COM_CODE);
        if (dsbranch.value == null) {
            var res = dsbranch.value;
            alert(dsbranch.error.description);
            return false;
        }
        document.getElementById('txtbranchpermission').options[0].selected = false;
        var branchlen = dsbranch.value.Tables[0].Rows.length;
        var flaglen = dsbranch.value.Tables[1].Rows.length;
        for (var a = 0; a < document.getElementById('txtbranchpermission').options.length; a++)  //document.getElementById('txtbranchpermission').options.length
        {
            document.getElementById('txtbranchpermission').options[a].selected = false;
        }
        for (var a = 0; a < parseInt(document.getElementById('txtbranchpermission').options.length); a++) {
            for (var i = 0; i < flaglen; i++) {
                //if(dsbranch.value.Tables[0].Rows[a].branchcode==dsbranch.value.Tables[1].Rows[i].branchcode)
                if (document.getElementById('txtbranchpermission').options[a].value == dsbranch.value.Tables[1].Rows[i].branchcode) {
                    document.getElementById('txtbranchpermission').options[a].selected = true;
                    // document.getElementById('txtbranchpermission').options[a].selected=true; 
                    i = flaglen;
                }
            }
        }
        // ------------ end -----------------------------------------------------------------//

    }

    else {
        alert("Your Search Produce No Result!!!!");

        document.getElementById('txtusername').value = "";
        document.getElementById('txtuserid').value = "";
        document.getElementById('drpcompany').value = "0";
        document.getElementById('btnModify').disabled = true;
        cancelclick('Createuser');
    }

    if (dsexecute.Tables[0].Rows.length == 1) {
        document.getElementById('btnfirst').disabled = true;
        document.getElementById('btnnext').disabled = false;
        document.getElementById('btnprevious').disabled = true;
        document.getElementById('btnlast').disabled = false;
    }
    setButtonImages();
    document.getElementById('btnnext').disabled = false;
    document.getElementById('btnlast').disabled = false;
    return false;
}

//*******************************************************************************//
//********************This Function For First Button*******************//
//*******************************************************************************//	
function firstcall() {
    z = 0;
    if (dsexecute.Tables[0].Rows[z].STATUS_CHANGE_DATE != null && dsexecute.Tables[0].Rows[z].STATUS_CHANGE_DATE != "")
        document.getElementById('txtdatestatus').value = CHKDATE(dsexecute.Tables[0].Rows[z].STATUS_CHANGE_DATE);
    else
        document.getElementById('txtdatestatus').value = "";

    if (dsexecute.Tables[0].Rows[z].STATUS != null && dsexecute.Tables[0].Rows[z].STATUS != "")
        document.getElementById('drpstatus').value = dsexecute.Tables[0].Rows[z].STATUS;
    else
        document.getElementById('drpstatus').value = "A";

    document.getElementById('txtusername').value = dsexecute.Tables[0].Rows[z].username;
    if (dsexecute.Tables[0].Rows[z].FIRSTNAME == null)
        document.getElementById('txtfirstname').value = "";
    else

        document.getElementById('txtfirstname').value = dsexecute.Tables[0].Rows[z].FIRSTNAME;
    if (dsexecute.Tables[0].Rows[z].LASTNAME == null)
        document.getElementById('txtlastname').value = "";
    else
        document.getElementById('txtlastname').value = dsexecute.Tables[0].Rows[z].LASTNAME;
    document.getElementById('txtuserid').value = dsexecute.Tables[0].Rows[z].userid;
    var glbruserid = dsexecute.Tables[0].Rows[z].userid;
    document.getElementById('drpcompany').value = dsexecute.Tables[0].Rows[z].COM_CODE;
    document.getElementById('drprole').value = dsexecute.Tables[0].Rows[z].ROLEID;
    document.getElementById('drpeditlines').value = dsexecute.Tables[0].Rows[z].BOOKING_EDITLINES;
    //document.getElementById('txtemail').value=dsexecute.Tables[0].Rows[z].EMAIL;
    if (dsexecute.Tables[0].Rows[z].EMAIL == null) {
        document.getElementById('txtemail').value = "";
    }
    else {
        document.getElementById('txtemail').value = dsexecute.Tables[0].Rows[z].EMAIL;
    }
    if (dsexecute.Tables[0].Rows[z].MOBILENO == null) {
        document.getElementById('txtmob').value = "";
    }
    else {
        document.getElementById('txtmob').value = dsexecute.Tables[0].Rows[z].MOBILENO;
    }

    if (dsexecute.Tables[0].Rows[z].DISCOUNT == null) {
        document.getElementById('txtdisc').value = "";
    }
    else {
        document.getElementById('txtdisc').value = dsexecute.Tables[0].Rows[z].DISCOUNT;
    }
    if (dsexecute.Tables[0].Rows[z].FILTER == null) {
        document.getElementById('drpfilter').value = "0";
    }
    else {
        document.getElementById('drpfilter').value = dsexecute.Tables[0].Rows[z].FILTER;
    }

    if ((dsexecute.Tables[0].Rows[z].HR_CODE != null) && (dsexecute.Tables[0].Rows[z].HR_CODE != "")) {
        document.getElementById('txtemcode').value = dsexecute.Tables[0].Rows[z].HR_CODE;
        var empcode1 = dsexecute.Tables[0].Rows[z].HR_CODE; ;
        var empcodearr = empcode1.split("(");
        var empcodesplit = empcodearr[1];
        empcodesplit = empcodesplit.replace(")", "");
        document.getElementById("hdempcode").value = empcodesplit;
    }
    else {
        document.getElementById('txtemcode').value = "";
    }

    if (dsexecute.Tables[0].Rows[z].ACC_CODE == null) {
        document.getElementById('hdncashier').value = "";
    }
    else {
        document.getElementById('hdncashier').value = dsexecute.Tables[0].Rows[z].ACC_CODE;
    }


    if (dsexecute.Tables[0].Rows[z].ACC_NAME == null) {
        document.getElementById('tbcashier').value = "";
    }
    else {
        document.getElementById('tbcashier').value = dsexecute.Tables[0].Rows[z].ACC_NAME;
    }




    document.getElementById('drpretainer').value = dsexecute.Tables[0].Rows[z].retainer_code;
    document.getElementById('drpcurrencycode').value = dsexecute.Tables[0].Rows[z].curr_code;
    document.getElementById('txtpwd').value = ConveretPassword(dsexecute.Tables[0].Rows[z].password);
    document.getElementById('drpdateformate').value = dsexecute.Tables[0].Rows[z].date_format;
    if(dsexecute.Tables[0].Rows[z].USER_TYPE!=null)
        {
        document.getElementById('drpuser_type').value = dsexecute.Tables[0].Rows[z].USER_TYPE;
        }
        else
        {
            document.getElementById('drpuser_type').value ="W";
        }

    var companylist = dsexecute.Tables[0].Rows[z].USER_COMPANY;
    for (var t = 0; t < document.getElementById('drpcompanylist').options.length; t++) {
        document.getElementById('drpcompanylist').options[t].selected = false;
    }
    if (companylist != "" && companylist != null) {
        var data = companylist.split(",");
        for (t = 0; t < data.length; t++) {
            for (var n = 1; n < document.getElementById('drpcompanylist').options.length; n++) {
                if (data[t] == document.getElementById('drpcompanylist').options[n].value) {
                    document.getElementById('drpcompanylist').options[n].selected = true;
                }

            }
        }
    }
    /*new change ankur */
    //if(document.getElementById('tdagencylabel').style.display=="block")
    //{
    document.getElementById('tbcashier').disabled = true;
    document.getElementById('txtemail').disabled = true;
    document.getElementById('txtdisc').disabled = true;
    document.getElementById('drpfilter').disabled = true;
    document.getElementById('drpagency').disabled = true;
    document.getElementById('drpcompany').disabled = true;
    document.getElementById('drprole').disabled = true;
    document.getElementById('drpagency').value = dsexecute.Tables[0].Rows[z].AGENCY_NAME;
    document.getElementById('Hiddagency').value = dsexecute.Tables[0].Rows[z].Agency_code;
    //}	

    if (dsexecute.Tables[0].Rows[z].Admin == "yes") {
        document.getElementById('rbadmin').checked = true;
        document.getElementById('rbuser').checked = false;
    }
    else {
        document.getElementById('rbuser').checked = true;
        document.getElementById('rbadmin').checked = false;
    }

    //------------------------new added--------------------------------------------------//

    var dsbranch = Createuser.branchexecute(glbruserid, dsexecute.Tables[0].Rows[z].COM_CODE);
    if (dsbranch.value == null) {
        var res = dsbranch.value;
        alert(dsbranch.error.description);
        return false;
    }
    document.getElementById('txtbranchpermission').options[0].selected = false;
    var branchlen = dsbranch.value.Tables[0].Rows.length;
    var flaglen = dsbranch.value.Tables[1].Rows.length;
    for (var t1 = 0; t1 < document.getElementById('txtbranchpermission').options.length; t1++) {
        document.getElementById('txtbranchpermission').options[t1].selected = false;
    }
    for (var a = 0; a < parseInt(document.getElementById('txtbranchpermission').options.length); a++) {
        for (var i = 0; i < flaglen; i++) {
            if (document.getElementById('txtbranchpermission').options[a].value == dsbranch.value.Tables[1].Rows[i].branchcode) {
                document.getElementById('txtbranchpermission').options[a].selected = true;
                i = flaglen;
            }
        }
    }
    // ------------ end -----------------------------------------------------------------//
    updateStatus();

    document.getElementById('btnfirst').disabled = true;
    document.getElementById('btnprevious').disabled = true;
    document.getElementById('btnnext').disabled = false;
    document.getElementById('btnlast').disabled = false;
    setButtonImages();
    return false;
}

//*******************************************************************************//
//********************This Function For Previous Button****************//
//*******************************************************************************//
function previouscall() {

    var a = dsexecute.Tables[0].Rows.length;
    z--;
    if (z != -1) {
        if (z >= 0 && z <= a - 1) {

            if (dsexecute.Tables[0].Rows[z].STATUS_CHANGE_DATE != null && dsexecute.Tables[0].Rows[z].STATUS_CHANGE_DATE != "")
                document.getElementById('txtdatestatus').value = CHKDATE(dsexecute.Tables[0].Rows[z].STATUS_CHANGE_DATE);
            else
                document.getElementById('txtdatestatus').value = "";

            if (dsexecute.Tables[0].Rows[z].STATUS != null && dsexecute.Tables[0].Rows[z].STATUS != "")
                document.getElementById('drpstatus').value = dsexecute.Tables[0].Rows[z].STATUS;
            else
                document.getElementById('drpstatus').value = "A";

            document.getElementById('txtusername').value = dsexecute.Tables[0].Rows[z].username;
            if (dsexecute.Tables[0].Rows[z].FIRSTNAME == null)
                document.getElementById('txtfirstname').value = "";
            else

                document.getElementById('txtfirstname').value = dsexecute.Tables[0].Rows[z].FIRSTNAME;
            if (dsexecute.Tables[0].Rows[z].LASTNAME == null)
                document.getElementById('txtlastname').value = "";
            else
                document.getElementById('txtlastname').value = dsexecute.Tables[0].Rows[z].LASTNAME;
            document.getElementById('txtuserid').value = dsexecute.Tables[0].Rows[z].userid;
            var glbruserid = dsexecute.Tables[0].Rows[z].userid;
            document.getElementById('drpcompany').value = dsexecute.Tables[0].Rows[z].COM_CODE;
            document.getElementById('drprole').value = dsexecute.Tables[0].Rows[z].ROLEID;
            document.getElementById('drpeditlines').value = dsexecute.Tables[0].Rows[z].BOOKING_EDITLINES;
            //document.getElementById('txtemail').value=dsexecute.Tables[0].Rows[z].EMAIL;
            if (dsexecute.Tables[0].Rows[z].EMAIL == null) {
                document.getElementById('txtemail').value = "";
            }
            else {
                document.getElementById('txtemail').value = dsexecute.Tables[0].Rows[z].EMAIL;
            }
            if (dsexecute.Tables[0].Rows[z].MOBILENO == null) {
                document.getElementById('txtmob').value = "";
            }
            else {
                document.getElementById('txtmob').value = dsexecute.Tables[0].Rows[z].MOBILENO;
            }

            if (dsexecute.Tables[0].Rows[z].DISCOUNT == null) {
                document.getElementById('txtdisc').value = "";
            }
            else {
                document.getElementById('txtdisc').value = dsexecute.Tables[0].Rows[z].DISCOUNT;
            }
            if (dsexecute.Tables[0].Rows[z].FILTER == null) {
                document.getElementById('drpfilter').value = "0";
            }
            else {
                document.getElementById('drpfilter').value = dsexecute.Tables[0].Rows[z].FILTER;
            }

            if ((dsexecute.Tables[0].Rows[z].HR_CODE != null) && (dsexecute.Tables[0].Rows[z].HR_CODE != "")) {
                document.getElementById('txtemcode').value = dsexecute.Tables[0].Rows[z].HR_CODE;
                var empcode1 = dsexecute.Tables[0].Rows[z].HR_CODE; ;
                var empcodearr = empcode1.split("(");
                var empcodesplit = empcodearr[1];
                empcodesplit = empcodesplit.replace(")", "");
                document.getElementById("hdempcode").value = empcodesplit;
            }
            else {
                document.getElementById('txtemcode').value = "";
            }


            if (dsexecute.Tables[0].Rows[z].ACC_CODE == null) {
                document.getElementById('hdncashier').value = "";
            }
            else {
                document.getElementById('hdncashier').value = dsexecute.Tables[0].Rows[z].ACC_CODE;
            }


            if (dsexecute.Tables[0].Rows[z].ACC_NAME == null) {
                document.getElementById('tbcashier').value = "";
            }
            else {
                document.getElementById('tbcashier').value = dsexecute.Tables[0].Rows[z].ACC_NAME;
            }




            document.getElementById('drpretainer').value = dsexecute.Tables[0].Rows[z].retainer_code;
            document.getElementById('drpcurrencycode').value = dsexecute.Tables[0].Rows[z].curr_code;
            document.getElementById('txtpwd').value = ConveretPassword(dsexecute.Tables[0].Rows[z].password);
            document.getElementById('drpdateformate').value = dsexecute.Tables[0].Rows[z].date_format;
            if(dsexecute.Tables[0].Rows[z].USER_TYPE!=null)
        {
        document.getElementById('drpuser_type').value = dsexecute.Tables[0].Rows[z].USER_TYPE;
        }
        else
        {
            document.getElementById('drpuser_type').value ="W";
        }

            var companylist = dsexecute.Tables[0].Rows[z].USER_COMPANY;
            for (var t = 0; t < document.getElementById('drpcompanylist').options.length; t++) {
                document.getElementById('drpcompanylist').options[t].selected = false;
            }
            if (companylist != "" && companylist != null) {
                var data = companylist.split(",");
                for (t = 0; t < data.length; t++) {
                    for (var n = 1; n < document.getElementById('drpcompanylist').options.length; n++) {
                        if (data[t] == document.getElementById('drpcompanylist').options[n].value) {
                            document.getElementById('drpcompanylist').options[n].selected = true;
                        }

                    }
                }
            }
            /*new change ankur */
            // if(document.getElementById('tdagencylabel').style.display=="block")
            //{
            document.getElementById('tbcashier').disabled = true;
            document.getElementById('txtemail').disabled = true;
            document.getElementById('txtdisc').disabled = true;
            document.getElementById('drpfilter').disabled = true;
            document.getElementById('drpagency').disabled = true;
            document.getElementById('drpcompany').disabled = true;
            document.getElementById('drprole').disabled = true;
            if (dsexecute.Tables[0].Rows[z].Agency_code = "" || dsexecute.Tables[0].Rows[z].Agency_code == null) {
                document.getElementById('drpagency').value = "";
                document.getElementById('Hiddagency').value = "";
            }
            else {

                document.getElementById('drpagency').value = dsexecute.Tables[0].Rows[z].AGENCY_NAME;
                document.getElementById('Hiddagency').value = dsexecute.Tables[0].Rows[z].Agency_code;
            }

            // }	

            if (dsexecute.Tables[0].Rows[z].Admin == "yes") {
                document.getElementById('rbadmin').checked = true;
                document.getElementById('rbuser').checked = false;
            }
            else {
                document.getElementById('rbuser').checked = true;
                document.getElementById('rbadmin').checked = false;
            }

            //------------------------new added--------------------------------------------------//

            var dsbranch = Createuser.branchexecute(glbruserid, dsexecute.Tables[0].Rows[z].COM_CODE);
            if (dsbranch.value == null) {
                var res = dsbranch.value;
                alert(dsbranch.error.description);
                return false;
            }
            document.getElementById('txtbranchpermission').options[0].selected = false;
            var branchlen = dsbranch.value.Tables[0].Rows.length;
            var flaglen = dsbranch.value.Tables[1].Rows.length;
            for (var t1 = 0; t1 < document.getElementById('txtbranchpermission').options.length; t1++) {
                document.getElementById('txtbranchpermission').options[t1].selected = false;
            }
            for (var a = 0; a < parseInt(document.getElementById('txtbranchpermission').options.length); a++) {
                for (var i = 0; i < flaglen; i++) {
                    if (parseInt(document.getElementById('txtbranchpermission').options[a].value) == dsbranch.value.Tables[1].Rows[i].branchcode) {
                        document.getElementById('txtbranchpermission').options[a].selected = true;
                        i = flaglen;
                    }
                }
            }
            // ------------ end -----------------------------------------------------------------//
            updateStatus();
            document.getElementById('btnnext').disabled = false;
            document.getElementById('btnlast').disabled = false;
        }
        else {
            document.getElementById('btnnext').disabled = false;
            document.getElementById('btnlast').disabled = false;
            document.getElementById('btnfirst').disabled = true;
            document.getElementById('btnprevious').disabled = true;
            setButtonImages();
            return false;
        }
    }
    else {
        document.getElementById('btnnext').disabled = false;
        document.getElementById('btnlast').disabled = false;
        document.getElementById('btnfirst').disabled = true;
        document.getElementById('btnprevious').disabled = true;
        setButtonImages();
        return false;
    }
    if (z == 0) {
        document.getElementById('btnfirst').disabled = true;
        document.getElementById('btnprevious').disabled = true;
    }
    setButtonImages();
    return false;
}

//*******************************************************************************//
//********************This Is The Responce Of The Next Button*******************//
//*******************************************************************************//
function nextclick() {
    var a = dsexecute.Tables[0].Rows.length;
    z++;
    if (z != -1 && z >= 0) {
        if (z <= a - 1) {

            if (dsexecute.Tables[0].Rows[z].STATUS_CHANGE_DATE != null && dsexecute.Tables[0].Rows[z].STATUS_CHANGE_DATE != "")
                document.getElementById('txtdatestatus').value = CHKDATE(dsexecute.Tables[0].Rows[z].STATUS_CHANGE_DATE);
            else
                document.getElementById('txtdatestatus').value = "";


            if (dsexecute.Tables[0].Rows[z].STATUS != null && dsexecute.Tables[0].Rows[z].STATUS != "")
                document.getElementById('drpstatus').value = dsexecute.Tables[0].Rows[z].STATUS;
            else
                document.getElementById('drpstatus').value = "A";

            document.getElementById('txtusername').value = dsexecute.Tables[0].Rows[z].username;
            if (dsexecute.Tables[0].Rows[z].FIRSTNAME == null)
                document.getElementById('txtfirstname').value = "";
            else

                document.getElementById('txtfirstname').value = dsexecute.Tables[0].Rows[z].FIRSTNAME;
            if (dsexecute.Tables[0].Rows[z].LASTNAME == null)
                document.getElementById('txtlastname').value = "";
            else
                document.getElementById('txtlastname').value = dsexecute.Tables[0].Rows[z].LASTNAME;
            document.getElementById('txtuserid').value = dsexecute.Tables[0].Rows[z].userid;
            var glbruserid = dsexecute.Tables[0].Rows[z].userid;
            document.getElementById('drpcompany').value = dsexecute.Tables[0].Rows[z].COM_CODE;
            document.getElementById('drprole').value = dsexecute.Tables[0].Rows[z].ROLEID;
            document.getElementById('drpeditlines').value = dsexecute.Tables[0].Rows[z].BOOKING_EDITLINES;
            //document.getElementById('txtemail').value=dsexecute.Tables[0].Rows[z].EMAIL;
            if (dsexecute.Tables[0].Rows[z].EMAIL == null) {
                document.getElementById('txtemail').value = "";
            }
            else {
                document.getElementById('txtemail').value = dsexecute.Tables[0].Rows[z].EMAIL;
            }
            if (dsexecute.Tables[0].Rows[z].MOBILENO == null) {
                document.getElementById('txtmob').value = "";
            }
            else {
                document.getElementById('txtmob').value = dsexecute.Tables[0].Rows[z].MOBILENO;
            }

            if (dsexecute.Tables[0].Rows[z].DISCOUNT == null) {
                document.getElementById('txtdisc').value = "";
            }
            else {
                document.getElementById('txtdisc').value = dsexecute.Tables[0].Rows[z].DISCOUNT;
            }
            if (dsexecute.Tables[0].Rows[z].FILTER == null) {
                document.getElementById('drpfilter').value = "";
            }
            else {
                document.getElementById('drpfilter').value = dsexecute.Tables[0].Rows[z].FILTER;
            }

            if ((dsexecute.Tables[0].Rows[z].HR_CODE != null) && (dsexecute.Tables[0].Rows[z].HR_CODE != "")) {
                document.getElementById('txtemcode').value = dsexecute.Tables[0].Rows[z].HR_CODE;
                var empcode1 = dsexecute.Tables[0].Rows[z].HR_CODE; ;
              //  var empcodearr = empcode1.split("(");
                //var empcodesplit = empcodearr[1];
                //empcodesplit = empcodesplit.replace(")", "");
                //document.getElementById("hdempcode").value = empcodesplit;
                document.getElementById("hdempcode").value = empcode1;
           
            }
            else {
                document.getElementById('txtemcode').value = "";
            }

            if (dsexecute.Tables[0].Rows[z].ACC_CODE == null) {
                document.getElementById('hdncashier').value = "";
            }
            else {
                document.getElementById('hdncashier').value = dsexecute.Tables[0].Rows[z].ACC_CODE;
            }


            if (dsexecute.Tables[0].Rows[z].ACC_NAME == null) {
                document.getElementById('tbcashier').value = "";
            }
            else {
                document.getElementById('tbcashier').value = dsexecute.Tables[0].Rows[z].ACC_NAME;
            }


            document.getElementById('drpretainer').value = dsexecute.Tables[0].Rows[z].retainer_code;
            document.getElementById('drpcurrencycode').value = dsexecute.Tables[0].Rows[z].curr_code;
            document.getElementById('txtpwd').value = ConveretPassword(dsexecute.Tables[0].Rows[z].password);
            document.getElementById('drpdateformate').value = dsexecute.Tables[0].Rows[z].date_format;
            if(dsexecute.Tables[0].Rows[z].USER_TYPE!=null)
        {
        document.getElementById('drpuser_type').value = dsexecute.Tables[0].Rows[z].USER_TYPE;
        }
        else
        {
            document.getElementById('drpuser_type').value ="W";
        }


            var companylist = dsexecute.Tables[0].Rows[z].USER_COMPANY;
            for (var t = 0; t < document.getElementById('drpcompanylist').options.length; t++) {
                document.getElementById('drpcompanylist').options[t].selected = false;
            }
            if (companylist != "" && companylist != null) {
                var data = companylist.split(",");
                for (t = 0; t < data.length; t++) {
                    for (var n = 1; n < document.getElementById('drpcompanylist').options.length; n++) {
                        if (data[t] == document.getElementById('drpcompanylist').options[n].value) {
                            document.getElementById('drpcompanylist').options[n].selected = true;
                        }

                    }
                }
            }
            /*new change ankur */
            // if(document.getElementById('tdagencylabel').style.display=="block")
            // {
            document.getElementById('tbcashier').disabled = true;
            document.getElementById('drpagency').disabled = true;
            document.getElementById('drpcompany').disabled = true;
            document.getElementById('drprole').disabled = true;

            if (dsexecute.Tables[0].Rows[z].Agency_code = "" || dsexecute.Tables[0].Rows[z].Agency_code == null) {
                document.getElementById('drpagency').value = "";
                document.getElementById('Hiddagency').value = "";
            }
            else {
                document.getElementById('drpagency').value = dsexecute.Tables[0].Rows[z].AGENCY_NAME;
                document.getElementById('Hiddagency').value = dsexecute.Tables[0].Rows[z].Agency_code;
            }
            // }	

            if (dsexecute.Tables[0].Rows[z].Admin == "yes") {
                document.getElementById('rbadmin').checked = true;
                document.getElementById('rbuser').checked = false;
            }
            else {
                document.getElementById('rbuser').checked = true;
                document.getElementById('rbadmin').checked = false;
            }

            //------------------------new added--------------------------------------------------//

            var dsbranch = Createuser.branchexecute(glbruserid, dsexecute.Tables[0].Rows[z].COM_CODE);
            if (dsbranch.value == null) {
                var res = dsbranch.value;
                alert(dsbranch.error.description);
                return false;
            }
            document.getElementById('txtbranchpermission').options[0].selected = false;
            var branchlen = dsbranch.value.Tables[0].Rows.length;
            var flaglen = dsbranch.value.Tables[1].Rows.length;
            for (var t1 = 0; t1 < document.getElementById('txtbranchpermission').options.length; t1++) {
                document.getElementById('txtbranchpermission').options[t1].selected = false;
            }
            for (var a1 = 0; a1 < parseInt(document.getElementById('txtbranchpermission').options.length); a1++) {
                for (var i = 0; i < flaglen; i++) {
                    if (document.getElementById('txtbranchpermission').options[a1].value == dsbranch.value.Tables[1].Rows[i].branchcode) {
                        document.getElementById('txtbranchpermission').options[a1].selected = true;
                        i = flaglen;
                    }
                }
            }
            // ------------ end -----------------------------------------------------------------//

            updateStatus();

            document.getElementById('btnnext').disabled = false;
            document.getElementById('btnlast').disabled = false;
            document.getElementById('btnfirst').disabled = false;
            document.getElementById('btnprevious').disabled = false;
        }
        else {
            document.getElementById('btnnext').disabled = true;
            document.getElementById('btnlast').disabled = true;
            document.getElementById('btnfirst').disabled = false;
            document.getElementById('btnprevious').disabled = false;
        }
    }
    else {
        document.getElementById('btnnext').disabled = true;
        document.getElementById('btnlast').disabled = true;
        document.getElementById('btnfirst').disabled = false;
        document.getElementById('btnprevious').disabled = false;
    }
    if (z == a - 1) {
        document.getElementById('btnnext').disabled = true;
        document.getElementById('btnlast').disabled = true;
        document.getElementById('btnfirst').disabled = false;
        document.getElementById('btnprevious').disabled = false;
    }
    setButtonImages();
    return false;

}

//*******************************************************************************//
//********************This Function For Last Button*******************//
//*******************************************************************************//
function lastcall() {
    var y = dsexecute.Tables[0].Rows.length;
    var a = y - 1;
    z = a;
    if (dsexecute.Tables[0].Rows[z].STATUS_CHANGE_DATE != null && dsexecute.Tables[0].Rows[z].STATUS_CHANGE_DATE != "")
        document.getElementById('txtdatestatus').value = CHKDATE(dsexecute.Tables[0].Rows[z].STATUS_CHANGE_DATE);
    else
        document.getElementById('txtdatestatus').value = "";

    if (dsexecute.Tables[0].Rows[z].STATUS != null && dsexecute.Tables[0].Rows[z].STATUS != "")
        document.getElementById('drpstatus').value = dsexecute.Tables[0].Rows[z].STATUS;
    else
        document.getElementById('drpstatus').value = "A";

    document.getElementById('txtusername').value = dsexecute.Tables[0].Rows[z].username;
    if (dsexecute.Tables[0].Rows[z].FIRSTNAME == null)
        document.getElementById('txtfirstname').value = "";
    else

        document.getElementById('txtfirstname').value = dsexecute.Tables[0].Rows[z].FIRSTNAME;
    if (dsexecute.Tables[0].Rows[z].LASTNAME == null)
        document.getElementById('txtlastname').value = "";
    else
        document.getElementById('txtlastname').value = dsexecute.Tables[0].Rows[z].LASTNAME;
    document.getElementById('txtuserid').value = dsexecute.Tables[0].Rows[z].userid;
    var glbruserid = dsexecute.Tables[0].Rows[z].userid;
    document.getElementById('drpcompany').value = dsexecute.Tables[0].Rows[z].COM_CODE;
    document.getElementById('drprole').value = dsexecute.Tables[0].Rows[z].ROLEID;
    document.getElementById('drpeditlines').value = dsexecute.Tables[0].Rows[z].BOOKING_EDITLINES;
    //document.getElementById('txtemail').value=dsexecute.Tables[0].Rows[z].EMAIL;
    if (dsexecute.Tables[0].Rows[z].EMAIL == null) {
        document.getElementById('txtemail').value = "";
    }
    else {
        document.getElementById('txtemail').value = dsexecute.Tables[0].Rows[z].EMAIL;
    }
    if (dsexecute.Tables[0].Rows[z].MOBILENO == null) {
        document.getElementById('txtmob').value = "";
    }
    else {
        document.getElementById('txtmob').value = dsexecute.Tables[0].Rows[z].MOBILENO;
    }
    if (dsexecute.Tables[0].Rows[z].DISCOUNT == null) {
        document.getElementById('txtdisc').value = "";
    }
    else {
        document.getElementById('txtdisc').value = dsexecute.Tables[0].Rows[z].DISCOUNT;
    }
    if (dsexecute.Tables[0].Rows[z].FILTER == null) {
        document.getElementById('drpfilter').value = "";
    }
    else {
        document.getElementById('drpfilter').value = dsexecute.Tables[0].Rows[z].FILTER;
    }

    if ((dsexecute.Tables[0].Rows[z].HR_CODE != null) && (dsexecute.Tables[0].Rows[z].HR_CODE != "")) {
        document.getElementById('txtemcode').value = dsexecute.Tables[0].Rows[z].HR_CODE;
        var empcode1 = dsexecute.Tables[0].Rows[z].HR_CODE; ;
      //  var empcodearr = empcode1.split("(");
      //  var empcodesplit = empcodearr[1];
       // empcodesplit = empcodesplit.replace(")", "");
       // document.getElementById("hdempcode").value = empcodesplit;
         document.getElementById("hdempcode").value = empcode1;
 
    }
    else {
        document.getElementById('txtemcode').value = "";
    }

    if (dsexecute.Tables[0].Rows[z].ACC_CODE == null) {
        document.getElementById('hdncashier').value = "";
    }
    else {
        document.getElementById('hdncashier').value = dsexecute.Tables[0].Rows[z].ACC_CODE;
    }


    if (dsexecute.Tables[0].Rows[z].ACC_NAME == null) {
        document.getElementById('tbcashier').value = "";
    }
    else {
        document.getElementById('tbcashier').value = dsexecute.Tables[0].Rows[z].ACC_NAME;
    }



    document.getElementById('drpretainer').value = dsexecute.Tables[0].Rows[z].retainer_code;
    document.getElementById('drpcurrencycode').value = dsexecute.Tables[0].Rows[z].curr_code;
    document.getElementById('txtpwd').value = ConveretPassword(dsexecute.Tables[0].Rows[z].password);
    document.getElementById('drpdateformate').value = dsexecute.Tables[0].Rows[z].date_format;
    if(dsexecute.Tables[0].Rows[z].USER_TYPE!=null)
        {
        document.getElementById('drpuser_type').value = dsexecute.Tables[0].Rows[z].USER_TYPE;
        }
        else
        {
            document.getElementById('drpuser_type').value ="W";
        }

    var companylist = dsexecute.Tables[0].Rows[z].USER_COMPANY;
    for (var t = 0; t < document.getElementById('drpcompanylist').options.length; t++) {
        document.getElementById('drpcompanylist').options[t].selected = false;
    }
    if (companylist != "" && companylist != null) {
        var data = companylist.split(",");
        for (t = 0; t < data.length; t++) {
            for (var n = 1; n < document.getElementById('drpcompanylist').options.length; n++) {
                if (data[t] == document.getElementById('drpcompanylist').options[n].value) {
                    document.getElementById('drpcompanylist').options[n].selected = true;
                }

            }
        }
    }
    /*new change ankur */
    //if(document.getElementById('tdagencylabel').style.display=="block")
    //{
    document.getElementById('tbcashier').disabled = true;
    document.getElementById('drpagency').disabled = true;
    document.getElementById('drpcompany').disabled = true;
    document.getElementById('drprole').disabled = true;

    if (dsexecute.Tables[0].Rows[z].Agency_code = "" || dsexecute.Tables[0].Rows[z].Agency_code == null) {
        document.getElementById('drpagency').value = "";
        document.getElementById('Hiddagency').value = "";
    }
    else {
        document.getElementById('drpagency').value = dsexecute.Tables[0].Rows[z].AGENCY_NAME;
        document.getElementById('Hiddagency').value = dsexecute.Tables[0].Rows[z].Agency_code;
    }
    //}	

    if (dsexecute.Tables[0].Rows[z].Admin == "yes") {
        document.getElementById('rbadmin').checked = true;
        document.getElementById('rbuser').checked = false;
    }
    else {
        document.getElementById('rbuser').checked = true;
        document.getElementById('rbadmin').checked = false;
    }

    //------------------------new added--------------------------------------------------//

    var dsbranch = Createuser.branchexecute(glbruserid, dsexecute.Tables[0].Rows[0].COM_CODE);
    if (dsbranch.value == null) {
        var res = dsbranch.value;
        alert(dsbranch.error.description);
        return false;
    }
    document.getElementById('txtbranchpermission').options[0].selected = false;
    var branchlen = dsbranch.value.Tables[0].Rows.length;
    var flaglen = dsbranch.value.Tables[1].Rows.length;
    for (var t1 = 0; t1 < document.getElementById('txtbranchpermission').options.length; t1++) {
        document.getElementById('txtbranchpermission').options[t1].selected = false;
    }
    for (var a = 0; a < document.getElementById('txtbranchpermission').options.length; a++) {
        for (var i = 0; i < flaglen; i++) {
            if (document.getElementById('txtbranchpermission').options[a].value == dsbranch.value.Tables[1].Rows[i].branchcode) {
                document.getElementById('txtbranchpermission').options[a].selected = true;
                i = flaglen;
            }
        }
    }
    // ------------ end -----------------------------------------------------------------//
    updateStatus();

    document.getElementById('btnnext').disabled = true;
    document.getElementById('btnlast').disabled = true;
    document.getElementById('btnfirst').disabled = false;
    document.getElementById('btnprevious').disabled = false;
    setButtonImages();
    return false;
}

//*******************************************************************************//
//**************************This Function For Cancle button**********************//
//*******************************************************************************//


function cancelclick(formname) {
    for (var t = 0; t < document.getElementById('drpcompanylist').options.length; t++) {
        document.getElementById('drpcompanylist').options[t].selected = false;
    }
    for (var t1 = 0; t1 < document.getElementById('txtbranchpermission').options.length; t1++) {
        document.getElementById('txtbranchpermission').options[t1].selected = false;
    }
    document.getElementById('txtdatestatus').disabled = false;
    document.getElementById('txtdatestatus').value = "";
    document.getElementById('drpstatus').value = "A";
    document.getElementById('tbcashier').value = "";
    document.getElementById('txtusername').value = "";
    document.getElementById('txtfirstname').value = "";
    document.getElementById('txtlastname').value = "";
    document.getElementById('txtpwd').value = "";
    document.getElementById('txtuserid').value = "";
    document.getElementById('drpdateformate').value = "0";
    document.getElementById('drpcompany').value = "0";
    document.getElementById('txtemail').value = "";
    document.getElementById('txtdisc').value = "";
    document.getElementById('drpfilter').value = "0";
    document.getElementById('drpcurrencycode').value = "0";
    document.getElementById('drpretainer').value = "0";
    document.getElementById('drprole').value = "0";
    document.getElementById('tbcashier').disabled = true;
    document.getElementById('drpstatus').disabled = true;
    document.getElementById('drpcompanylist').disabled = true;
    document.getElementById('txtbranchpermission').disabled = true;
    document.getElementById('txtusername').disabled = true;
    document.getElementById('txtpwd').disabled = true;
    document.getElementById('txtuserid').disabled = true;
    document.getElementById('drpdateformate').disabled = true;
    document.getElementById('drpcompany').disabled = true;
    document.getElementById('drpuser_type').disabled = true;
    // document.getElementById('txtcompcode').disabled=true;
    document.getElementById('drpcurrencycode').disabled = true;
    document.getElementById('drpretainer').disabled = true;
    document.getElementById('drprole').disabled = true;
    document.getElementById('drpeditlines').disabled = true;
    document.getElementById('txtfirstname').disabled = true;
    document.getElementById('txtlastname').disabled = true;
    /*new chnge ankur for agency*/
    //if(document.getElementById('tdagencylabel').style.display=="block")
    //{
    document.getElementById('rbadmin').disabled = true;
    document.getElementById('rbuser').disabled = true;
    document.getElementById('txtemail').disabled = true;
    document.getElementById('txtdisc').disabled = true;
    document.getElementById('drpfilter').disabled = true;
    document.getElementById('drpagency').disabled = true;
    document.getElementById('drpcompany').disabled = true;
    document.getElementById('drpagency').value = "";
    document.getElementById('txtemcode').value = "";
    document.getElementById('txtemcode').disabled = true;
    //}	

    document.getElementById('btnModify').disabled = true;
    document.getElementById('btnQuery').disabled = false;
    document.getElementById('btnnext').disabled = true;
    document.getElementById('btnlast').disabled = true;
    document.getElementById('btnDelete').disabled = true;
    document.getElementById('btnfirst').disabled = true;
    document.getElementById('btnprevious').disabled = true;
    document.getElementById('btnExecute').disabled = true;
    document.getElementById('btnSave').disabled = true;
    document.getElementById('txtmob').value = "";
    document.getElementById('txtmob').disabled = true;
    //getPermission(formname);
    mod = "0";

    chkstatus(FlagStatus);



    if (document.getElementById('btnNew').disabled == false) {
        document.getElementById('btnNew').focus();
    }

    else {
        document.getElementById('btnNew').disabled = false;
        document.getElementById('btnNew').focus();
    }

    /*document.getElementById('btnNew').disabled=false;
    document.getElementById('btnQuery').disabled=false;
    document.getElementById('btnExit').disabled=false;
    document.getElementById('btnCancel').disabled=false;

    document.getElementById('btnDelete').disabled=true;
    document.getElementById('btnSave').disabled=true;
    document.getElementById('btnModify').disabled=true;

    document.getElementById('btnfirst').disabled=true;
    document.getElementById('btnprevious').disabled=true;
    document.getElementById('btnExecute').disabled=true;
    document.getElementById('btnnext').disabled=true;
    document.getElementById('btnlast').disabled=true;*/
    //givebuttonpermission(formname);
    glaobal1 = ''
    setButtonImages();
    return false;
}

//*******************************************************************************//
//*************************This Function For Delete Button***********************//
//*******************************************************************************//
function deleteclick() {
    var admin = "";
    if (document.getElementById('rbadmin').checked == true) {
        admin = "yes";
    }
    updateStatus();
    var userid = document.getElementById('txtuserid').value;
    //  var compcode=document.getElementById('txtuserid').value;
    var compcode = document.getElementById('drpcompany').value;
    boolReturn = confirm("Are you sure you wish to delete this?");
    //dan
    var strtextd = "";
    var httpRequest = null;
    httpRequest = new XMLHttpRequest();
    if (httpRequest.overrideMimeType) {
        httpRequest.overrideMimeType('text/xml');
    }
    //httpRequest.onreadystatechange = function() {alertContents(httpRequest) };

    httpRequest.open("GET", "checksessiondan.aspx", false);
    httpRequest.send('');
    //alert(httpRequest.readyState);
    if (httpRequest.readyState == 4) {
        //alert(httpRequest.status);
        if (httpRequest.status == 200) {
            strtextd = httpRequest.responseText;
        }
        else {
          //  alert('There was a problem with the request.');
            if (browser != "Microsoft Internet Explorer") {
                //alert(xmlObjMessage.childNodes[1].childNodes[21].childNodes[0].nodeValue);
            }
        }
    }
    if (strtextd != "sess") {
        alert('session expired');
        window.location.href = "Default.aspx";
        return false;
    }
    var ip2 = document.getElementById('ip1').value;
    if (boolReturn == 1) {
        Createuser.logindelete(userid, compcode, ip2);
        alert("Data Deleted Successfully");
        cancelclick('Createuser');
        //Createuser.userexecute(glaobusername, glaobaluserid, glaobalcompcode, admin, delcall);

        //catnextclicktest();


    }
    return false;
}

//*******************************************************************************//
//*******************This Is The Responce Of The delete Button*******************//
//*******************************************************************************//

function delcall(res) {
    dsexecute = res.value;
    len = dsexecute.Tables[0].Rows.length;

    if (dsexecute.Tables[0].Rows.length == 0) {
        alert("No More Data is here to be deleted");
        cancelclick('Createuser');

        return false;
    }

    else if (z >= len || z == -1) {
        if (dsexecute.Tables[0].Rows[0].STATUS != null && dsexecute.Tables[0].Rows[0].STATUS != "")
            document.getElementById('drpstatus').value = dsexecute.Tables[0].Rows[0].STATUS;
        else
            document.getElementById('drpstatus').value = "A";

        document.getElementById('txtusername').value = dsexecute.Tables[0].Rows[0].username;
        document.getElementById('txtuserid').value = dsexecute.Tables[0].Rows[0].userid;
        document.getElementById('drpcompany').value = dsexecute.Tables[0].Rows[0].COM_CODE;
        //document.getElementById('txtemail').value=dsexecute.Tables[0].Rows[0].EMAIL;
        if (dsexecute.Tables[0].Rows[0].EMAIL == null) {
            document.getElementById('txtemail').value = "";
        }
        else {
            document.getElementById('txtemail').value = dsexecute.Tables[0].Rows[0].EMAIL;
        }
        if (dsexecute.Tables[0].Rows[0].DISCOUNT == null) {
            document.getElementById('txtdisc').value = "";
        }
        else {
            document.getElementById('txtdisc').value = dsexecute.Tables[0].Rows[0].DISCOUNT;
        }
        if (dsexecute.Tables[0].Rows[0].FILTER == null) {
            document.getElementById('drpfilter').value = "";
        }
        else {
            document.getElementById('drpfilter').value = dsexecute.Tables[0].Rows[0].FILTER;
        }

        if ((dsexecute.Tables[0].Rows[0].HR_CODE != null) && (dsexecute.Tables[0].Rows[0].HR_CODE != "")) {
            document.getElementById('txtemcode').value = dsexecute.Tables[0].Rows[0].HR_CODE;
            var empcode1 = dsexecute.Tables[0].Rows[0].HR_CODE; ;
            var empcodearr = empcode1.split("(");
            var empcodesplit = empcodearr[1];
            empcodesplit = empcodesplit.replace(")", "");
            document.getElementById("hdempcode").value = empcodesplit;
        }
        else {
            document.getElementById('txtemcode').value = "";
        }
        document.getElementById('drpretainer').value = dsexecute.Tables[0].Rows[0].retainer_code;
        document.getElementById('drpcurrencycode').value = dsexecute.Tables[0].Rows[0].curr_code;
        document.getElementById('txtpwd').value = dsexecute.Tables[0].Rows[0].password;
        document.getElementById('drpdateformate').value = dsexecute.Tables[0].Rows[0].date_format;
        /*new change ankur */
        //if(document.getElementById('tdagencylabel').style.display=="block")
        //{
        document.getElementById('txtemail').disabled = true;
        document.getElementById('txtdisc').disabled = true;
        document.getElementById('drpfilter').disabled = true;
        document.getElementById('drpagency').disabled = true;
        document.getElementById('drpcompany').disabled = true;

        if (dsexecute.Tables[0].Rows[0].Agency_code = "" || dsexecute.Tables[0].Rows[0].Agency_code == null) {
            document.getElementById('drpagency').value = "";
            document.getElementById('Hiddagency').value = "";
        }
        else {
            document.getElementById('drpagency').value = dsexecute.Tables[0].Rows[0].AGENCY_NAME;
            document.getElementById('Hiddagency').value = dsexecute.Tables[0].Rows[0].Agency_code;
        }
        //}		
        document.getElementById('drpagency').value = dsexecute.Tables[0].Rows[0].AGENCY_NAME;
        if (dsexecute.Tables[0].Rows[0].Admin == "yes") {
            document.getElementById('rbadmin').checked = true;
            document.getElementById('rbuser').checked = false;
        }
        else {
            document.getElementById('rbuser').checked = true;
            document.getElementById('rbadmin').checked = false;
        }


    }
    else {
        if (dsexecute.Tables[0].Rows[z].STATUS != null && dsexecute.Tables[0].Rows[z].STATUS != "")
            document.getElementById('drpstatus').value = dsexecute.Tables[0].Rows[z].STATUS;
        else
            document.getElementById('drpstatus').value = "A";

        document.getElementById('txtusername').value = dsexecute.Tables[0].Rows[z].username;
        document.getElementById('txtuserid').value = dsexecute.Tables[0].Rows[z].userid;
        document.getElementById('drpcompany').value = dsexecute.Tables[0].Rows[z].COM_CODE;
        //document.getElementById('txtemail').value=dsexecute.Tables[0].Rows[z].EMAIL;
        if (dsexecute.Tables[0].Rows[z].EMAIL == null) {
            document.getElementById('txtemail').value = "";
        }
        else {
            document.getElementById('txtemail').value = dsexecute.Tables[0].Rows[z].EMAIL;
        }
        if (dsexecute.Tables[0].Rows[z].DISCOUNT == null) {
            document.getElementById('txtdisc').value = "";
        }
        else {
            document.getElementById('txtdisc').value = dsexecute.Tables[0].Rows[z].DISCOUNT;
        }
        if (dsexecute.Tables[0].Rows[z].FILTER == null) {
            document.getElementById('drpfilter').value = "";
        }
        else {
            document.getElementById('drpfilter').value = dsexecute.Tables[0].Rows[z].FILTER;
        }
        document.getElementById('drpretainer').value = dsexecute.Tables[0].Rows[z].retainer_code;
        document.getElementById('drpcurrencycode').value = dsexecute.Tables[0].Rows[z].curr_code;
        document.getElementById('txtpwd').value = dsexecute.Tables[0].Rows[z].password;
        document.getElementById('drpdateformate').value = dsexecute.Tables[0].Rows[z].date_format;
        if(dsexecute.Tables[0].Rows[z].USER_TYPE!=null)
        {
        document.getElementById('drpuser_type').value = dsexecute.Tables[0].Rows[z].USER_TYPE;
        }
        else
        {
            document.getElementById('drpuser_type').value ="W";
        }
        /*new change ankur */
        //if(document.getElementById('tdagencylabel').style.display=="block")
        //{

        document.getElementById('drpagency').disabled = true;
        document.getElementById('drpcompany').disabled = true;

        if (dsexecute.Tables[0].Rows[z].Agency_code = "" || dsexecute.Tables[0].Rows[z].Agency_code == null) {
            document.getElementById('drpagency').value = "";
            document.getElementById('Hiddagency').value = "";
        }
        else {


            document.getElementById('drpagency').value = dsexecute.Tables[0].Rows[z].AGENCY_NAME;
            document.getElementById('Hiddagency').value = dsexecute.Tables[0].Rows[z].Agency_code;
        }
        //}		

        //}
        if (dsexecute.Tables[0].Rows[z].Admin == "yes") {
            document.getElementById('rbadmin').checked = true;
            document.getElementById('rbuser').checked = false;
        }
        else {
            document.getElementById('rbuser').checked = true;
            document.getElementById('rbadmin').checked = false;
        }

    }
    if (z == 0) {
        document.getElementById('btnfirst').disabled = true;
        document.getElementById('btnprevious').disabled = true;
    }

    if (z == (dsexecute.Tables[0].Rows.length - 1)) {
        document.getElementById('btnnext').disabled = true;
        document.getElementById('btnlast').disabled = true;
    }
    setButtonImages();
    return false;
}

//*******************************************************************************//
//**************************This Function For Modify Button**********************//
//*******************************************************************************//
function modifyclick() {
    glaobal1 = '';
    document.getElementById('txtdatestatus').disabled = false;
   
    document.getElementById('tbcashier').disabled = false;
    document.getElementById('drpstatus').disabled = false;
    document.getElementById('txtusername').disabled = true;
    document.getElementById('txtpwd').disabled = false;
    document.getElementById('drpdateformate').disabled = false;
    document.getElementById('drpcompany').disabled = false;
    document.getElementById('drpcompanylist').disabled = false;
    document.getElementById('txtbranchpermission').disabled = false;
    document.getElementById('txtemail').disabled = false;
    document.getElementById('txtdisc').disabled = false;
    document.getElementById('drpfilter').disabled = false;
    document.getElementById('drpcurrencycode').disabled = false;
    document.getElementById('drpretainer').disabled = false;
    document.getElementById('txtfirstname').disabled = false;
    document.getElementById('txtlastname').disabled = false;
    document.getElementById('drpuser_type').disabled = false;
    /*new change ankur */
    document.getElementById('drpagency').disabled = false;
    document.getElementById('drprole').disabled = false;
    document.getElementById('drpeditlines').disabled = false;
    //////////////
    glaobal1 = document.getElementById('txtemail').value;

    chkstatus(FlagStatus);

    document.getElementById('btnSave').disabled = false;
    document.getElementById('btnQuery').disabled = true;
    document.getElementById('btnExecute').disabled = true;
    document.getElementById('btnModify').disabled = true;
    document.getElementById('txtmob').disabled = false;
    /*new change ankur */
    //if(document.getElementById('tdagencylabel').style.display=="block")
    //{

    document.getElementById('drpagency').disabled = true;

    //}

    mod = "1";
    hiddentext = "mod";
    setButtonImages();
    return false;
}

function exitclick() {
    if (confirm("Do You Want To Skip This Page")) {
        window.close();
        return false;
    }
    return false;
}

function forcompany(id) {
    if (id == "lbcomp") {
        //document.getElementById('drpagencylabel').style.display="none";
        // document.getElementById('tdagencylabel').style.display="none";
        //document.getElementById('tdagencylabel').style.display="none";
        document.getElementById('lbcomp').style.fontWeight = "bold";
        document.getElementById('lbagency').style.fontWeight = "normal";
        //document.getElementById('lbcomp').style.fontColor="yellow";
        // document.getElementById('lbagency').style.fontColor="white";
        return false;

    }
    else {
        // document.getElementById('drpagencylabel').style.display="block";
        // document.getElementById('tdagencylabel').style.display="block";

        document.getElementById('lbagency').style.fontWeight = "bold";
        document.getElementById('lbcomp').style.fontWeight = "normal";
        //document.getElementById('lbcomp').style.fontColor="white";
        //document.getElementById('lbagency').style.fontColor="yellow";
        return false;
    }

}


function chkuseroradmin(id) {
    if (id == "rbadmin") {
        document.getElementById(id).checked = true;
        document.getElementById('rbuser').checked = false;
        // document.getElementById('retainer').style.display="none";
        // document.getElementById('retainerdrp').style.display="none";

    }
    else {
        document.getElementById(id).checked = true;
        document.getElementById('rbadmin').checked = false;
        // document.getElementById('retainer').style.display="block";
        //  document.getElementById('retainerdrp').style.display="block";

    }
    return;

}

function checkEmail(q) {


    var theurl = document.frmcat3.txtemail.value;

    if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(theurl) || document.getElementById(q).value == "") {
        Createuser.mailchk(theurl, fillmail);
        return (true)
    }
    alert("Invalid or Blank E-mail Address! Please re-enter.")
    document.getElementById(q).value = "";
    document.getElementById(q).focus();
    return (false)



}

function chkname() {
    var cuserid = document.getElementById('txtuserid').value;
    var cusername = document.getElementById('txtusername').value;
    var branchname = document.getElementById('drpretainer').value;
    Createuser.chkuserid(cuserid, cusername, branchname, callBack_userdefine1);
}

function chkdisc() {
    var sau = parseFloat(document.getElementById('txtdisc').value);
    //document.getElementById('txtsharing').value=sau;

    if (sau > 100) {
        alert("Discount Allowed should not be greater than 100");
        document.getElementById('txtdisc').value = "";
        document.getElementById('txtdisc').focus();
        return false;
    }

    var num = document.getElementById('txtdisc').value;
    var tomatch = /^\d*(\.\d{1,2})?$/;
    if (tomatch.test(num)) {
        return true;
    }
    else {
        alert("Input error");
        document.getElementById('txtdisc').value = "";
        document.getElementById('txtdisc').focus();

        return false;

    }

}

function fillmail(ds) {
    if (glaobal1 != '') {
        if (glaobal1 != document.getElementById('txtemail').value) {
            if (ds.value.Tables[0].Rows.length > 0) {
                alert("E-mail Address is already present Please re-enter.")
                document.getElementById('txtemail').value = "";
                document.getElementById('txtemail').focus();
                return false;
            }

        }
    }

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

function F2fillempcode(event) {

    if (event.keyCode == 113) {
        if (document.activeElement.id == "txtemcode") {
            //$('txtagency').value="";
            var compcode = document.getElementById('hiddencomcode').value;
            var empname = document.getElementById('txtemcode').value;
            document.getElementById("divempcode").style.display = "block";
            document.getElementById('divempcode').style.top = 600 + "px";
            document.getElementById('divempcode').style.left = 450 + "px";
            document.getElementById('lstempcode').focus();
            var ds = Createuser.empcodebind(compcode, empname);
            bindempcode_callbackb(ds);
        }
    }

}

function bindempcode_callbackb(res) {
    var ds_AccName = res.value;

    if (ds_AccName != null) {
        var pkgitem = document.getElementById("lstempcode");
        pkgitem.options.length = 0;
        pkgitem.options[0] = new Option("-Select Employe Name-", "0");
        pkgitem.options.length = 1;
        for (var i = 0; i < ds_AccName.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds_AccName.Tables[0].Rows[i].NAME + '(' + ds_AccName.Tables[0].Rows[i].EMP_CODE + ')', ds_AccName.Tables[0].Rows[i].EMP_CODE);
            pkgitem.options.length;
        }
    }
    document.getElementById("lstempcode").value = "0";
    document.getElementById("divempcode").value = "";
    document.getElementById('lstempcode').focus();

    return false;

}


function Clickrempcode_ret(event) {

    if (event.keyCode == 13 || event.type == "click") {
        if (document.activeElement.id == "lstempcode") {
            if (document.getElementById('lstempcode').value == "0") {
                alert("Please select Retainer Name");
                return false;
            }

            var page = document.getElementById('lstempcode').value;
            agencycode = page;
            for (var k = 0; k <= document.getElementById('lstempcode').length - 1; k++) {
                if (document.getElementById('lstempcode').options[k].value == page) {
                    if (browser != "Microsoft Internet Explorer") {
                        var abc = document.getElementById('lstempcode').options[k].textContent;

                    }
                    else {
                        var abc = document.getElementById('lstempcode').options[k].innerText;
                    }
                    document.getElementById('txtemcode').value = abc;

                    document.getElementById('hdempcode').value = page;
                    //                    document.getElementById('hdnretainername').value =abc;

                    document.getElementById("divempcode").style.display = "none";
                    document.getElementById('txtemcode').focus();
                    return false;

                }

            }


        }

    }
    else if (event.keyCode == 27) {

        document.getElementById("divempcode").style.display = "none";
        document.getElementById('txtemcode').focus();
        return false;
    }
}

function F2fillagencycode(event) {
    document.getElementById('Hiddagency').value = "";

    if (event.keyCode == 113) {
        if (document.activeElement.id == "drpagency") {
            document.getElementById("divagency").style.display = "block";
            aTag = eval(document.getElementById("drpagency"))
            var btag;
            var leftpos = 0;
            var toppos = 0;
            do {
                aTag = eval(aTag.offsetParent);
                leftpos += aTag.offsetLeft;
                toppos += aTag.offsetTop;
                btag = eval(aTag)
            } while (aTag.tagName != "BODY" && aTag.tagName != "HTML");
            document.getElementById('divagency').style.top = document.getElementById("drpagency").offsetTop + toppos + "px";
            document.getElementById('divagency').style.left = document.getElementById("drpagency").offsetLeft + leftpos + "px";
            //        document.getElementById('divagency').style.top=parseInt(document.getElementById('txtagenname').offsetTop) + parseInt(document.getElementById('sectd').offsetTop) + parseInt(document.getElementById('tdagen3').offsetTop) + parseInt(document.getElementById('frsttd').offsetTop) + parseInt(document.getElementById('td3').offsetTop) + parseInt(document.getElementById('OuterTable').offsetTop) + 6;
            //document.getElementById('divagency').style.top=parseInt(document.getElementById('txtagenname').offsetTop) + parseInt(document.getElementById('sectd').offsetTop) + parseInt(document.getElementById('tdagen3').offsetTop) + parseInt(document.getElementById('td3').offsetTop) + parseInt(document.getElementById('OuterTable').offsetTop) + 18;

            //  document.getElementById('divagency').style.left=parseInt(document.getElementById('txtagenname').offsetLeft) + parseInt(document.getElementById('sectd').offsetLeft) + parseInt(document.getElementById('tdagen3').offsetLeft) + parseInt(document.getElementById('frsttd').offsetLeft) + parseInt(document.getElementById('td3').offsetLeft) + parseInt(document.getElementById('OuterTable').offsetLeft) + 67;
            Createuser.bindagencyname(document.getElementById('hiddencomcode').value, document.getElementById('hiddenuserid').value, document.getElementById('drpagency').value.toUpperCase(), bindagencyname_callback);

        }
        //    else if(document.activeElement.id=="txtclient")
        //    {
        //        document.getElementById("divclient").style.display="block";
        //        document.getElementById('divclient').style.top=parseInt(document.getElementById('txtclient').offsetTop) + parseInt(document.getElementById('sectd').offsetTop) + parseInt(document.getElementById('tdclient').offsetTop) + parseInt(document.getElementById('tbl1').offsetTop) + parseInt(document.getElementById('tbl2').offsetTop) + parseInt(document.getElementById('tbl3').offsetTop) + parseInt(document.getElementById('OuterTable').offsetTop) + 6;
        //        document.getElementById('divclient').style.left=parseInt(document.getElementById('txtclient').offsetLeft) + parseInt(document.getElementById('sectd').offsetLeft) + parseInt(document.getElementById('tdclient').offsetLeft) + parseInt(document.getElementById('tbl1').offsetLeft) + parseInt(document.getElementById('tbl2').offsetLeft) + parseInt(document.getElementById('tbl3').offsetLeft) + parseInt(document.getElementById('OuterTable').offsetLeft) + 9;
        //        Booking_master.bindclientname(document.getElementById('hiddencompcode').value,document.getElementById('txtclient').value,bindclientname_callback);
        //    }

    }
}


function bindagencyname_callback(response) {
    ds = response.value;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {


        var pkgitem = document.getElementById("lstagency");
        pkgitem.options.length = 0;
        pkgitem.options[0] = new Option("-Select Agency-", "0");
        pkgitem.options.length = 1;
        //alert(pkgitem.options.length);
        for (var i = 0; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].Agency_Name, ds.Tables[0].Rows[i].code_subcode);

            pkgitem.options.length;

        }
    }
    else {
        document.getElementById("lstagency").options.length = 0;
    }
    document.getElementById('drpagency').value = "";

    document.getElementById('Hiddagency').value = "";
    document.getElementById("lstagency").value = "0";
    document.getElementById("lstagency").focus();
    return false;
}

function insertagency(event) {


    if (event.keyCode == 13 || event.type == "click") {
        if (document.activeElement.id == "lstagency") {
            if (document.getElementById('lstagency').value == "0") {
                alert("Please select Retainer Name");
                return false;
            }

            var page = document.getElementById('lstagency').value;
            agencycode = page;
            for (var k = 0; k <= document.getElementById('lstagency').length - 1; k++) {
                if (document.getElementById('lstagency').options[k].value == page) {
                    if (browser != "Microsoft Internet Explorer") {
                        var abc = document.getElementById('lstagency').options[k].textContent;

                    }
                    else {
                        var abc = document.getElementById('lstagency').options[k].innerText;
                    }
                    document.getElementById('drpagency').value = abc;

                    document.getElementById('Hiddagency').value = page;
                    //                    document.getElementById('hdnretainername').value =abc;

                    document.getElementById("divagency").style.display = "none";
                    document.getElementById('drpagency').focus();
                    return false;

                }

            }


        }

    }



    else if (event.keyCode == 27) {

        document.getElementById("divagency").style.display = "none";
        document.getElementById('drpagency').focus();
        return false;
    }


}










function insertcashier(event) {


    if (event.keyCode == 13 || event.type == "click") {
        if (document.activeElement.id == "lstcashier") {
            if (document.getElementById('lstcashier').value == "0") {
                alert("Please select Retainer Name");
                return false;
            }

            var page = document.getElementById('lstcashier').value;
            agencycode = page;
            for (var k = 0; k <= document.getElementById('lstcashier').length - 1; k++) {
                if (document.getElementById('lstcashier').options[k].value == page) {
                    if (browser != "Microsoft Internet Explorer") {
                        var abc = document.getElementById('lstcashier').options[k].textContent;

                    }
                    else {
                        var abc = document.getElementById('lstcashier').options[k].innerText;
                    }
                    document.getElementById('tbcashier').value = abc;

                    document.getElementById('hdncashier').value = page;
                    //                    document.getElementById('hdnretainername').value =abc;

                    document.getElementById("divcashier").style.display = "none";
                    document.getElementById('tbcashier').focus();
                    return false;

                }

            }


        }

    }



    else if (event.keyCode == 27) {

        document.getElementById("divcashier").style.display = "none";
        document.getElementById('tbcashier').focus();
        return false;
    }


}






function F2fillcashier(event) {
    document.getElementById('hdncashier').value = "";

    if (event.keyCode == 113) {
        if (document.activeElement.id == "tbcashier") {
            document.getElementById("divcashier").style.display = "block";
            aTag = eval(document.getElementById("tbcashier"))
            var btag;
            var leftpos = 0;
            var toppos = 0;
            do {
                aTag = eval(aTag.offsetParent);
                leftpos += aTag.offsetLeft;
                toppos += aTag.offsetTop;
                btag = eval(aTag)
            } while (aTag.tagName != "BODY" && aTag.tagName != "HTML");
            document.getElementById('divcashier').style.top = document.getElementById("tbcashier").offsetTop + toppos + "px";
            document.getElementById('divcashier').style.left = document.getElementById("tbcashier").offsetLeft + leftpos + "px";

            Createuser.bindacashiername(document.getElementById('hiddencomcode').value, "C", document.getElementById('tbcashier').value, document.getElementById('hiddenuserid').value, "", "", bindcashier_callback)

            // var res = Createuser.bindacashiername("","","","","","",bindcashier_callback)
        }


    }
}



function bindcashier_callback(response) {
    ds = response.value;
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {


        var pkgitem = document.getElementById("lstcashier");
        pkgitem.options.length = 0;
        pkgitem.options[0] = new Option("-Select Agency-", "0");
        pkgitem.options.length = 1;
        //alert(pkgitem.options.length);
        for (var i = 0; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].ACC_NAME, ds.Tables[0].Rows[i].CDP);

            pkgitem.options.length;

        }
    }
    else {
        document.getElementById("lstcashier").options.length = 0;
    }
    document.getElementById('tbcashier').value = "";

    document.getElementById('hdncashier').value = "";
    document.getElementById("lstcashier").value = "0";
    document.getElementById("lstcashier").focus();
    return false;
}

function chknumber(event) {

    var key = event.keyCode ? event.keyCode : event.which;

    if ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode == 127) || (event.keyCode == 8) || (event.keyCode == 9) || (event.keyCode == 43)) {
        return true;
    }
    else {
        key = 0;
        return false;
    }


    //    var key = event.keyCode ? event.keyCode : event.which;
    //var id=document.activeElement.id
    //    if ((event.keyCode >= 48 && event.keyCode <= 57) || (event.keyCode == 127) || (event.keyCode == 8) || (event.keyCode == 9) || (event.keyCode == 43) || (event.keyCode == 46)) {

    //        if (document.getElementById(id).value.indexOf('.') > -1) {

    //            if (event.keyCode == 46) {
    //                key = 0
    //                return false

    //            }
    //            else {
    //                var sp = document.getElementById(id).value.split('.')
    //                if (sp[1].length < 2) {
    //                    return true
    //                }
    //                else {
    //                    key = 0
    //                    return false
    //                }
    //            }
    //        }
    //        else {
    //            if (event.keyCode == 46) {

    //                return true

    //            }
    //            else {
    //                if (document.getElementById(id).value.length < 7) {
    //                    return true
    //                }
    //                else {
    //                    key = 0
    //                    return false
    //                }
    //            }
    //        }
    //    
    //        return true;
    //    }
    //    else {
    //        key = 0;
    //        return false;
    //    }

}

function chk_dup_number() {


    if (document.getElementById('txtmob').value != "") {
        if (document.getElementById('txtmob').value.length > parseInt(document.getElementById('hdn_mobno_max').value) || document.getElementById('txtmob').value.length < parseInt(document.getElementById('hdn_mobno').value)) {
            alert("Mobile number should be between" + " " + document.getElementById('hdn_mobno').value + " to" + " " + document.getElementById('hdn_mobno_max').value + " digit")
            document.getElementById('txtmob').focus()
            return false
        }
        var res = Createuser.bind_mo(document.getElementById('txtmob').value)
        var ds = res.value;
        if (ds.Tables[0].Rows[0].OUTPUT == "FALSE") {
            alert("Number already exists")
            document.getElementById('txtmob').value = ""
            return false
        }
    }
}
function chk_password(password) {
    // alert('a');
    var compcode1 = document.getElementById('hiddencomcode').value;

    var ds1 = Createuser.check_pref(compcode1);
    var dataset = ds1.value;
    //alert(dataset.Tables[0].Rows[0].COMMON_EDITION_FOR_UNIT);
    if (dataset.Tables[0].Rows[0].COMMON_EDITION_FOR_UNIT == "Y") {

        if (chk_complexpassword(password) == false) {
            // alert('b');
            return false;
        }
        else {
            return true;
        }

    }
    else {
        return true;
    }
}


function chk_complexpassword(password) {

    var new_password = password.toUpperCase();
    //alert('c');
    var length = password.length;
    if (length > 16) {
        alert("Please Enter Password Max 15 Character.");
        return false;
    }
    if (length < 6) {
        alert("Please Enter Password Min 6 Character.");
        return false;
    }

    if (new_password.match(/[A-Z]/i) && password.match(/[0-9]/g)) {
        return true;
    }

    else {
        alert("Please Enter Password Alphanumeric.");
        return false;
    }


}


function chk_pass() {

    var username = document.getElementById('txtusername').value;
    var password = document.getElementById('txtpwd').value;
    var oldpassword = "";
    var result = Createuser.chk_pass1(username, password, oldpassword);
    var ds = result.value;
    //   if (result.value == "True" || result.value == null) {
    if (ds.Tables[0].Rows.length > 0) {

        // if (ds.Tables[0].Rows.length > 0) {
        if (ds.Tables[0].Rows[0].PASSWORD != "TRUE") {
            alert(ds.Tables[0].Rows[0].PASSWORD)
            document.getElementById('txtpwd').focus();
            document.getElementById('txtpwd').value = "";
            return false;
        }
    }
    // }
    //       blankfields();
    //       return false;
    //   }
    //   else {
    //       alert("There is some error. Data Not saved successfully")
    //   }

    return false;
}
function checkpassword() {
    var alert2 = "";

    var password = document.getElementById('txtpwd').value;

    var compcode = document.getElementById('hiddencomcode').value;
    var username = document.getElementById("txtusername").value;
    var oldpassword = "";//document.getElementById('txtpwd').value;
    var ret_string = "";
    var ds = Createuser.passwordcheck(compcode, password, username, oldpassword);
    if (ds.error != null) {
        alert(ds.error)
        return false;
    }
    else {

        ret_string = ds.value;
        if (ret_string != "TRUE") {
            alert(ret_string)
            document.getElementById('txtpwd').value = "";
            document.getElementById('txtpwd').focus();
        }
    }
    return false;



}


function ConveretPassword(val){
    var val = Createuser.decript(val);
    val=val.value;
    return val;
}