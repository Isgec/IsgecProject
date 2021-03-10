var browser = navigator.appName;
var jq = jQuery.noConflict();
var next = 0;
var ds = "";
var exec_data = "";
var total_records = "0";
var record_show = 5;
var record_show1 = 1;
var ClientDocCode;
var RetainerDocCode;
var ExecutiveDocCode;
var str = 0;
var tb = 0;
var count1;
var count2;
var count3;
var count4;
var count5;
var flag = "";
var modifyflag = "";
//var count5;
var count6;
var count7;
var count8;
var rowtotal = 0;
var rowbalance = 0;
var comp_code = "", unit = "", doctype = "", rcptno = "", rcptdate = "", chqdt = "", chqno = "", agcode = "", agmaincode = "", agsubcode = "", agname = "", totalamt = "", tag = "", untag = "", paymentmode = "", manrcptno = "", rcvdfrom = "";
var execount = 0;





function getchval1(id) {
    var pono = document.getElementById("searchvalue1").value;
    var revision_no = "";
    var pextra1 = "";
    var pextra2 = "";
    var pextra3 = "";
    var pextra4 = "";
    var pextra5 = "";

    var connstring = document.getElementById("hdnconnectionstring").value;
    var res_vch33 = PODetailList.bind_polist(pono, revision_no, pextra1, pextra2, pextra3, pextra4, pextra5, connstring);
    return false;
}
