// JScript File
var jq = jQuery.noConflict();
var browser = navigator.appName;
//  GLOBAL VARIABLE FOR LINEAGE GRID 
var row_counter = 0;
var radiobtn = 0;
var radiobtn1 = "";
var radiobtn2 = "";
var ro_no = "";
var txtbkid = "";
var txtrono = "";
var txtrecamt = ""
var txtbkamt = "";
var txtclname = "";
var txtretexec = "";
var txtstatus = "";
var txtext1 = "";
var btnopr = "";

var lin_rono1 = "";
var lin_billamt1 = "";
//mul_bill="mul_billno"+z;
var lin_billamt1 = "";
var lin_total1 = "";
var lin_bookid1 = "";
var lin_client1 = "";
var lin_retainer1 = "";

var txtbkid = "";
var txtrono = "";
var txtrecamt = ""
var txtbkamt = "";
var txtclname = "";
var txtretexec = "";
var txtstatus = "";
var txtext1 = "";
var btnopr = "";
var buf = new StringBuffer();

function StringBuffer() {
    this.buffer = [];
}

StringBuffer.prototype.append = function append(string) {
    this.buffer.push(string);
    return this;
};

StringBuffer.prototype.toString = function toString() {
    return this.buffer.join("");
};
var strhtml = "";

function tabvalue(id)
{
if(event.keyCode==13)
{
if(document.activeElement.id==id)
{
    if(document.getElementById('btnSave').disabled==false)
    {
    document.getElementById('btnSave').focus();
    }
return;

}
else if(document.activeElement.type=="button" || document.activeElement.type=="submit")
{
event.keyCode=13;
return event.keyCode;

}

else
{
//alert(event.keyCode);
event.keyCode=9;
//alert(event.keyCode);
return event.keyCode;
}
}//-=======================end here======================
}


    function checkdateforfrom(input)
    {
    var dateformat=document.getElementById('hiddendateformat').value;
      if(input.value!="")
      {
        if(input.value.length!=10)
        {
        alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
            document.getElementById('txtfrom').focus();
            return false;       
        }
      }
    if(input.value!="")
    {
        
        var dat=new Date();
        var dat1=dat.toDateString();
        var curryear=dat1.split(' ')[3];
        var curryear1=curryear.substr(2,2);
    
    if(dateformat=="mm/dd/yyyy")
    {
    if(input.value.indexOf('/')==2)
        {
            if(input.value.substring(3).indexOf('/')!=2)
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
            document.getElementById('txtfrom').focus();
               return false;
            } 
            }
             else
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
             document.getElementById('txtfrom').focus();
               return false;
               }
       var enterdate=input.value.split('/')[2];
      if(enterdate.length!=4)
      if(enterdate>=curryear1||enterdate<=curryear1)
        {
        input.value=input.value.split("/")[0]+"/"+input.value.split("/")[1]+"/"+"20"+input.value.split("/")[2];
    
        document.getElementById('txtfrom').value=input.value;
       // alert('h');
        }
    }
    
    
     if  (dateformat=="yyyy/mm/dd")
    {
    if(input.value.indexOf('/')==4)
        {
            if(input.value.substring(5).indexOf('/')!=2)
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
            document.getElementById('txtfrom').focus();
               return false;
            }            
        }
         else
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
             document.getElementById('txtfrom').focus();
               return false;
               }
      var enterdate=input.value.split('/')[0];
      if(enterdate.length!=4)
     if(enterdate>=curryear1||enterdate<=curryear1)
        {
        input.value=input.value.split("/")[0]+"/"+input.value.split("/")[1]+"/"+"20"+input.value.split("/")[2];
    
        document.getElementById('txtfrom').value=input.value;
       // alert('h');
        }
    }
    
    
     if(dateformat=="dd/mm/yyyy")
     {
      if(input.value.indexOf('/')==2)
        {
            if(input.value.substring(3).indexOf('/')!=2)
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
             document.getElementById('txtfrom').focus();
               return false;
            } 
            }
            else
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
             document.getElementById('txtfrom').focus();
               return false;
               }
      var enterdate=input.value.split('/')[2];
      if(enterdate.length!=4)
      if(enterdate>=curryear1||enterdate<=curryear1)
        {
        input.value=input.value.split("/")[0]+"/"+input.value.split("/")[1]+"/"+"20"+input.value.split("/")[2];
    
        document.getElementById('txtfrom').value=input.value;
       // alert('h');
        }
    }
    
 
    
    
   
 if(dateformat=="mm/dd/yyyy")
 
 {
 var validformat=/^\d{2}\/\d{2}\/\d{4}$/ //Basic check for format validity
 
 }
 if(dateformat=="yyyy/mm/dd")
 
 {
var validformat=/^\d{4}\/\d{2}\/\d{2}$/ //Basic check for format validity
}
if(dateformat=="dd/mm/yyyy")
{
var validformat=/^\d{2}\/\d{2}\/\d{4}$/ //Basic check for format validity
}

if (!validformat.test(input.value))
{
if(input.value=="")
{
return true;
}
//alert(document.activeElement.id);
//alert(" Please Fill The Date In "+dateformat+" Format");
//popUpCalendar(document.activeElement,document.activeElement,dateformat);
setTimeout(settime1,15);
daid=input;
//return false;
return;
}
else
{ //Detailed check for valid date ranges
if(dateformat=="yyyy/mm/dd")

{
var yearfield=input.value.split("/")[0]
var monthfield=input.value.split("/")[1]
var dayfield=input.value.split("/")[2]
var dayobj = new Date(yearfield, monthfield-1, dayfield)
}
if(dateformat=="mm/dd/yyyy")

{
var yearfield=input.value.split("/")[2]
var monthfield=input.value.split("/")[0]
var dayfield=input.value.split("/")[1]
//var dayobj = new Date(monthfield-1, dayfield, yearfield)
var dayobj = new Date(yearfield, monthfield-1, dayfield)

}
if(dateformat=="dd/mm/yyyy")
{
var yearfield=input.value.split("/")[2]
var monthfield=input.value.split("/")[1]
var dayfield=input.value.split("/")[0]
//var dayobj = new Date(dayfield, monthfield-1, yearfield)
var dayobj = new Date(yearfield, monthfield-1, dayfield)
}
}

//if ((dayobj.getMonth()+1!=monthfield)||(dayobj.getDate()!=dayfield)||(dayobj.getFullYear()!=yearfield)) 


daid=input;
var abcd= dayobj.getMonth()+1;

var date1=dayobj.getDate();
var year1=dayobj.getFullYear();
if ((abcd!=monthfield)||(date1!=dayfield)||(year1!=yearfield))  
{
alert(" Please Fill The Date In "+dateformat+" Format");
daid.focus();
daid.value="";
//input.value="";
return false;
}


 
returnval=true
 


if (returnval==false) 

input.select()
return returnval

}

}


 function checkdateforto(input)
 {
  var dateformat=document.getElementById('hiddendateformat').value;
    if(input.value!="")
      {
        if(input.value.length!=10)
        {
        alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
             document.getElementById('txtto').focus();
            return false;       
        }
      }
     
    if(input.value!="")
     {
     
    

    var dat=new Date();
    var dat1=dat.toDateString();
    var curryear=dat1.split(' ')[3];
    var curryear1=curryear.substr(2,2);
    
    if  (dateformat=="mm/dd/yyyy")
    {
            if(input.value.indexOf('/')==2)
            {
            if(input.value.substring(3).indexOf('/')!=2)
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
             document.getElementById('txtto').focus();
               return false;
            } 
            }
            else
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
             document.getElementById('txtto').focus();
               return false;
               }
      var enterdate=input.value.split('/')[2];
      if(enterdate.length!=4)
     if(enterdate>=curryear1||enterdate<=curryear1)
        {
        input.value=input.value.split("/")[0]+"/"+input.value.split("/")[1]+"/"+"20"+input.value.split("/")[2];
    
        document.getElementById('txtto').value=input.value;
       // alert('h');
        }
    }
    
    
     if  (dateformat=="yyyy/mm/dd")
    {
        if(input.value.indexOf('/')==4)
        {
            if(input.value.substring(5).indexOf('/')!=2)
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
             document.getElementById('txtto').focus();
               return false;
            }            
        }
        else
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
             document.getElementById('txtto').focus();
               return false;
               }
      var enterdate=input.value.split('/')[0];
      if(enterdate.length!=4)
     if(enterdate>=curryear1||enterdate<=curryear1)
        {
        input.value=input.value.split("/")[0]+"/"+input.value.split("/")[1]+"/"+"20"+input.value.split("/")[2];
    
        document.getElementById('txtto').value=input.value;
       // alert('h');
        }
    }
    
    
     if(dateformat=="dd/mm/yyyy")
     {
        if(input.value.indexOf('/')==2)
        {
            if(input.value.substring(3).indexOf('/')!=2)
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
            document.getElementById('txtto').focus();
               return false;
            } 
            }
            else
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
             document.getElementById('txtto').focus();
               return false;
               }
      var enterdate=input.value.split('/')[2];
      if(enterdate.length!=4)
      if(enterdate>=curryear1||enterdate<=curryear1)
        {
        input.value=input.value.split("/")[0]+"/"+input.value.split("/")[1]+"/"+"20"+input.value.split("/")[2];
    
        document.getElementById('txtto').value=input.value;
       // alert('h');
        }
    }
    
 
    
    
   
 if(dateformat=="mm/dd/yyyy")
 
 {
 var validformat=/^\d{2}\/\d{2}\/\d{4}$/ //Basic check for format validity
 
 }
 if(dateformat=="yyyy/mm/dd")
 
 {
var validformat=/^\d{4}\/\d{2}\/\d{2}$/ //Basic check for format validity
}
if(dateformat=="dd/mm/yyyy")
{
var validformat=/^\d{2}\/\d{2}\/\d{4}$/ //Basic check for format validity
}

if (!validformat.test(input.value))
{
if(input.value=="")
{
return true;
}
//alert(document.activeElement.id);
//alert(" Please Fill The Date In "+dateformat+" Format");
//popUpCalendar(document.activeElement,document.activeElement,dateformat);
setTimeout(settime1,15);
daid=input;
//return false;
return;
}
else
{ //Detailed check for valid date ranges
if(dateformat=="yyyy/mm/dd")

{
var yearfield=input.value.split("/")[0]
var monthfield=input.value.split("/")[1]
var dayfield=input.value.split("/")[2]
var dayobj = new Date(yearfield, monthfield-1, dayfield)
}
if(dateformat=="mm/dd/yyyy")

{
var yearfield=input.value.split("/")[2]
var monthfield=input.value.split("/")[0]
var dayfield=input.value.split("/")[1]
//var dayobj = new Date(monthfield-1, dayfield, yearfield)
var dayobj = new Date(yearfield, monthfield-1, dayfield)

}
if(dateformat=="dd/mm/yyyy")
{
var yearfield=input.value.split("/")[2]
var monthfield=input.value.split("/")[1]
var dayfield=input.value.split("/")[0]
//var dayobj = new Date(dayfield, monthfield-1, yearfield)
var dayobj = new Date(yearfield, monthfield-1, dayfield)
}
}

//if ((dayobj.getMonth()+1!=monthfield)||(dayobj.getDate()!=dayfield)||(dayobj.getFullYear()!=yearfield)) 


daid=input;
var abcd= dayobj.getMonth()+1;

var date1=dayobj.getDate();
var year1=dayobj.getFullYear();
if ((abcd!=monthfield)||(date1!=dayfield)||(year1!=yearfield))  
{
alert(" Please Fill The Date In "+dateformat+" Format");
daid.focus();
daid.value="";
//input.value="";
return false;
}


 
returnval=true
 


if (returnval==false) 

input.select()
return returnval

}

//==============for validation====

if( document.getElementById('txtfrom').value=="")
{
alert('Please select from date');
document.getElementById('txtfrom').value=""
document.getElementById('txtfrom').focus();
return false;

}
else
{
var frm = document.getElementById('txtfrom').value;
var frmdt = new Date(frm);
var tod= "";
if( document.getElementById('txtto').value!="")
 tod= document.getElementById('txtto').value;
else
{
//alert('gaurav1');
//alert('Please select to date');
return false;
}
var todt= new Date(tod);
if(frmdt > todt)
{
alert ('From date cannot be greater than to date');
return false;
}
}
}



//=======================================

function checkdateforins(input)
    {
    var dateformat=document.getElementById('hiddendateformat').value;
      if(input.value!="")
      {
        if(input.value.length!=10)
        {
        alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
            document.getElementById('txtinsertion').focus();
            return false;       
        }
      }
    if(input.value!="")
    {
        
        var dat=new Date();
        var dat1=dat.toDateString();
        var curryear=dat1.split(' ')[3];
        var curryear1=curryear.substr(2,2);
    
    if(dateformat=="mm/dd/yyyy")
    {
    if(input.value.indexOf('/')==2)
        {
            if(input.value.substring(3).indexOf('/')!=2)
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
            document.getElementById('txtinsertion').focus();
               return false;
            } 
            }
            else
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
             document.getElementById('txtinsertion').focus();
               return false;
               }
       var enterdate=input.value.split('/')[2];
      if(enterdate.length!=4)
      if(enterdate>=curryear1||enterdate<=curryear1)
        {
        input.value=input.value.split("/")[0]+"/"+input.value.split("/")[1]+"/"+"20"+input.value.split("/")[2];
    
        document.getElementById('txtinsertion').value=input.value;
       // alert('h');
        }
    }
    
    
     if  (dateformat=="yyyy/mm/dd")
    {
    if(input.value.indexOf('/')==4)
        {
            if(input.value.substring(5).indexOf('/')!=2)
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
            document.getElementById('txtinsertion').focus();
               return false;
            }            
        }
        else
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
             document.getElementById('txtinsertion').focus();
               return false;
               }
      var enterdate=input.value.split('/')[0];
      if(enterdate.length!=4)
     if(enterdate>=curryear1||enterdate<=curryear1)
        {
        input.value=input.value.split("/")[0]+"/"+input.value.split("/")[1]+"/"+"20"+input.value.split("/")[2];
    
        document.getElementById('txtinsertion').value=input.value;
       // alert('h');
        }
    }
    
    
     if(dateformat=="dd/mm/yyyy")
     {
      if(input.value.indexOf('/')==2)
        {
            if(input.value.substring(3).indexOf('/')!=2)
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
             document.getElementById('txtinsertion').focus();
               return false;
            } 
            }
            else
            {
            alert("Date should enter in " + dateformat + " dateformat");
            input.value="";
             document.getElementById('txtinsertion').focus();
               return false;
               }
      var enterdate=input.value.split('/')[2];
      if(enterdate.length!=4)
      if(enterdate>=curryear1||enterdate<=curryear1)
        {
        input.value=input.value.split("/")[0]+"/"+input.value.split("/")[1]+"/"+"20"+input.value.split("/")[2];
    
        document.getElementById('txtinsertion').value=input.value;
       // alert('h');
        }
    }
    
 
    
    
   
 if(dateformat=="mm/dd/yyyy")
 
 {
 var validformat=/^\d{2}\/\d{2}\/\d{4}$/ //Basic check for format validity
 
 }
 if(dateformat=="yyyy/mm/dd")
 
 {
var validformat=/^\d{4}\/\d{2}\/\d{2}$/ //Basic check for format validity
}
if(dateformat=="dd/mm/yyyy")
{
var validformat=/^\d{2}\/\d{2}\/\d{4}$/ //Basic check for format validity
}

if (!validformat.test(input.value))
{
if(input.value=="")
{
return true;
}
//alert(document.activeElement.id);
//alert(" Please Fill The Date In "+dateformat+" Format");
//popUpCalendar(document.activeElement,document.activeElement,dateformat);
setTimeout(settime1,15);
daid=input;
//return false;
return;
}
else
{ //Detailed check for valid date ranges
if(dateformat=="yyyy/mm/dd")

{
var yearfield=input.value.split("/")[0]
var monthfield=input.value.split("/")[1]
var dayfield=input.value.split("/")[2]
var dayobj = new Date(yearfield, monthfield-1, dayfield)
}
if(dateformat=="mm/dd/yyyy")

{
var yearfield=input.value.split("/")[2]
var monthfield=input.value.split("/")[0]
var dayfield=input.value.split("/")[1]
//var dayobj = new Date(monthfield-1, dayfield, yearfield)
var dayobj = new Date(yearfield, monthfield-1, dayfield)

}
if(dateformat=="dd/mm/yyyy")
{
var yearfield=input.value.split("/")[2]
var monthfield=input.value.split("/")[1]
var dayfield=input.value.split("/")[0]
//var dayobj = new Date(dayfield, monthfield-1, yearfield)
var dayobj = new Date(yearfield, monthfield-1, dayfield)
}
}

//if ((dayobj.getMonth()+1!=monthfield)||(dayobj.getDate()!=dayfield)||(dayobj.getFullYear()!=yearfield)) 


daid=input;
var abcd= dayobj.getMonth()+1;

var date1=dayobj.getDate();
var year1=dayobj.getFullYear();
if ((abcd!=monthfield)||(date1!=dayfield)||(year1!=yearfield))  
{
alert(" Please Fill The Date In "+dateformat+" Format");
daid.focus();
daid.value="";
//input.value="";
return false;
}


 
returnval=true
 


if (returnval==false) 

input.select()
return returnval

}

}


//==========================================    
    
    


////////////////////////////////////////////////////// new add

function CommonCreateRow(TableName) {

    if (confirm("Do You Want To Add New Row")) {
        var table = document.getElementById(TableName);
        var rowCount = table.rows.length;
        var colCount = table.rows[1].cells.length;
        var row = table.insertRow(rowCount);
        for (var i = 0; i < colCount; i++) {
            var newcell = row.insertCell(i);
            if (table.rows[rowCount - 1].cells[i].style.display == "none") {
                newcell.style.display = "none";
            }
            if (table.rows[rowCount - 1].cells[i].align == "center") {
                newcell.align = "center";
            }
            newcell.innerHTML = table.rows[rowCount - 1].cells[i].innerHTML;
            for (var x = 0; x < newcell.childNodes.length; x++) {
                var old_value = "";
                if (newcell.childNodes[x].alt == "copydata") {
                    old_value = document.getElementById(newcell.childNodes[x].id).value;
                }
                var old_value_drp = "";
                if (newcell.childNodes[x].title != "") {
                    old_value_drp = newcell.childNodes[x].title;
                }
                switch (newcell.childNodes[x].type || newcell.childNodes[x].tagName) {
                    case "text":
                        if (newcell.childNodes[x].id.split('_')[0] == "txtsno") {
                            newcell.childNodes[x].value = parseInt(rowCount); newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));
                        }
                        else {
                            newcell.childNodes[x].value = old_value; newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));
                        }
                        break;
                    case "hidden":
                        newcell.childNodes[x].value = old_value; newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));
                        break;
                    case "IMG":
                        newcell.childNodes[x].value = newcell.childNodes[x].value; newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1)); var calid = jq('#' + newcell.childNodes[x].id).attr("onclick").split(',')[0] + "," + jq('#' + newcell.childNodes[x].id).attr("onclick").split(',')[1].slice(0, jq('#' + newcell.childNodes[x].id).attr("onclick").split(',')[1].length - 1) + newcell.childNodes[x].id.split('_')[1] + "," + jq('#' + newcell.childNodes[x].id).attr("onclick").split(',')[2] + "," + jq('#' + newcell.childNodes[x].id).attr("onclick").split(',')[3]; jq('#' + newcell.childNodes[x].id).attr("onclick", calid);
                        break;
                    case "button":
                        newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));
                        break;
                    case "checkbox":
                        newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));
                        jq('#' + newcell.childNodes[x].id).attr('checked', false);
                        break;
                    case "select-one":
                        newcell.childNodes[x].value = old_value_drp; newcell.childNodes[x].id = newcell.childNodes[x].id.split('_')[0] + "_" + (parseInt(newcell.childNodes[x].id.split('_')[1]) + parseInt(1));
                        break;
                }
            }
        }
        document.getElementById(row.cells[1].childNodes[0].id).focus();
        document.getElementById(row.cells[7].childNodes[0].id).value="new";

        count++;
        return false
    }
    return false;
}
function DeleteRow(TableName) {
    if (confirm("Do You Want To Delete Row")) {
        var table = document.getElementById(TableName);
        var rowCount = table.rows.length;
        if (rowCount != "2") {
            table.deleteRow(rowCount - 1);

            if (TableName == "ItemDetailTable") {
                CountRowsItem--;
            }
            else if (TableName == "ChargeDetailTable") {
                CountRowsCharge--;
            }
        }
        else {
            alert('This Row Can Not Be Deleted !!');
            return false;
        }
    }
}
var executive = "Receipt no.";
function ExpensesDetailHeader() {
    var hdsview = "";
    hdsview += "<table  id='ExpensesDetailTable' class='gridtable'>";
    hdsview += "<thead><tr>"
    hdsview += "<th style='width:2%; text-align:center;'>Sr.No.</th>";
    hdsview += "<th style='width:20%; text-align:center;'>" + executive + "<font color=red> *[F2]</font></th>"
    hdsview += "<th style='width:20%; text-align:center;'>BK ID</th>"
    hdsview += "<th style='width:10%; text-align:center;'>Received Amt</th>"
    hdsview += "<th style='width:10%; text-align:center;'>Booking Amt</th>"
    hdsview += "<th style='width:15%; text-align:center;'>Client Name</th>"
    hdsview += "<th style='width:10%; text-align:center;'>Exec/Retainer</th>"
    hdsview += "<th style='width:10%; text-align:center;'>Status</th>"
    hdsview += "</tr></thead>"
    return hdsview;
}
function BindExpensesGrid() {
    count = 0;
    jq("#ExpensesView").empty();
    var hdsview = "";
    hdsview += ExpensesDetailHeader();
    hdsview += "<tr>"
    hdsview += "<td><input  name='Disable' class='gridinputclass' style='text-align:center;'id=txtsno_" + count + " value='" + (parseInt(count) + parseInt(1)) + "' accept='numeric' MaxLength='14' ></td>"
    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtrono_" + count + " onkeydown = 'javascript:return bindbkidf21(event,this.id);' ><input  type='hidden' id=hdnrono_" + count + " ></td>"
    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtbkid_" + count + " disabled ></td>"
    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:right;' id=txtrecamt_" + count + "  MaxLength='15' onkeyup='javascript:return isNumberKey(event);' onblur='javascript:return chkamount_lineage(this);'></td>"
    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtbkamt_" + count + " disabled></td>"
    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtclname_" + count + " disabled></td>"
    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtretexec_" + count + " disabled></td>"
    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtstatus_" + count + " disabled value='new'></td>"
    hdsview += "</tr>"
    hdsview += "</table>";
    count++;
    jq('#ExpensesView').append(hdsview);

    return false
}
function Onchangebutton() {
    if (document.getElementById('RadioButton2').checked == true) {
        executive = "Executive/Repre.";
        BindExpensesGrid();
    }
    else {
        executive = "Receipt no.";
        BindExpensesGrid();
    }
}

var receiptamt = "";
function bindbkidf21(event, a) {
    var keycode = event.keyCode ? event.keyCode : event.which;
    var activeid = document.activeElement.id.split('_')[1];
    var chked = "";
    if (keycode == 113) {
        CurrentTextId = document.activeElement.id;
        OffSetForGrid(document.activeElement.id, "divbkid", "lstbkid", "ExpensesView");
        var compcode = jq('#hiddencomcode').val();
        var userid = jq('#hiddenuserid').val()
        var agcode = jq('#hiddenagenycode').val()
        var ronum = jq('#txtrono_' + activeid).val()
        var dateformat = jq('#hiddendateformat').val()
        var extra1 = "";
        var extra2 = "";
        if (document.getElementById('RadioButton2').checked == true) {
            check = "0";
        }
        else {
            check = "1";
        }

        var parameterValueArray = [compcode, agcode, ronum, userid, dateformat, extra1, extra2, check];
        var res = multi_booking.BindBKID(parameterValueArray, call_bkid1);

        return false;
    }
    else if (keycode == 8 || keycode == 46) {
        jq('#txtbkid_' + activeid).val('')
        jq('#txtrono_' + activeid).val('')
        jq('#txtbkamt_' + activeid).val('')
        jq('#txtclname_' + activeid).val('')
        jq('#txtretexec_' + activeid).val('')
        jq('#txtstatus_' + activeid).val('')
    }
    else if (event.keyCode != 13 && event.keyCode != 37 && event.keyCode != 39 && event.keyCode != 9 && event.keyCode != 17 && event.shiftKey == false && event.ctrlKey == false && event.altKey == false) {
        jq('#txtbkid_' + activeid).val('')
        jq('#txtrono_' + activeid).val('')
        jq('#txtbkamt_' + activeid).val('')
        jq('#txtclname_' + activeid).val('')
        jq('#txtretexec_' + activeid).val('')
        jq('#txtstatus_' + activeid).val('')
    }
    if (event.ctrlKey == true && event.keyCode == 88) {
        jq('#txtbkid_' + activeid).val('')
        jq('#txtrono_' + activeid).val('')
        jq('#txtbkamt_' + activeid).val('')
        jq('#txtclname_' + activeid).val('')
        jq('#txtretexec_' + activeid).val('')
        jq('#txtstatus_' + activeid).val('')
    }
}
function call_bkid1(res) {
    var dsclient = res.value;
    var pkgitem = document.getElementById("lstbkid");
    if (dsclient != null && typeof (dsclient) == "object" && dsclient.Tables[0].Rows.length > 0) {
        pkgitem.style.width = "254px"
        pkgitem.options.length = 0;
        pkgitem.options[0] = new Option("-Select Booking ID-", "0");
        pkgitem.options.length = 1;
        for (var i = 0  ; i < dsclient.Tables[0].Rows.length; ++i) {
            if (document.getElementById('RadioButton2').checked == true) {
                fetchdatastr = dsclient.Tables[0].Rows[i].REPCODE + "~" + dsclient.Tables[0].Rows[i].REPNAME + "~" + dsclient.Tables[0].Rows[i].RONO + "~" + dsclient.Tables[0].Rows[i].RO_DATE + "~" + dsclient.Tables[0].Rows[i].BKID + "~" + dsclient.Tables[0].Rows[i].AGENCY_NAME + "~" + dsclient.Tables[0].Rows[i].AGENCY_CODE + "~" + dsclient.Tables[0].Rows[i].CLIENT_CODE + "~" + dsclient.Tables[0].Rows[i].CLIENT + "~" + dsclient.Tables[0].Rows[i].RETAINER + "~" + dsclient.Tables[0].Rows[i].RETAINER_NAME + "~" + dsclient.Tables[0].Rows[i].EXEC_CODE + "~" + dsclient.Tables[0].Rows[i].EXECUTIVE_NAME + "~" + dsclient.Tables[0].Rows[i].BK_AMT
                pkgitem.options[pkgitem.options.length] = new Option(dsclient.Tables[0].Rows[i].REPCODE + "~" + dsclient.Tables[0].Rows[i].REPCODE, fetchdatastr);
                pkgitem.options.length;
            }
            else {
                fetchdatastr = dsclient.Tables[0].Rows[i].RECEIPT_NO + "~" + dsclient.Tables[0].Rows[i].RONO + "~" + dsclient.Tables[0].Rows[i].RO_DATE + "~" + dsclient.Tables[0].Rows[i].BKID + "~" + dsclient.Tables[0].Rows[i].AGENCY_NAME + "~" + dsclient.Tables[0].Rows[i].AGENCY_CODE + "~" + dsclient.Tables[0].Rows[i].CLIENT_CODE + "~" + dsclient.Tables[0].Rows[i].CLIENT + "~" + dsclient.Tables[0].Rows[i].RETAINER + "~" + dsclient.Tables[0].Rows[i].RETAINER_NAME + "~" + dsclient.Tables[0].Rows[i].EXEC_CODE + "~" + dsclient.Tables[0].Rows[i].EXECUTIVE_NAME + "~" + dsclient.Tables[0].Rows[i].BK_AMT
                pkgitem.options[pkgitem.options.length] = new Option(dsclient.Tables[0].Rows[i].RONO + "~" + dsclient.Tables[0].Rows[i].BKID, fetchdatastr);
                pkgitem.options.length;
            }
        }
    }
    else {
        pkgitem.options[0] = new Option("---There is no data accourding your search---", "");
        return false;
    }
    jq('#lstbkid').focus();
    return false;
}
function Clickronum1(event) {
    var key = event.keyCode ? event.keyCode : event.which;
    if (key == 13 || event.type == "click") {
        if (jq('#lstbkid').val() == "") {
            alert("Please Select Work Contract Type");
            jq('#lstbkid').focus();
            return false;
        }
        var page = document.getElementById('lstbkid').value;
        var str = page.split("~");
        var activeid = CurrentTextId.split('_')[1];

        if (document.getElementById('RadioButton2').checked == true) {
            jq('#txtrono_' + activeid).val(str[1])
            jq('#hdnrono_' + activeid).val(str[0])
            jq('#txtbkid_' + activeid).val(str[4])
            jq('#txtbkamt_' + activeid).val(str[13])
            jq('#txtclname_' + activeid).val(str[8])
            if (str[8] == "" || str[8] == "null")
                jq('#txtretexec_' + activeid).val(str[12])
            else
                jq('#txtretexec_' + activeid).val(str[10])

            var cnt_ = 0
            for (_j = 0; _j < row_counter; _j++) {

                if (str[2] == jq('#txtbkid_' + _j).val()) {
                    cnt_ = cnt_ + 1;
                    if (cnt_ > 1) {
                        alert('This Ro No. is already selected!');
                        jq('#txtbkid_' + _j).val('');
                        jq('#txtrono_' + _j).val('');
                        return false;
                    }
                }
            }
            receiptamt = jq('#hiddenreceiptamount').val();
            jq('#txtbalanceamt').val(receiptamt)
        }
        else {
            jq('#txtrono_' + activeid).val(str[1])
            jq('#hdnrono_' + activeid).val(str[1])
            jq('#txtbkid_' + activeid).val(str[3])
            jq('#txtbkamt_' + activeid).val(str[12])
            jq('#txtclname_' + activeid).val(str[7])
            if (str[8] == "" || str[8] == "null")
                jq('#txtretexec_' + activeid).val(str[11])
            else
                jq('#txtretexec_' + activeid).val(str[9])

            var cnt_ = 0
            for (_j = 0; _j < row_counter; _j++) {

                if (str[2] == jq('#txtbkid_' + _j).val()) {
                    cnt_ = cnt_ + 1;
                    if (cnt_ > 1) {
                        alert('This Ro No. is already selected!');
                        jq('#txtbkid_' + _j).val('');
                        jq('#txtrono_' + _j).val('');
                        return false;
                    }
                }
            }
            receiptamt = jq('#hiddenreceiptamount').val();
            jq('#txtbalanceamt').val(receiptamt)
        }
        jq("#divbkid").hide("slow");

        jq('#txtrecamt_' + activeid).focus();

        return false;
    }
    else if (event.keyCode == 27) {
        jq("#divbkid").hide("slow");
        jq('#txtrono_' + activeid).focus();
        return false;
    }
}


function chkamount_lineage(ab) {

    var fld = ab.value;
    var id = "";
    if (fld == undefined) {
        fld = $(ab).value;
        id = ab;
        if (fld.match(/^\d+(\.\d{1})?$/i) && fld.indexOf(".") != -1) {
            $(ab).value = $(ab).value + "0"
        }
    }
    else {
        fld = ab.value
        id = ab.id;
        if (fld.match(/^\d+(\.\d{1})?$/i) && fld.indexOf(".") != -1) {
            ab.value = ab.value + "0"
        }
    }
    if (fld != "") {
        if (fld.match(/^\d+(\.\d{2})?$/i)) {
            getamt(fld);
            return true;
        }
        else {
            alert("Input error")
            ab.focus();
            ab.value = "";
            return false;
        }
    }

    return true;
}
var totasval = 0
function getamt(val) {
    totasval = 0;
    for (_i = 0; _i < count; _i++) {
        txtrecamt = "txtrecamt_" + _i
        txtbkamt = "txtbkamt_" + _i
        totasval = totasval + parseFloat(jq('#txtrecamt_' + _i).val())
        if (totasval > parseFloat(jq('#txtbalanceamt').val())) {
            alert('Assigned amount should not greater than booking amount!');
            jq('#txtrecamt_' + _i).val('')
            jq('#txtrecamt_' + _i).focus();
            totasval = "0";
            jq('#txttotalexpamount').val(totasval)
            return false;
        }
        // totasval = totasval + parseFloat(jq('#txtrecamt_' + _i).val())
    }
    jq('#txttotalexpamount').val(totasval)


}

var rowsendtoparent = 0;
var lin_rono = "";
var lin_billamt = "";
var lin_total = "";
var lin_bookid = "";
var lin_client = "";
var lin_retainer = "";
var countac;
function postclick1(gau) {
    if (jq('#txttotalexpamount').val() == "0" || jq('#txttotalexpamount').val() == "") {
        alert('Please adjust atleast 1 bill!');
        return false;
    }

    var mul_unit_hidden_1 = "";
    var mul_adamt_sum = 0;
    if (gau != 'GAURAV')//add by gaurav
    {
        for (var z = 0; z < count; ++z) {
            lin_rono = "txtrono_" + z;
            lin_billamt = "txtbkamt_" + z;
            //mul_bill="mul_billno"+z;
            lin_billamt = "txtbkamt_" + z;
            lin_total = "txtrecamt_" + z;
            lin_bookid = "txtbkid_" + z;
            lin_client = "txtclname_" + z;
            lin_retainer = "txtretexec_" + z;




            if (jq('#txtrecamt_' + z).val() != "" && parseFloat(jq('#txtrecamt_' + z).val()) != 0) {

                //mul_billno_1=mul_billno_1+document.getElementById(mul_billno).value+";";
                lin_rono1 = lin_rono1 + document.getElementById(lin_rono).value + ";";
                lin_billamt1 = lin_billamt1 + document.getElementById(lin_billamt).value + ";";
                lin_total1 = lin_total1 + document.getElementById(lin_total).value + ";";
                lin_bookid1 = lin_bookid1 + document.getElementById(lin_bookid).value + ";";
                lin_client1 = lin_client1 + document.getElementById(lin_client).value + ";";

                lin_retainer1 = lin_retainer1 + document.getElementById(lin_retainer).value + ";";

                rowsendtoparent = parseInt(rowsendtoparent) + 1;

            }
        }
        opener.document.getElementById('hiddenmultirow').value = rowsendtoparent;

        //opener.document.getElementById('hiddenbillno').value=mul_billno_1;
        opener.document.getElementById('hiddenbilldt').value = lin_rono1;
        opener.document.getElementById('hiddenoutstand').value = lin_billamt1;
        opener.document.getElementById('hiddenadjust').value = lin_total1;
        opener.document.getElementById('hiddentds').value = lin_bookid1;
        opener.document.getElementById('hiddenst').value = lin_bookid1;

        opener.document.getElementById('hiddenpkk').value = lin_retainer1;


        opener.document.getElementById('txtadjustamt').value = jq('txttotalexpamount').value;
        opener.document.getElementById('txtamthand').value = jq('txtbalanceamt').value;
        var popupdata = opener.document.getElementById('hiddendatafrompopup').value;
        opener.document.getElementById('hiddenreceiptno').value = opener.document.getElementById('txtreceiptno').value;
        countac = count;
        window.close();
        //displayrecord_multi1();
    }//add by gaurav


    //opener.jq('linkbutton2').css("display", "none");
    //opener.document.getElementById('linkbutton3').style.display="none"
}

function dataenter(val) {

    linestatus = "new";
    for (var _h = 0; _h < countac; _h++) {
        txtrono = "txtrono_" + _h;
        txtbkid = "txtbkid_" + _h;
        txtrecamt = "txtrecamt_" + _h
        txtbkamt = "txtbkamt_" + _h;
        txtclname = "txtclname_" + _h;
        txtretexec = "txtretexec_" + _h;
        txtstatus = "txtstatus_" + _h;
        txtext1 = "txtbkid_" + _h;
        //btnopr = "btnopr_" + _h;

        var pcompcode = document.getElementById('hiddencompcode').value;
        var punitcode = document.getElementById('drpunit').value
        var pdoctype = document.getElementById('drptype').value
        var prcptno = document.getElementById('txtreceiptno').value
        var prcptdt = document.getElementById('txtDate').value
        var pbkid = document.getElementById(txtbkid).value//
        var prcptamt = document.getElementById(txtrecamt).value//
        var puserid = document.getElementById('hiddenuserid').value;
        var pdml_flag = "";
        if (document.getElementById(txtstatus).value == "DELETE") {
            pdml_flag = "D"
        }
        else if (document.getElementById(txtstatus).value == "MODIFY") {
            pdml_flag = "U"
        }
        else {
            pdml_flag = "I"
        }

        var pprev_bkid = document.getElementById(txtext1).value// 
        var pdateformat = document.getElementById('hiddendateformat').value;
        var pextra1 = ""
        var pextra2 = ""
        var agcode = document.getElementById('txtagcode').value + document.getElementById('txtagsubcode').value
        if (document.getElementById(txtbkid).value != "" && document.getElementById(txtbkid).value != null) {
            var ds = ReceiptEntry.ExecuteBKID(pcompcode, punitcode, pdoctype, prcptno, prcptdt, pbkid, prcptamt, puserid, pdml_flag, pprev_bkid, pdateformat, pextra1, pextra2)
        }

    }
}
function enablelink3_lineage() {
    _flag = "execute"
    document.getElementById('linkbutton3').style.display = 'block';
    document.getElementById('linkbutton3').disabled = false
}
function executelineage(val) {
    _flag = "execute"
    newmofify_flag = "execute"
    linestatus = "execute";
    strhtml = "";
    var pcompcode = document.getElementById('hiddencompcode').value;
    var punitcode = document.getElementById('drpunit').value
    var pdoctype = document.getElementById('drptype').value
    var prcptno = document.getElementById('txtreceiptno').value
    var prcptdt = document.getElementById('txtDate').value
    var pbkid = ""//
    var prcptamt = ""//
    var puserid = document.getElementById('hiddenuserid').value;
    var pdml_flag = "E"
    var pprev_bkid = ""// 
    var pdateformat = document.getElementById('hiddendateformat').value;
    var pextra1 = ""
    var pextra2 = ""
    var agcode = document.getElementById('txtagcode').value + document.getElementById('txtagsubcode').value

    ReceiptEntry.ExecuteBKID(pcompcode, punitcode, pdoctype, prcptno, prcptdt, pbkid, prcptamt, puserid, pdml_flag, pprev_bkid, pdateformat, pextra1, pextra2, call_executebkid)
}


function displayrecord_multi1() {
    //document.getElementById('txtreceiptno').value;
    var compcode = opener.document.getElementById('hiddencompcode').value;
    var agcode = opener.document.getElementById('txtagcode').value;
    var agsubcode = opener.document.getElementById('txtagsubcode').value;
    var cdsubcd = agcode + agsubcode;

    var bookingid = opener.document.getElementById('hiddentds').value;
    var insertion = "";
    var book = bookingid.split(";");
    var booki = book.length;
    var booking = ",";
    for (i = 0; i < booki - 1; i++) {
        booking = booking + book[i] + ",";
    }
    //insertion[0];
    // multi_booking.fillgriddata2(compcode,opener.document.getElementById('txtreceiptno').value,agcode,agsubcode,frmdt,todt,dateformat,Execute_HDR_Callback1);
    multi_booking.fillgriddata2(compcode, opener.document.getElementById('txtreceiptno').value, agcode, agsubcode, booking, insertion, cdsubcd, Execute_HDR_Callback1);
    return false;
}
var balance = 0;
function call_executebkid(res) {
    var rorlen = 0;
    var rowst = 0;
    var totlen = 0;
    var ds = res.value;
    var dateformat = document.getElementById('hiddendateformat').value;
    var y = 0;
    var heading = 0;
    var billno = 0;
    lin_rono = "lin_rono0";
    lin_billamt = "lin_billamt0";
    //mul_bill="mul_billno"+z;
    lin_billamt = "lin_billamt0";
    lin_total = "lin_total0";
    lin_bookid = "lin_bookid0";
    lin_client = "lin_client0";
    lin_retainer = "lin_retainer0";


    st = 0;
    str = "0";
    count1 = "";
    count2 = ds.Tables[0].Rows.length;
    //opener.document.getElementById('save').innerHTML = "";


    if (ds != null && ds.Tables[0].Rows.length >= 1) {
        opener.document.getElementById('linkbutton2').disabled = true;
        opener.document.getElementById('linkbutton1').disabled = false;
        opener.document.getElementById('btn_print').disabled = false;
        /************************  changes at 21 july*************/
        var popupdatastring = opener.document.getElementById('hiddendatafrompopup').value;
        /**********************************************************/
        var buf = new StringBuffer();
        var row = 0;
        var rw = 0;
        opener.jq("#ExpensesView").empty();
        var hdsview = "";
        gridcount = 0;
        opener.document.getElementById('hdngridcnt').value = 0;
        hdsview += ExpensesDetailHeader1();
        for (row = rw; row < count2; ++row) {
            count = row;
            lin_rono = "txtrono_" + row;
            lin_billamt = "txtbkamt_" + row;
            //mul_bill="mul_billno"+z;
            lin_billamt = "txtbkamt_" + row;
            lin_total = "txtrecamt_" + row;
            lin_bookid = "txtbkid_" + row;
            lin_client = "txtclname_" + row;
            lin_retainer = "txtretexec_" + row;
            lin_rono = document.getElementById(lin_rono).value;
            lin_billamt = document.getElementById(lin_billamt).value;
            lin_total = document.getElementById(lin_total).value;
            lin_bookid = document.getElementById(lin_bookid).value;
            lin_client = document.getElementById(lin_client).value;
            lin_retainer = document.getElementById(lin_retainer).value
            hdsview += "<tr>"
            hdsview += "<td><input  name='Disable' class='gridinputclass' style='text-align:center;'id=txtsno_" + count + " value='" + (parseInt(count) + parseInt(1)) + "' accept='numeric' MaxLength='14' ></td>"
            hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtrono_" + count + " onkeydown = 'javascript:return bindbkidf21(event,this.id);' value='" + lin_rono + "' disabled><input  type='hidden' id=hdnrono_" + count + " ></td>"
            hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtbkid_" + count + " value='" + lin_bookid + "' disabled ></td>"
            hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:right;' id=txtrecamt_" + count + "  value='" + lin_total + "'disabled  accept='decimal' MaxLength='15'></td>"
            hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtbkamt_" + count + "  value='" + lin_billamt + "' disabled></td>"
            hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtclname_" + count + "  value='" + lin_client + "' disabled></td>"
            hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtretexec_" + count + "  value='" + lin_retainer + "' disabled></td>"
            hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtstatus_" + count + "   disabled value='new'></td>"
            hdsview += "</tr>"
            opener.jq('#txtbalanceamt').val(receiptamt)
            opener.jq('#txttotalexpamount').val(totasval)
            balance = parseFloat(receiptamt) - parseFloat(totasval);
            opener.jq('#txtamthand').val(balance);

            opener.jq('#txtadjustamt').val(totasval)

            if (document.getElementById('RadioButton2').checked == true) {
                check = "0";
                opener.jq('#hdnchk32').val(check)
            }
            else {
                check = "1";
                opener.jq('#hdnchk32').val(check)
            }

            //buf.append(table);
        }
        gridcount = count2;
        opener.document.getElementById('hdngridcnt').value = gridcount;
        hdsview += "</table>";
        opener.jq('#ExpensesView').append(hdsview);
        window.close();
    }
    if (glo_link_enadis == "N") {
        if (document.getElementById('linkbutton1') != null)
            document.getElementById('linkbutton1').style.display = "none";
    }
    return false;
}

function ExpensesDetailHeader1() {
    var hdsview = "";
    hdsview += "<table  id='ExpensesDetailTable' class='gridtable'>";
    hdsview += "<thead><tr>"
    hdsview += "<th style='width:2%; text-align:center;'>Sr.No.</th>";
    hdsview += "<th style='width:20%; text-align:center;'>" + executive + "<font color=red> *[F2]</font></th>"
    hdsview += "<th style='width:20%; text-align:center;'>BK ID</th>"
    hdsview += "<th style='width:10%; text-align:center;'>Received Amt</th>"
    hdsview += "<th style='width:10%; text-align:center;'>Booking Amt</th>"
    hdsview += "<th style='width:15%; text-align:center;'>Client Name</th>"
    hdsview += "<th style='width:10%; text-align:center;'>Exec/Retainer</th>"
    hdsview += "<th style='width:10%; text-align:center;'>Status</th>"
    hdsview += "</tr></thead>"
    return hdsview;
}
function BindExpensesGrid1() {
    count = 0;
    opener.jq("#ExpensesView").empty();
    var hdsview = "";
    hdsview += ExpensesDetailHeader1();

    hdsview += "<tr>"
    hdsview += "<td><input  name='Disable' class='gridinputclass' style='text-align:center;'id=txtsno_" + count + " value='" + (parseInt(count) + parseInt(1)) + "' accept='numeric' MaxLength='14' ></td>"
    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtrono_" + count + " onkeydown = 'javascript:return bindbkidf21(event,this.id);' value='" + lin_rono + "' disabled><input  type='hidden' id=hdnrono_" + count + " ></td>"
    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtbkid_" + count + " value='" + lin_bookid + "' disabled ></td>"
    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:right;' id=txtrecamt_" + count + "  value='" + lin_total + "'disabled  accept='decimal' MaxLength='15'></td>"
    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtbkamt_" + count + "  value='" + lin_billamt + "' disabled></td>"
    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtclname_" + count + "  value='" + lin_client + "' disabled></td>"
    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtretexec_" + count + "  value='" + lin_retainer + "' disabled></td>"
    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtstatus_" + count + "   disabled value='new'></td>"
    hdsview += "</tr>"
    hdsview += "</table>";
    count++;
    opener.jq('#ExpensesView').append(hdsview);

    return false
}

var pop_multi = 0;
function saverecord1() {
    var i;
    var compcode = jq('#hiddencompcode').val();
    var userid = jq('#hiddenuserid').val();
    var agencyname = jq('#txtagcode').val() + jq('#txtagsubcode').val();
    var ag_main_code = jq('#txtagcode').val();
    var ag_sub_code = jq('#txtagsubcode').val();
    var unit = jq('#drpunit').val();
    var receiptno = jq('#txtreceiptno').val();
    var receiptdate = jq('#txtDate').val();
    var chnumber = jq('#txtchno').val();
    var place = "";//document.getElementById('txtplace').value;

    var chdate = jq('#txtchdate').val();
    var bank = jq('drpbank').val();
    var voucherdate = jq('#txtvoucherdate').val();
    var voucherno = jq('#txtvoucher').val();
    var rep = "";//document.getElementById('drprep').value;
    var received_region = jq('#drpreceivedrg').val();
    var paymod = jq('#drppaymode').val();
    var doctype = jq('#drptype').val();
    var dateformat = jq('#hiddendateformat').val();


    glo_row = 0;
    var counter = parseInt(document.getElementById('hdngridcnt').value);
    //counter = parseInt(gridcount) + parseInt(glo_row);
    for (i = glo_row; i < counter; i++) {
        var _totad_amt_ = 0;

        lin_rono = "txtrono_" + i;
        lin_billamt = "txtbkamt_" + i;
        //mul_bill="mul_billno"+z;
        lin_billamt = "txtbkamt_" + i;
        lin_total = "txtrecamt_" + i;
        lin_bookid = "txtbkid_" + i;
        lin_client = "txtclname_" + i;
        lin_retainer = "txtretexec_" + i;
        lin_rono = document.getElementById(lin_rono).value;
        lin_billamt = document.getElementById(lin_billamt).value;
        lin_total = document.getElementById(lin_total).value;
        lin_bookid = document.getElementById(lin_bookid).value;
        lin_client = document.getElementById(lin_client).value;
        lin_retainer = document.getElementById(lin_retainer).value


        var aoutstand = parseFloat(lin_billamt) - parseFloat(lin_total);
        var adjustamt = parseFloat(lin_total);
        var diff = aoutstand - adjustamt;
        if (document.getElementById('txtrecamt_' + i).disabled == false) {
            document.getElementById('txtbkamt_' + i).value = diff;
        }
        if (pop_multi == 0)
            var asmtinhand = document.getElementById('txtamthand').value;
        else
            var asmtinhand = receiptamt - totasval;

        txtpub = "txtpub" + i;
        var publication = lin_rono;
        //=============================
        //=============================     
        //if (opener.jq('#txttotalexpamount').val() = "" || opener.jq('#txttotalexpamount').val() < "0") {
        //    alert('Amount Should not be blank or Less than Zero!');
        //    if (document.getElementById('txttotalexpamount').disabled == false) {
        //        document.getElementById('txttotalexpamount').focus();
        //    }
        //    return false;
        //}

        //============== pkk & bkc ==========
        /**************** for looping *************************/
        _totad_amt_ = parseFloat(adjustamt);// + parseFloat(tds) + parseFloat(st) + parseFloat(pkk) + parseFloat(bkc) ;
        if (_totad_amt_ > parseFloat(document.getElementById('lblbalanceamt').value)) {
            alert('Amount should not be greater than outstanding amount');
            document.getElementById('txtrecamt_' + i).focus();
            return false;
        }
        /**************** for looping *************************/
        var billflag = "N";
        txtretainexe = "txtretainexe" + i;
        var remark = adjustamt;
        var totamt = parseFloat(adjustamt);//+parseFloat(tds)+parseFloat(st) +parseFloat(pkk)+parseFloat(bkc) ;
        var extra1 = document.getElementById('hdnchk32').value
        ReceiptEntry.modifygriddata1(compcode, unit, doctype, receiptno, receiptdate, lin_bookid, publication, "", adjustamt, billflag, userid, "", userid, extra1, dateformat);


        document.getElementById('txtrono_' + i).disabled = true;
        document.getElementById('txtbkid_' + i).disabled = true;
        document.getElementById('txtbkamt_' + i).disabled = true;
        document.getElementById('txtrecamt_' + i).disabled = true;
        document.getElementById('txtclname_' + i).disabled = true;
        document.getElementById('txtretexec_' + i).disabled = true;



    }

    document.getElementById('btnpost').disabled = false;
    document.getElementById('btnexpdelrow').disabled = true;

    alert("Adjusted");
    document.getElementById('txtamthand').value = roundNumber(document.getElementById('txtamthand').value, 2);
    document.getElementById('txtadjustamt').value = roundNumber(document.getElementById('txtadjustamt').value, 2);



    document.getElementById('linkbutton1').style.display = "none"
    document.getElementById('linkbutton2').style.display = "none"
    //print_receipt()
    //document.getElementById('linkbutton3').style.display="none"
    return false;

}


function displayrecord_multi12() {
    //document.getElementById('txtreceiptno').value;
    var compcode = document.getElementById('hiddencompcode').value;
    var agcode = document.getElementById('txtagcode').value;
    var agencyname = jq('#txtagcode').val() + jq('#txtagsubcode').val();

    var agsubcode = document.getElementById('txtagsubcode').value;


    var bookingid = "";//opener.document.getElementById('hiddentds').value;
    var insertion = "";

    //insertion[0];
    // multi_booking.fillgriddata2(compcode,opener.document.getElementById('txtreceiptno').value,agcode,agsubcode,frmdt,todt,dateformat,Execute_HDR_Callback1);
    ReceiptEntry.fillgriddata2(compcode, document.getElementById('txtreceiptno').value, agcode, agsubcode, bookingid, insertion, Execute_HDR_Callback12);
    return false;
}
var balance = 0;
function Execute_HDR_Callback12(res) {
    var rorlen = 0;
    var rowst = 0;
    var totlen = 0;
    var ds = res.value;
    var dateformat = document.getElementById('hiddendateformat').value;
    var y = 0;
    var heading = 0;
    var billno = 0;
    lin_rono = "lin_rono0";
    lin_billamt = "lin_billamt0";
    //mul_bill="mul_billno"+z;
    lin_billamt = "lin_billamt0";
    lin_total = "lin_total0";
    lin_bookid = "lin_bookid0";
    lin_client = "lin_client0";
    lin_retainer = "lin_retainer0";
    var sumtotal = 0;

    st = 0;
    str = "0";
    //count1 = "";
    count2 = "";
    count1 = ds.Tables[0].Rows.length;
    document.getElementById('save').innerHTML = "";
    if (ds != null && ds.Tables[0].Rows.length >= 1) {
        document.getElementById('linkbutton2').disabled = true;
        document.getElementById('linkbutton1').disabled = false;
        document.getElementById('btn_print').disabled = false;
        /************************  changes at 21 july*************/
        var popupdatastring = document.getElementById('hiddendatafrompopup').value;
        /**********************************************************/
        var buf = new StringBuffer();
        var row = 0;
        var rw = 0;
        document.getElementById('ExpensesView').style.display = "block";
        var hdsview = "";
        count = 0;
        hdsview += ExpensesDetailHeader1();
        for (row = rw; row < count1; ++row) {
            lin_rono = ds.Tables[0].Rows[row].INSERTION_NO//"txtrono_" + row;
            lin_billamt = ds.Tables[0].Rows[row].BILL_AMOUNT//"txtbkamt_" + row;
            //mul_bill="mul_billno"+z;
            lin_billamt = ds.Tables[0].Rows[row].BILL_AMOUNT;
            lin_total = ds.Tables[0].Rows[row].RECPT_AMT//"txtrecamt_" + row;
            lin_bookid = ds.Tables[0].Rows[row].BOOKING_ID//"txtbkid_" + row;
            lin_client = ds.Tables[0].Rows[row].CLIENT;
            lin_retainer = ds.Tables[0].Rows[row].RETAINER_NAME;
            sumtotal = sumtotal + parseFloat(lin_total)

            hdsview += "<tr>"
            hdsview += "<td><input  name='Disable' class='gridinputclass' style='text-align:center;'id=txtsno_" + count + " value='" + (parseInt(count) + parseInt(1)) + "' accept='numeric' MaxLength='14' ></td>"
            hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtrono_" + count + " onkeydown = 'javascript:return bindbkidf21(event,this.id);' value='" + lin_rono + "' disabled><input  type='hidden' id=hdnrono_" + count + " ></td>"
            hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtbkid_" + count + " value='" + lin_bookid + "' disabled ></td>"
            hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:right;' id=txtrecamt_" + count + "  value='" + lin_total + "' disabled accept='decimal' MaxLength='15'></td>"
            hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtbkamt_" + count + "  value='" + lin_billamt + "' disabled></td>"
            hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtclname_" + count + "  value='" + lin_client + "' disabled></td>"
            hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtretexec_" + count + "  value='" + lin_retainer + "' disabled></td>"
            hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtstatus_" + count + "   disabled value='new'></td>"
            hdsview += "</tr>"
            count++;
        }
        hdsview += "</table>";
        jq('#ExpensesView').append(hdsview);
        document.getElementById('txtbalanceamt').value = document.getElementById('txtamount').value
        jq('#txttotalexpamount').val(sumtotal)
        balance = parseFloat(document.getElementById('txtamount').value) - parseFloat(sumtotal);
        document.getElementById('txtamthand').value = balance;
        document.getElementById('txtadjustamt').value = sumtotal;
    }
    return false;
}


//function BindExpensesGrid12(count1) {
//    count = 0;
//    //jq("#ExpensesView").empty();
//    var hdsview ;
//    hdsview = "";
//    
//    if(count3<1)
//    {
//    
//    hdsview += ExpensesDetailHeader1();
//    
//    }
//    count3++;

//    hdsview += "<tr>"
//    hdsview += "<td><input  name='Disable' class='gridinputclass' style='text-align:center;'id=txtsno_" + count + " value='" + (parseInt(count) + parseInt(1)) + "' accept='numeric' MaxLength='14' ></td>"
//    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtrono_" + count + " onkeydown = 'javascript:return bindbkidf21(event,this.id);' value='" + lin_rono + "' disabled><input  type='hidden' id=hdnrono_" + count + " ></td>"
//    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtbkid_" + count + " value='" + lin_bookid + "' disabled ></td>"
//    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:right;' id=txtrecamt_" + count + "  value='" + lin_total + "' disabled accept='decimal' MaxLength='15'></td>"
//    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtbkamt_" + count + "  value='" + lin_billamt + "' disabled></td>"
//    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtclname_" + count + "  value='" + lin_client + "' disabled></td>"
//    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtretexec_" + count + "  value='" + lin_retainer + "' disabled></td>"
//    hdsview += "<td><input  name='Enable'  class='gridinputclass' style='text-align:left;'  id=txtstatus_" + count + "   disabled value='new'></td>"
//    hdsview += "</tr>"
//    if(count3==count1){
//    hdsview += "</table>";
//    }
//    count++;
//    jq('#ExpensesView').append(hdsview);

//    return false
//}

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

    //    if(document.getElementById('btnDelete').disabled==true)
    //        document.getElementById('btnDelete').src="btimages/delete-off.jpg";
    //    else
    //        document.getElementById('btnDelete').src="btimages/delete.jpg";

    if (document.getElementById('btnExit').disabled == true)
        document.getElementById('btnExit').src = "btimages/exit-off.jpg";
    else
        document.getElementById('btnExit').src = "btimages/exit.jpg";
}