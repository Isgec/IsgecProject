// JScript File
var countval=""
var browser=navigator.appName; 
function chksubmit()
{
    if(document.getElementById('txtusername').value=="")
    {
        alert('Please enter user name');
        document.getElementById('txtusername').focus();
        return false;
    }
    else if(document.getElementById('txtoldpwd').value=="")
    {
        alert('Please enter old password');
        document.getElementById('txtoldpwd').focus();
        return false;
    }
    else if(document.getElementById('txtnewpwd').value=="")
    {
        alert('Please enter new password');
        document.getElementById('txtnewpwd').focus();
        return false;
    }
    
    else if(document.getElementById('txtcfrmpwd').value=="")
    {
        alert('Please enter comfirm password');
        document.getElementById('txtcfrmpwd').focus();
        return false;
    }
    else if(document.getElementById('txtnewpwd').value!=document.getElementById('txtcfrmpwd').value)
    {
        alert('Please confirm password');
        document.getElementById('txtcfrmpwd').focus();
        return false;
     }
     else if(document.getElementById('txtoldpwd').value==document.getElementById('txtnewpwd').value)
     {
        alert("Old Password and New Password can not be same");
         document.getElementById('txtnewpwd').focus();
         return false;
     }
    else
    {
        var drpvalue=document.getElementById('drpusername');
        var leng=drpvalue.length;
        var count="0";
        for(i=0;i<leng;i++)
        {
            if(document.getElementById('txtusername').value.toLowerCase()==drpvalue.options[i].innerHTML.toLowerCase())
            {
                count=1;
                countval=drpvalue.options[i].value;
            }
        }
        if(count==1)
        {
            //dan
          /*var strtextd="";
            var  httpRequest =null;
            httpRequest= new XMLHttpRequest();
            if (httpRequest.overrideMimeType) {
            httpRequest.overrideMimeType('text/xml'); 
            }
          //httpRequest.onreadystatechange = function() {alertContents(httpRequest) };
 
            httpRequest.open( "GET","checksessiondan.aspx", false );
            httpRequest.send('');
            //alert(httpRequest.readyState);
            if (httpRequest.readyState == 4) 
            {
                //alert(httpRequest.status);
                if (httpRequest.status == 200) 
                {
                    strtextd=httpRequest.responseText;
                }
                else 
                {
                    //alert('There was a problem with the request.');
                    if(browser!="Microsoft Internet Explorer")
                    {
                        //alert(xmlObjMessage.childNodes[1].childNodes[21].childNodes[0].nodeValue);
                    }
                }
            }
            if(strtextd!="sess")
            {
                alert('session expired');
                window.location.href="Default.aspx";
                return false;
            }*/
      // var pass = cngpassword.DecryptString(document.getElementById('txtoldpwd').value).value;
       var res = cngpassword.chkpwd(document.getElementById('txtoldpwd').value, countval, call_name)
       //var res1 = res.value;
        }
        else
        {
        
            alert("please check the user name")
            return false;
        }
        
    }
    
    
}
function call_name(response)
{
    var ds=response.value
    if(ds.Tables[0].Rows.length>0)
    {
    
    var compcode    = document.getElementById('hdncompcode').value;
    var newpwd      = document.getElementById('txtnewpwd').value;
    var usercode    = countval;
    var dateformat  = document.getElementById('hdndateformat').value;
    var extra1      = "", extra2 = "";
    
        //cngpassword.cngpwd(document.getElementById('txtnewpwd').value,countval,call_name1)
        cngpassword.cngpwd(compcode,   newpwd,  usercode,  dateformat,  extra1,  extra2, call_name1)
    }
    else
    {
        alert('User name or Old password is Incorrect');
        return false;
    }
}
function call_name1(response)
{
    if(response.value.Tables[0].Rows[0].MESG=="TRUE"){
        alert('Passowrd change successfully');
	window.location.href="login.aspx";
        return false;
    }
    else{
        alert('There was a problem with the request...!');
        return false;
    }
}

function tabvalue12(event,id)
{
var browser=navigator.appName;
if(browser!="Microsoft Internet Explorer")
 {
        if(event.which==13)
        {
        if(document.activeElement.id==id)
        {
            if(document.getElementById('btnsubmit').disabled==false)
            {
        document.getElementById('btnsubmit').focus();
            }
        return;

        }
        else
        {
        //alert(event.keyCode);
        event.which=9;
        //alert(event.keyCode);
        return event.which;
        }
        }
 }       
else
{
     if(event.keyCode==13)
        {
            if(document.activeElement.id==id)
            {
                if(document.getElementById('btnsubmit').disabled==false)
                {
            document.getElementById('btnsubmit').focus();
                }
            return;

            }
            else
            {
            //alert(event.keyCode);
            event.keyCode=9;
            //alert(event.keyCode);
            return event.keyCode;
            }
        }
        
        if(event.keyCode==120)
        {
           var formname=document.URLUnencoded.substring(document.URLUnencoded.lastIndexOf("/")+1,document.URLUnencoded.lastIndexOf("."));
           window.open("Help.aspx?formname="+formname);
          
        }
}

}


function checkpassword() {
    var alert2 = "";

    var password = document.getElementById('txtnewpwd').value;

    var compcode = document.getElementById('hiddencompcode').value;
    var username = document.getElementById("txtusername").value;
    var oldpassword = document.getElementById('txtoldpwd').value;
    var ret_string = "";
    var ds = cngpassword.passwordcheck(compcode, password, username, oldpassword);
    if (ds.error != null) {
        alert(ds.error)
        return false;
    }
    else {

        ret_string = ds.value;
        if (ret_string != "TRUE") {
            alert(ret_string)
            document.getElementById('txtnewpwd').value = "";
            document.getElementById('txtnewpwd').focus();
            return false;
        }
    }
    return false;



}


