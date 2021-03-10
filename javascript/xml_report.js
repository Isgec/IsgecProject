 function focusfirst()
    {
     document.getElementById('txttallycomp_name').focus();
     return false;
    
    }
    function tabvalue_age(id)
{

if(event.keyCode==13)
{
    if(document.activeElement.type=="button" || document.activeElement.type=="submit" || document.activeElement.type=="image")
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
if(event.keyCode==40 || event.keyCode==38)
{
     if(document.activeElement.id=="drpdoc" || document.activeElement.id=="" )
     {
        document.getElementById('drpdoc').focus();
     }
}

} 

function fillAgency(event)
{

 var key=event.keyCode?event.keyCode:event.which;
 
 
 
if(key==113)
{
 
    if(document.activeElement.id=="txtagency")
        {     
        
      
        
            document.getElementById('lstagency').value="";
            
            
            
            var compcode = document.getElementById('hiddencomcode').value;
            
         
            
            document.getElementById("divagency").style.display="block";
            document.getElementById('divagency').style.top=238+ "px" ;
            document.getElementById('divagency').style.left=444+ "px";
            
         
            
            var userid = document.getElementById('hiddenuserid').value;
            var dateformat = document.getElementById('hiddendateformat').value;
            var companycode=document.getElementById('hiddencomcode').value;
            
        
            
            var agency = "";
            // var unit = document.getElementById('hdnunitcode').value;
              extra1 = document.getElementById('txtagency').value;
            
              
            document.getElementById('lstagency').focus();
            xmlreport.fill_agency(companycode,userid,extra1, bindpub_callback)
      }
 }
 else if(key==8 || key==46)
 {
 document.getElementById('txtagency').value="";
 document.getElementById('txtagencycode').value="";
 document.getElementById('txtagencysubcode').value="";
 //$('txteditionname').value="";
 return true;
 }
 
 else if(event.ctrlKey==true && key==88)
 {
  document.getElementById('txtagency').value="";
 document.getElementById('txtagencycode').value="";
 document.getElementById('txtagencysubcode').value="";
// $('txtpublcode').focus();
 return true;
 }
}

function onclickagency(event)
{

 var key=event.keyCode?event.keyCode:event.which;
    if(key==13 || event.type=="click")
    {
     if(document.activeElement.id=="lstagency")
        {
       if(document.getElementById('lstagency').value=="0")
        {
        alert("Please select the Agency");
        return false;
        }
        document.getElementById("divagency").style.display="none";
        var page=document.getElementById('lstagency').value;
       
                for(var k=0;k <= document.getElementById("lstagency").length-1;k++)
                {
                    if(document.getElementById('lstagency').options[k].value==page)
                    {
                    
                    var nameabc;
                    if(browser!="Microsoft Internet Explorer")
                    {
                        nameabc=document.getElementById('lstagency').options[k].innerHTML;
                    }
                    else
                    {
                        nameabc=document.getElementById('lstagency').options[k].innerText;
                    }
                    
                    var splitpub = page;
                    var str = splitpub.split("-");
                    abc=str[1];
                    abc1=str[0];
                    var abc2 = str;
                    document.getElementById('txtagency').value=nameabc;
                    document.getElementById('txtagencycode').value = abc;
                    document.getElementById('txtagencysubcode').value = abc1;
                    document.getElementById('txtagency').focus();
                    break;           
                    }
                }
              }
     } 
     
     else if(key==27)
     {
     document.getElementById("divagency").style.display="none";
     document.getElementById('txtagency').focus();
     }
}

function bindpub_callback(res)
{
    ds=res.value;
    if(ds!= null && typeof(ds) == "object" && ds.Tables[0].Rows.length > 0) 
    {
        var pkgitem = document.getElementById("lstagency");
        pkgitem.options.length = 0; 
        pkgitem.options[0]=new Option("-Select Agency-","0");
        pkgitem.options.length = 1; 
        for (var i = 0  ;  i < ds.Tables[0].Rows.length;  ++i)
        {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].Agency_Name,ds.Tables[0].Rows[i].Agency_Code+ "-" +ds.Tables[0].Rows[i].SUB_Agency_Code);
            pkgitem.options.length;
        }
        }
        document.getElementById("lstagency").value="0";
        document.getElementById("txtagency").value="";
        return false;
}
function formexit()
{
if (confirm("Do you want to skip this page"))
{
window.close();
}
return false;
}


var formuy=null;
function winpopup()
{
var alrt;
    alrt=document.getElementById('LblFromDate').innerText;
   
    if(alrt.indexOf('*')>=0)
    {
        if(document.getElementById('TxtFromDate').value=="" || document.getElementById('TxtFromDate').value=="0")
        {
            //alrt.Replace("*","");
            var abc=alrt.replace("*","");
            alert('Please Enter '+ abc);
            document.getElementById('TxtFromDate').focus();
            return false;
        }
    }
   var alrt;
    alrt=document.getElementById('LblToDate').innerText;
   
    if(alrt.indexOf('*')>=0)
    {
        if(document.getElementById('TxtToDate').value=="" || document.getElementById('TxtToDate').value=="0")
        {
            //alrt.Replace("*","");
            var abc=alrt.replace("*","");
            alert('Please Enter '+ abc);
            document.getElementById('TxtToDate').focus();
            return false;
        }
    }

 

    
     if(document.getElementById('TxtFromDate').value=="")
    {
        alert("Please Enter The From  Date");
        document.getElementById('TxtFromDate').focus();
        return false;
    }
   
    if(document.getElementById('TxtToDate').value=="")
    {
        alert("Please Enter The To  Date");
        document.getElementById('TxtToDate').focus();
        return false;
    } 
    
//     if(document.getElementById('drpdoc').value=="0")
//    {
//     alert("Please select doc type");
//     document.getElementById('drpdoc').focus();
//     return false;
//    }
    
//    if(document.getElementById('txttallycomp_name').value=="")
//    {
//     alert("Please Enter Tally Company Name");
//     document.getElementById('txttallycomp_name').focus();
//     return false;
//    }
    
//     if(document.getElementById('txtvouchertyp').value=="")
//    {
//     alert("Please Enter Voucher Type Name");
//     document.getElementById('txtvouchertyp').focus();
//     return false;
//    }
    
    //   if(document.getElementById('txtachead').value=="")
   // {
   //  alert("Please Enter Other A/C Head");
   //  document.getElementById('txtachead').focus();
   //  return false;
   // }
    
//    if(document.getElementById('txtcredithead').value=="")
//                    {
//                     alert("Please Enter Other Head");
//                     document.getElementById('txtcredithead').focus();
//                     return false;
//                    }
                    
                     if(document.getElementById('dpd_voucher_type').value=="2" || document.getElementById('dpd_voucher_type').value=="4")
                    {
                     if(document.getElementById('txtdebithead').value=="")
                    {
                     alert("Please Enter Agency Head");
                     document.getElementById('txtdebithead').focus();
                     return false;
                     }
                    }
    var res=xmlreport.chk_dr_cr($('dpdcomp_name').value,$('drpdoc').value,$('hiddendateformat').value,"","")
    var ds=res.value
    if(ds!=null)
    {
        if(ds.Tables[0].Rows.length>0)
        {
            if(res.value.Tables[0].Rows[0]["Dsign"].toString().indexOf('-')>=0)
            {
            // document.getElementById('hdnmendetory').value="Debit"
                    if(document.getElementById('txtdebithead').value=="" &&  document.getElementById('dpd_voucher_type').value!="1")
                    {
                     alert("Please Enter Agency Head");
                     document.getElementById('txtdebithead').focus();
                     return false;
                    }
            }
           /* else
             {
             document.getElementById('hdnmendetory').value="Credit"
                    if(document.getElementById('txtcredithead').value=="")
                    {
                     alert("Please Enter Credit Head");
                     document.getElementById('txtcredithead').focus();
                     return false;
                    }
            }*/
            
              if(document.getElementById('drpdoc').value=="BIL" || document.getElementById('drpdoc').value=="UCN")
{
if(document.getElementById('txtcommhead').value=="")
{
alert("Plesae Enter Commission Head")
return false;
}
}
}

}
     
    
    //document.getElementById('hiddenpaymodecode').value = document.getElementById('DrpPayMode').value;
    
     var compcode = "";
        if (document.getElementById('dpdcomp_name').value  == "0")
            compcode = document.getElementById('hiddencompcode').value ;
        else
            compcode = document.getElementById('dpdcomp_name').value ;
        var print_center =document.getElementById('drpprintcenter').value ;
       // var branch_code =document.getElementById('hiddenunitcode').value ; 
        var branch_code = document.getElementById('DrpUnit').value
        var doc_type =document.getElementById('drpdoc').value ;  
       // var pay_mode =document.getElementById('hiddenpaymodecode').value ;   
       var pay_mode =document.getElementById('DrpPayMode').value ; 

        var from_date =document.getElementById('TxtFromDate').value ;
        var to_date =document.getElementById('TxtToDate').value ; 
        var agency =document.getElementById('txtagencycode').value ;  
        var dateformat =document.getElementById('hiddendateformat').value ; 
        var tallycomp_name =document.getElementById('txttallycomp_name').value ; 
        var voucher_name = document.getElementById('txtvouchertyp').value ;  

        var agency_head =document.getElementById('txtdebithead').value ; 
        var other_head =document.getElementById('txtcredithead').value ;   
        var agname_code =document.getElementById('dpd_agname_or_code').value ;  
        var branch_basedon =document.getElementById('dpd_branch_basedon').value ;  
        var freq_typ =document.getElementById('dpd_voucher_type').value ; 
        var tally_typ =document.getElementById('dpd_tally_typ').value ; 
        var other_head2=document.getElementById('txtcommhead').value;
        var doctyp_name=document.getElementById('drpdoc').options[document.getElementById('drpdoc').selectedIndex].text
    window.open("xmlreportview.aspx?compcode="+compcode+"&print_center="+print_center+"&branch_code="+branch_code+"&doc_type="+doc_type+"&pay_mode="+pay_mode+"&from_date="+from_date+"&to_date="+to_date+"&agency="+agency+"&dateformat="+dateformat+"&tallycomp_name="+tallycomp_name+"&voucher_name="+voucher_name+"&agency_head="+agency_head+"&other_head="+other_head+"&other_head2="+other_head2+"&agname_code="+agname_code+"&branch_basedon="+branch_basedon+"&freq_typ="+freq_typ+"&tally_typ="+tally_typ+"&doctyp_name="+doctyp_name)
    return false;
}



function unit_save()
{
document.getElementById('hiddenunitcode').value = document.getElementById('DrpUnit').value;
   
}

function pay_save()
{
document.getElementById('hiddenpaymodecode').value = document.getElementById('DrpPayMode').value;

}

function bind_paymode()
{
if(document.getElementById('drpdoc').value=="BIL" || document.getElementById('drpdoc').value=="UCN" || document.getElementById('drpdoc').value=="BILL")
{
document.getElementById('txtcommhead').disabled=false
}
else
{
document.getElementById('txtcommhead').disabled=true
}
document.getElementById('txtcommhead').value=""
{
if(document.getElementById('drpdoc').value=="0")
call_nullpaymode();
else
xmlreport.bindpaymode1(document.getElementById('hiddencompcode').value,document.getElementById('drpdoc').value,callback_paymode)
}
function call_nullpaymode()
{
var paymode= $("DrpPayMode");
  paymode.options.length=1;
  var docbind=$('drpdoc').value;
  paymode.options[0] = new Option("Select Paymod","0");
  return false;
}
function callback_paymode(res)
{
    ds=res.value;
    if(ds!= null && typeof(ds) == "object" && ds.Tables[0].Rows.length > 0) 
    {
        var pkgitem = document.getElementById("DrpPayMode");
        pkgitem.options.length = 0; 
        pkgitem.options[0]=new Option("Select Paymod","0");
        pkgitem.options.length = 1; 
        for (var i = 0  ;  i < ds.Tables[0].Rows.length;  ++i)
        {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].Payment_Mode_Name,ds.Tables[0].Rows[i].Pay_Mode_Code);
            pkgitem.options.length;
        }
        }
       
        return false;
}


function branch_change()
{
xmlreport.bindUnitCode(document.getElementById('hiddencompcode').value,document.getElementById('drpprintcenter').value,callback_branch)
}

function callback_branch(res)
{
    ds=res.value;
    if(ds!= null && typeof(ds) == "object" && ds.Tables[0].Rows.length > 0) 
    {
        var pkgitem = document.getElementById("DrpUnit");
        pkgitem.options.length = 0; 
        pkgitem.options[0]=new Option("Select Branch","0");
        pkgitem.options.length = 1; 
        for (var i = 0  ;  i < ds.Tables[0].Rows.length;  ++i)
        {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].Branch_Name,ds.Tables[0].Rows[i].Branch_Code);
            pkgitem.options.length;
        }
        }
       
        return false;
}

}