var jq = jQuery.noConflict();
var browser = navigator.appName;
var count = 0;
var count1 = 0;
var count2 = 0;
var count3 = 0;
var count4 = 0;
var fixval = 1;
var rownum = 1;
var gridlen = 0;
var sum = 0;
var flag = "";
var dsmain = "";
var dsmain1 = "";
var dsmain2 = "";
var dsmain3 = "";
var dsmain4 = "";
var dsmain5 = "";
var dsmain6 = "";
var dsmain7 = "";

function positionInfo(object) {

  var p_elm = object;

  this.getElementLeft = getElementLeft;
  function getElementLeft() {
    var x = 0;
    var elm;
    if(typeof(p_elm) == "object"){
      elm = p_elm;
    } else {
      elm = document.getElementById(p_elm);
    }
    while (elm != null) {
      x+= elm.offsetLeft;
      elm = elm.offsetParent;
    }
    return parseInt(x);
  }

  this.getElementWidth = getElementWidth;
  function getElementWidth(){
    var elm;
    if(typeof(p_elm) == "object"){
      elm = p_elm;
    } else {
      elm = document.getElementById(p_elm);
    }
    return parseInt(elm.offsetWidth);
  }

  this.getElementRight = getElementRight;
  function getElementRight(){
    return getElementLeft(p_elm) + getElementWidth(p_elm);
  }

  this.getElementTop = getElementTop;
  function getElementTop() {
    var y = 0;
    var elm;
    if(typeof(p_elm) == "object"){
      elm = p_elm;
    } else {
      elm = document.getElementById(p_elm);
    }
    while (elm != null) {
      y+= elm.offsetTop;
      elm = elm.offsetParent;
    }
    return parseInt(y);
  }

  this.getElementHeight = getElementHeight;
  function getElementHeight(){
    var elm;
    if(typeof(p_elm) == "object"){
      elm = p_elm;
    } else {
      elm = document.getElementById(p_elm);
    }
    return parseInt(elm.offsetHeight);
  }

  this.getElementBottom = getElementBottom;
  function getElementBottom(){
    return getElementTop(p_elm) + getElementHeight(p_elm);
  }
}

function CalendarControl() {

  var calendarId = 'CalendarControl';
  var currentYear = 0;
  var currentMonth = 0;
  var currentDay = 0;

  var selectedYear = 0;
  var selectedMonth = 0;
  var selectedDay = 0;

  var months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
  var dateField = null;

  function getProperty(p_property){
    var p_elm = calendarId;
    var elm = null;

    if(typeof(p_elm) == "object"){
      elm = p_elm;
    } else {
      elm = document.getElementById(p_elm);
    }
    if (elm != null){
      if(elm.style){
        elm = elm.style;
        if(elm[p_property]){
          return elm[p_property];
        } else {
          return null;
        }
      } else {
        return null;
      }
    }
  }

  function setElementProperty(p_property, p_value, p_elmId){
    var p_elm = p_elmId;
    var elm = null;

    if(typeof(p_elm) == "object"){
      elm = p_elm;
    } else {
      elm = document.getElementById(p_elm);
    }
    if((elm != null) && (elm.style != null)){
      elm = elm.style;
      elm[ p_property ] = p_value;
    }
  }

  function setProperty(p_property, p_value) {
    setElementProperty(p_property, p_value, calendarId);
  }

  function getDaysInMonth(year, month) {
    return [31,((!(year % 4 ) && ( (year % 100 ) || !( year % 400 ) ))?29:28),31,30,31,30,31,31,30,31,30,31][month-1];
  }

  function getDayOfWeek(year, month, day) {
    var date = new Date(year,month-1,day)
    return date.getDay();
  }

  this.setDate = setDate;
  function setDate(year, month, day) {
    if (dateField) {
      if (month < 10) {month = "0" + month;}
      if (day < 10) {day = "0" + day;}

      var dateString = month+"-"+day+"-"+year;
      dateField.value = dateString;
     // hide();
    }
    return;
  }

  this.changeMonth = changeMonth;
  function changeMonth(change) {
    currentMonth += change;
    currentDay = 0;
    if(currentMonth > 12) {
      currentMonth = 1;
      currentYear++;
    } else if(currentMonth < 1) {
      currentMonth = 12;
      currentYear--;
    }

    calendar = document.getElementById(calendarId);
    calendar.innerHTML = calendarDrawTable();
  }

  this.changeYear = changeYear;
  function changeYear(change) {
    currentYear += change;
    currentDay = 0;
    calendar = document.getElementById(calendarId);
    calendar.innerHTML = calendarDrawTable();
  }

  function getCurrentYear() {
    var year = new Date().getYear();
    if(year < 1900) year += 1900;
    return year;
  }

  function getCurrentMonth() {
    return new Date().getMonth() + 1;
  } 

  function getCurrentDay() {
    return new Date().getDate();
  }

  function calendarDrawTable() {

      var vcurrentMonth = "";
      var vdayOfMonth = "";

      var dayOfMonth = 1;
      var validDay = 0;
      var startDayOfWeek = getDayOfWeek(currentYear, currentMonth, dayOfMonth);
      var daysInMonth = getDaysInMonth(currentYear, currentMonth);
      var vpfdate = "01/" + getdate(currentMonth) + "/" + currentYear;
      var vptdate = daysInMonth+"/"+ getdate(currentMonth) + "/" + currentYear;


      var pcompcode = jq("#hdncompcode").val();
      var punitcode = jq("#hdnunitcode").val();
      var pbrancode = "";
      var ppubltype = "";
      var ppubl = jq("#hdnpublication").val();
      var pmainedtn = jq("#hdnsubedition").val();
      var pedtn = "";
      var pagcd = jq("#hdnciragcd").val();
      var pdpcd = jq("#hdncirdpcd").val();
      var pexeccode = "";
      var psuptype = "";
      var pfrom_supdate = vpfdate;
      var ptill_supdate = vptdate;
      var pdateformat = jq("#dateformatnew").val();
      var puserid = jq("#hdnuserid").val();
      var preportfor = jq("#drptype").val();
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
      var mysuplayvalue = new Array();
      var mysuplaydatevalue = new Array();
      var dayv = "1";
      for (var chgrownum = 0; chgrownum < daysInMonth; chgrownum++) {
          dayv = getdate(dayv);
          mysuplayvalue[dayv] = "0";
          mysuplaydatevalue[dayv] = "0";
          dayv = parseInt(dayv) + parseInt(1);
      }
      if (preportfor == null) {
          preportfor = "S";
      }

      var res = Suuply_history1.BindCirSupplay(pcompcode, punitcode, pbrancode, ppubltype, ppubl, pmainedtn, pedtn, pagcd, pdpcd, pexeccode, psuptype, pfrom_supdate, ptill_supdate, pdateformat, puserid, preportfor, extra1, extra2, extra3, extra4, extra5, extra6, extra7, extra8, extra9, extra10);
      if (res.error != null) {
          alert(res.error.description);
          return false;
      }
      else {
          dsmain = res.value;
          if (dsmain.Tables[0].Rows.length == 0) {
             // return false;
          }
          else {
              for (var chgrownum = 0; chgrownum < dsmain.Tables[0].Rows.length; chgrownum++) {
                  var dd = dsmain.Tables[0].Rows[chgrownum].SUPDATE.split("/")
                  mysuplayvalue[dd[0]] = dsmain.Tables[0].Rows[chgrownum].SUP_COPY;
                  mysuplaydatevalue[dd[0]] = dsmain.Tables[0].Rows[chgrownum].SUPDATE;
                  
              }
              //  vvalue = dsmain.Tables[0].Rows[0].SUP_COPY;

              // return false;
          }

      }
    var css_class = null; //CSS class for each day
   
    var table = "<table cellspacing='0' cellpadding='0' border='0' class='table '>";
    table = table + "<tr class='header'>";
    table = table + "  <td class='previous'><a href='javascript:changeCalendarControlMonth(-1);'>&lt;</a></td>";
    table = table + "  <td class='previous'><a href='javascript:changeCalendarControlYear(-1);'>&laquo;</a></td>";
    table = table + "  <td colspan='3' class='title'>" + months[currentMonth - 1] + " " + currentYear + "</td>";
    table = table + "  <td class='next'><a href='javascript:changeCalendarControlYear(1);'>&raquo;</a> </td>";
    table = table + "  <td  class='next'><a href='javascript:changeCalendarControlMonth(1);'>&gt;</a></td>";
    //table = table + "  <td colspan='2' class='previous'><a href='javascript:changeCalendarControlMonth(-1);'>&lt;</a> <a href='javascript:changeCalendarControlYear(-1);'>&laquo;</a></td>";
    //table = table + "  <td colspan='3' class='title'>" + months[currentMonth-1] + " " + currentYear + "</td>";
    //table = table + "  <td colspan='2' class='next'><a href='javascript:changeCalendarControlYear(1);'>&raquo;</a> <a href='javascript:changeCalendarControlMonth(1);'>&gt;</a></td>";
    table = table + "</tr>";
      //table = table + "<tr><th width=10%>S</th><th width=10%>M</th><th width=10%>T</th><th width=10%>W</th><th width=10%>T</th><th width=10%>F</th><th width=10%>S</th></tr>";
    table = table + "<tr><td>S</td><td>M</td><td>T</td><td>W</td><td>T</td><td>F</td><td>S</td></tr>";
    var blkchk = 0;
    for(var week=0; week < 6; week++) {
      table = table + "<tr>";
      for(var dayOfWeek=0; dayOfWeek < 7; dayOfWeek++) {
        if(week == 0 && startDayOfWeek == dayOfWeek) {
          validDay = 1;
        } else if (validDay == 1 && dayOfMonth > daysInMonth) {
          validDay = 0;
        }

        if(validDay) {
          if (dayOfMonth == selectedDay && currentYear == selectedYear && currentMonth == selectedMonth) {
            css_class = 'current';
          } else if (dayOfWeek == 0 || dayOfWeek == 6) {
            css_class = 'weekend';
          } else {
            css_class = 'weekday';
          }
          
          var vvalue = "0";
          vdayOfMonth = getdate(dayOfMonth);
           
            vcurrentMonth = getdate(currentMonth);

            pfrom_supdate = vdayOfMonth + "/" + vcurrentMonth + "/" + currentYear;
            ptill_supdate = vdayOfMonth + "/" + vcurrentMonth + "/" + currentYear;
            var dayofmonthv = getdate(dayOfMonth)
            //            vvalue = mysuplayvalue[dayOfMonth - 1];
            vvalue = mysuplayvalue[dayofmonthv];

            //table = table + "<td width=10%><a width='100% !important' class='" + css_class + "' href=\"javascript:setCalendarControlDate(" + currentYear + "," + currentMonth + "," + dayOfMonth + ")\">" + dayOfMonth + " <font color=blue><br> " + vvalue + "</font></a></td>";
            //table = table + "<td><a class='" + css_class + "' href=\"javascript:setCalendarControlDate(" + currentYear + "," + currentMonth + "," + dayOfMonth + ")\">" + dayOfMonth + " <font color=red><br> " + vvalue + "</font></a></td>";
            table = table + "<td><a class='" + css_class + "' href=\"javascript:setCalendarControlDate(" + currentYear + "," + currentMonth + "," + dayOfMonth + ")\">" + dayOfMonth + " <span class='supplay'><br> " + vvalue + "</span></a></td>";
          dayOfMonth++;
        } else {
            if (dayOfWeek == "0") {
                if (week > 0) {
                    blkchk = 1;
                }
            }
            if (blkchk == "0") {
                table = table + "<td class='empty'>&nbsp;</td>";
            }
        }
      }
      table = table + "</tr>";
    }

    //table = table + "<tr class='header'><th colspan='7' style='padding: 3px;text-align: center;'><a href='javascript:hideCalendarControl();'>Close</a></td></tr>";
    table = table + "</table>";

    return table;
  }

  this.show = show;
  function show(field) {
  
    // If the calendar is visible and associated with
    // this field do not do anything.
    if (dateField == field) {
      return;
    } else {
      dateField = field;
    }

    if(dateField) {
      try {
        var dateString = new String(dateField.value);
        var dateParts = dateString.split("-");
        
        selectedMonth = parseInt(dateParts[0],10);
        selectedDay = parseInt(dateParts[1],10);
        selectedYear = parseInt(dateParts[2],10);
      } catch(e) {}
    }

    if (!(selectedYear && selectedMonth && selectedDay)) {
      selectedMonth = getCurrentMonth();
      selectedDay = getCurrentDay();
      selectedYear = getCurrentYear();
    }

    currentMonth = selectedMonth;
    currentDay = selectedDay;
    currentYear = selectedYear;

    if(document.getElementById){

      calendar = document.getElementById(calendarId);
      calendar.innerHTML = calendarDrawTable(currentYear, currentMonth);

      setElementProperty('display', 'block', 'CalendarControlIFrame');
      setProperty('display', 'block');

      var fieldPos = new positionInfo(dateField);
      var calendarPos = new positionInfo(calendarId);

      //var x = fieldPos.getElementLeft();
      var y = fieldPos.getElementBottom();
      //x=x+155;
      //y=y-22;
      //setProperty('left', x + "px");
      setProperty('top', y + "px");
    //  setElementProperty('left', x + "px", 'CalendarControlIFrame');
      //setElementProperty('top', y + "px", 'CalendarControlIFrame');
      //setElementProperty('width', calendarPos.getElementWidth() + "px", 'CalendarControlIFrame');
      //setElementProperty('height', calendarPos.getElementHeight() + "px", 'CalendarControlIFrame');
    }
  }

  this.hide = hide;
  function hide() {
    if(dateField) {
      setProperty('display', 'none');
      setElementProperty('display', 'none', 'CalendarControlIFrame');
      dateField = null;
    }
  }
}

var calendarControl = new CalendarControl();

function showCalendarControl(textField) {
    
  calendarControl.show(textField);
}

function hideCalendarControl() {
  calendarControl.hide();
}

function setCalendarControlDate(year, month, day) {
    calendarControl.setDate(year, month, day);
    var vdaet = getdate(day) + "/" + getdate(month) + "/" + year
    //    if (jq("#hdnciragcd").val() == "") {
    if (jq("#hdnlogintype").val() != "A") {
        Generatereport(vdaet);
    }
}

function changeCalendarControlYear(change) {
  calendarControl.changeYear(change);
}

function changeCalendarControlMonth(change) {
  calendarControl.changeMonth(change);
}

//document.write("<iframe id='CalendarControlIFrame' src='javascript:false;' frameBorder='0' scrolling='no'></iframe>");
//document.write("<div id='CalendarControl'></div>");




function Generatereport(vdate) {

  
    var vpunitcode = jq("#hdnunitcode").val();
    var vpbrancode="";
    var vppubltype="";
    var vppubl = jq("#hdnpublication").val();
    var vpmainedtn = jq("#hdnsubedition").val();
    var vpedtn            ="";
    var vpagcd = jq("#hdnciragcd").val();
    var vpdpcd = jq("#hdncirdpcd").val();
    var vpfrom_supdate = vdate
    var vptill_supdate = vdate
    var vpexeccode            =""; 
    var vpreptype = jq("#drptype").val();
    var vfiletype = "AgencySupplay";
    var vsup_extra1 = "";
    var vsup_extra2 = jq("#hdnpaymode").val();
    var vsup_extra3 = "";
    var vsup_extra4 = "";
    var vsup_extra5 = "";
    var vsup_extra6 = "";
    var vsup_extra7 = "";
    var vsup_extra8 = "";
    var vsup_extra9 = "";
    var vsup_extra10 = "";
    var vsup_extra11 = jq("#txtpublication").val();
    var vsup_extra12 = jq("#txtsubedition").val();
    if (jq("#drptype").val() == "S") {
        if (jq("#hdnlogintype").val() == "E") {
            vsup_extra1 = "A";
        }
        else {
            vsup_extra1 = "E";
        }

    }
    else if (jq("#drptype").val() == "U") {
        if (jq("#hdnlogintype").val() == "E") {
            vsup_extra1 = "A";
        }
        else {
            vsup_extra1 = "E";
        }
    }
    else if (jq("#drptype").val() == "N") {
        if (jq("#hdnlogintype").val() == "E") {
            vsup_extra1 = "A";
        }
        else {
            vsup_extra1 = "E";
        }
    }
    else if (jq("#drptype").val() == "C") {
        if (jq("#hdnlogintype").val() == "E") {
            vsup_extra1 = "A";
        }
        else {
            vsup_extra1 = "E";
        }
    }
    else if (jq("#drptype").val() == "I") {
        if (jq("#hdnlogintype").val() == "E") {
            vsup_extra1 = "A";
        }
        else {
            vsup_extra1 = "E";
        }
    }
    else {
        vsup_extra1 = "A";
    }
    if (vpreptype == null) {
        vpreptype = "S";
    }

    PageMethods.seesionmanage(vpunitcode, vpbrancode, vppubltype, vppubl, vpmainedtn, vpedtn, vpagcd, vpdpcd, vpfrom_supdate, vptill_supdate, vpexeccode, vpreptype, vfiletype, vsup_extra1, vsup_extra2, vsup_extra3, vsup_extra4, vsup_extra5, vsup_extra6, vsup_extra7, vsup_extra8, vsup_extra9, vsup_extra10, vsup_extra11, vsup_extra12, UpdateTimeSuccess);
    //var value1 = vvalue;
    //window.open("CirAgencySupplay.aspx");

    return false;
}

function UpdateTimeSuccess(updateResult) {
    var value1 = updateResult;
    window.open("CirAgencySupplay.aspx");
}
function getdate(dayOfMonth) {
    var vdayOfMonth = "01";
    if (dayOfMonth == '1') {
        vdayOfMonth = "01";
    }
    else if (dayOfMonth == '2') {
        vdayOfMonth = "02";
    }
    else if (dayOfMonth == '3') {
        vdayOfMonth = "03";
    }
    else if (dayOfMonth == '4') {
        vdayOfMonth = "04";
    }
    else if (dayOfMonth == '5') {
        vdayOfMonth = "05";
    }
    else if (dayOfMonth == '6') {
        vdayOfMonth = "06";
    }
    else if (dayOfMonth == '7') {
        vdayOfMonth = "07";
    }
    else if (dayOfMonth == '8') {
        vdayOfMonth = "08";
    }
    else if (dayOfMonth == '9') {
        vdayOfMonth = "09";
    }
    else {
        vdayOfMonth = dayOfMonth
    }
    return vdayOfMonth;
}

function changeCalendarControlMonthpub(change) {
    calendarControl.changeMonth(change);
}