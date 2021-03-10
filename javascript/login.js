// JScript File
function bindUser()
{
    login.fillUser(document.getElementById('drpqbc').value,bindUser_callback);
}
function bindUser_callback(response)
{
     var ds=response.value;
    agcatby = document.getElementById("drpusername");
 agcatby.options.length = 1; 
    agcatby.options[0]=new Option("--Select User Name--","0");
if(ds!= null && typeof(ds) == "object" && ds.Tables[0].Rows.length > 0) 
{


//alert(pkgitem);
    
    //alert(pkgitem.options.length);
    for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i)
    {
        agcatby.options[agcatby.options.length] = new Option(ds.Tables[0].Rows[i].username,ds.Tables[0].Rows[i].userid);
        
       agcatby.options.length;
       
    }
    }
}
function bindQBC()
{
login.fillQBC(document.getElementById('drpcenter').value,bindQBC_callback);
}
function bindQBC_callback(response)
{
    //alert(response.value);
    var ds=response.value;
    agcatby = document.getElementById("drpqbc");
    agcatby.options.length = 1; 
    agcatby.options[0]=new Option("--Select Branch--","0");
if(ds!= null && typeof(ds) == "object" && ds.Tables[0].Rows.length > 0) 
{


//alert(pkgitem);
    
    //alert(pkgitem.options.length);
    for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i)
    {
    
    //        For Sql
    //agcatby.options[agcatby.options.length] = new Option(ds.Tables[0].Rows[i].retain_name,ds.Tables[0].Rows[i].retain_code);
//    For oracle
    
 agcatby.options[agcatby.options.length] = new Option(ds.Tables[0].Rows[i].Branch_Name,ds.Tables[0].Rows[i].Branch_Code);

        
       agcatby.options.length;
       
    }
    }
}

function login1() {
    //alert();
    //        if(document.getElementById('drpusername').value=="0" && document.getElementById('txtpwd').value=="")
    //        {
    //        alert("Username and Password should not be blank" );
    //        document.getElementById('drpusername').focus();
    //        return false;
    //        }
    //        else if(document.getElementById('drpusername').value=="0")
    //        {
    //        alert("Username field should not be blank" );
    //        document.getElementById('drpusername').focus();
    //        return false;
    //        }
    //        
    //        else if(document.getElementById('txtpwd').value=="")
    //        {
    //        alert("Password field should not be blank" );
    //        document.getElementById('txtpwd').focus();
    //        return false;
    //        }
    //else
    //{
    //            var username=document.getElementById('drpusername').value;
    ////////////////change from here
    if (document.getElementById('txtusername').value == "" && document.getElementById('txtpwd').value == "") {
        alert("Username and Password should not be blank");
        document.getElementById('txtusername').focus();
        return false;
    }
    else if (document.getElementById('txtusername').value == "") {
        alert("Username field should mot be blank");
        document.getElementById('txtusername').focus();
        return false;
    }

    else if (document.getElementById('txtpwd').value == "") {
        alert("Password field should not be blank");
        document.getElementById('txtpwd').focus();
        return false;
    }
    else {
        var username = "";
        var drplength = document.getElementById('drpusername').options.length
        for (i = 0; i < drplength; i++) {
            if (document.getElementById('drpusername').options[i].innerHTML.toLowerCase() == document.getElementById('txtusername').value.toLowerCase()) {
                username = document.getElementById('drpusername').options[i].value;
            }
        }
        ///////////////////change till here
        var password = document.getElementById('txtpwd').value;
        var qbc = document.getElementById('drpqbc').value;
        var page;
        var printingcentercode = document.getElementById('drpcenter').value
        var browser = navigator.appName;
        var centerval = "";
        for (i = 0; i < document.getElementById('drpcenter').options.length - 1; i++) {
            if (document.getElementById('drpcenter').options[i].selected == true) {
                center = document.getElementById('drpcenter').options[i].value;
                var fval = "";
                var lval = "";
                varfinalval = "";
                fval = document.getElementById('drpcenter').options[i].text.indexOf("(")
                lval = parseInt(document.getElementById('drpcenter').options[i].text.indexOf(")")) + 1;
                // varfinalval=
                centerval = document.getElementById('drpcenter').options[i].text.replace(document.getElementById('drpcenter').options[i].text.substring(fval, lval), "");
            }
        }




        //alert(browser);
        var httpRequest = null;
        if (browser != "Microsoft Internet Explorer") {
            //alert("test");
            httpRequest = new XMLHttpRequest();
            if (httpRequest.overrideMimeType) {
                httpRequest.overrideMimeType('text/xml');
            }

            httpRequest.onreadystatechange = function () { alertContents(httpRequest) };

            httpRequest.open("GET", "loginxml.aspx?username=" + username + "&password=" + password + "&qbc=" + qbc + "&printingcentercode=" + printingcentercode + "&centerval=" + centerval, false);
            httpRequest.send('');
            //alert(httpRequest.readyState);
            if (httpRequest.readyState == 4) {
                //alert(httpRequest.status);
                if (httpRequest.status == 200) {
                    var flag = httpRequest.responseText;
                    if (flag == "0") {
                        alert("Invalid User Name or Password");
                        return false;
                    }
                    else {
                        //debugger;
                        window.location.href = "TaxTypeMaster.aspx?flag_login=yes";
                        //window.location.href="citymaster.aspx";
                    }
                }
                else {
                    alert('There was a problem with the request.');
                }
            }
        }
        else {
            var xml = new ActiveXObject("Microsoft.XMLHTTP");
            xml.Open("GET", "loginxml.aspx?username=" + username + "&password=" + password + "&qbc=" + qbc + "&printingcentercode=" + printingcentercode + "&centerval=" + centerval, false);
            xml.Send();
            var flag = xml.responseText;
            if (flag == "0") {
                alert("Invalid User Name or Password");
                return false;
            }
            else {
                window.location.href = "TaxTypeMaster.aspx?flag_login=yes";


                //  window.location.href="newcomb.aspx"; loginxml
            }
        }
    }
    return false;

}

function keySort(dropdownlist,caseSensitive) {
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
  for (var n=0; n<optionsLength; n++) { 
    var optionText = dropdownlist.options[n].text; 
    if (!caseSensitive) {
      optionText = optionText.toLowerCase();
    }
    if (optionText.indexOf(dropdownlist.keypressBuffer,0) == 0) { 
      dropdownlist.selectedIndex = n; 
      return false; // cancel the default behavior since 
                    // we have selected our own value 
    } 
  } 
  // reset initial key to be inline with default behavior 
  dropdownlist.keypressBuffer = key; 
  return true; // give default behavior 
} 

function tabvalue (id)
{



if(event.keyCode==13)
{

//btnsubmit

if(document.activeElement.id==id)
{
    document.getElementById('btnlogin').focus();
    event.keyCode=13;
return event.keyCode;

}

else 
if(document.activeElement.type=="button" || document.activeElement.type=="submit")
{
event.keyCode=13;
return event.keyCode;

}
else
{
event.keyCode=9;
return event.keyCode;
}
}



}



function alertContents(httpRequest) 
{
    //debugger; 
    if (httpRequest.readyState == 4) 
    {
        if (httpRequest.status == 200) 
        {
              var flag=httpRequest.responseText;   
            if(flag=="0")
            {
                alert("Invalid User Name or Password" );
                return false;
            }
            else
            {
                //debugger;
                window.location.href="Default.aspx";
                //window.location.href="citymaster.aspx";
            }
        }
        else 
        {
            alert('There was a problem with the request.');
        }
    }

}

function forfocus()
{
     var browser=navigator.appName;
    document.getElementById('drpcenter').focus();
    if(document.getElementById('hiddendepo').value=="depo")
    {
        var tbl=document.getElementById('tbllogin');
        tbl.rows[0].style.display="none";
        tbl.rows[1].style.display="none";
        tbl.rows[2].style.display="none";
        tbl.rows[3].style.display="none";
        if(browser!="Microsoft Internet Explorer")
        {
            document.getElementById('tragency').style.display="table-row"
        }
        else
        {
            document.getElementById('tragency').style.display="block";
        }
    }
    if(document.getElementById('hiddenshowrdbtn').value=="no")
    {
        document.getElementById('rwrbtn').style.display="none"
    }
}