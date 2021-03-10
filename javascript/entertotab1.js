// JScript File pankaj

var browser=navigator.appName;
function tabvalue(event) {

    var key = event.keyCode ? event.keyCode : event.which;

    if ((key == 8 && document.activeElement.id == "txtagency") || (event.ctrlKey == true && key == 88 && document.activeElement.id == "txtagency") || (key == 46 && document.activeElement.id == "txtagency")) {
        if (key != 113) {
            //document.getElementById('lstagency').value="";
            //document.getElementById('txtagency').value="";
            document.getElementById('txtagency').focus();
        }
    }
    if ((key == 8 && document.activeElement.id == "txtseg") || (event.ctrlKey == true && key == 88 && document.activeElement.id == "txtseg") || (key == 46 && document.activeElement.id == "txtseg")) {
        if (key != 113) {
            document.getElementById('txtseg').value = "";
            document.getElementById('hdnseg').value = "";
        }
    }
    //alert ('gaurav');
    if (key == 113) {
        if (document.activeElement.id == "txtagency") {

            //            document.getElementById("div1").style.display="block";
            //                
            //            if(browser!="Microsoft Internet Explorer")
            //            {
            //                document.getElementById('div1').style.top= '320'+ "px";
            //                document.getElementById('div1').style.left= '126' + "px";
            //            }
            //            else
            //            {
            //                document.getElementById('div1').style.top='320';
            //                document.getElementById('div1').style.left='126';
            //            }
            //            var agencyname=(document.getElementById('txtagency').value).toUpperCase();
            var activeid = document.activeElement.id;
            var listboxid = "lstagency";
            var objchannel = document.getElementById(listboxid);
            var divid = "div1";

            aTag = eval(document.getElementById(activeid))
            var btag;
            var leftpos = 0;
            var toppos = 0;
            do {
                aTag = eval(aTag.offsetParent);
                leftpos += aTag.offsetLeft;
                toppos += aTag.offsetTop;
                btag = eval(aTag)
            } while (aTag.tagName != "BODY" && aTag.tagName != "HTML");

            //document.getElementById(activeid).style.backgroundColor="#FFFF80";
            document.getElementById("div1").style.display = "block";




            document.getElementById("div1").style.top = document.getElementById(activeid).offsetHeight + toppos + "px";
            document.getElementById("div1").style.left = document.getElementById(activeid).offsetLeft + leftpos + "px";
            var agencyname = (document.getElementById('txtagency').value).toUpperCase();

            if (document.getElementById('inactiveid').checked == true) {
                ReceiptEntry.bindagencynameactive(document.getElementById('hiddencompcode').value, document.getElementById('hiddenuserid').value, agencyname,document.getElementById("drpunit").value, bindagencyname_callback);
            }
            else {
                ReceiptEntry.bindagencyname(document.getElementById('hiddencompcode').value, document.getElementById('drpunit').value, agencyname,document.getElementById("drpunit").value, bindagencyname_callback);
            }


        }

        if (document.activeElement.id == "txtseg") {
            //alert(document.activeElement.id);
            document.getElementById("divseg").style.display = "block";

            var activeid = document.activeElement.id;
            var listboxid = "lstseg";
            var objchannel = document.getElementById(listboxid);
            var divid = "divseg";

            aTag = eval(document.getElementById(activeid))
            var btag;
            var leftpos = 0;
            var toppos = 0;
            do {
                aTag = eval(aTag.offsetParent);
                leftpos += aTag.offsetLeft;
                toppos += aTag.offsetTop;
                btag = eval(aTag)
            } while (aTag.tagName != "BODY" && aTag.tagName != "HTML");

            //document.getElementById(activeid).style.backgroundColor="#FFFF80";
            document.getElementById("divseg").style.display = "block";




            document.getElementById("divseg").style.top = document.getElementById(activeid).offsetHeight + toppos + "px";
            document.getElementById("divseg").style.left = document.getElementById(activeid).offsetLeft + leftpos + "px";
            var extra1 = document.getElementById("txtseg").value.toUpperCase();
            var extra2 = "";
            var drpcd = document.getElementById("hidden_debit_code").value;
            // alert(drpcd);

            var crdcd = document.getElementById("hidden_credit_code").value;
            //  alert(crdcd);
            ReceiptEntry.bindseg(document.getElementById('hiddencompcode').value, drpcd, crdcd, extra1, extra2, "", "", "", BINDSEG_COLLBACK);

        }
        if (document.activeElement.id == "protxtreceiptno") {
            var doctype = document.getElementById('drptype').value;
            if (doctype == "" || doctype == "0") {
                alert("Please Select Doctype");
                document.getElementById('drptype').focus();

                return false;
            }
            var pay_reason = document.getElementById('drppaymode').value;

            if (pay_reason == "" || pay_reason == "0") {
                alert("Please Select Pay Mode");
                document.getElementById('drppaymode').focus();

                return false;
            }
            document.getElementById("div2").style.display = "block";
            //        
            //            if(browser!="Microsoft Internet Explorer")
            //            {
            //                document.getElementById('div2').style.top= '150'+ "px";
            //                document.getElementById('div2').style.left= '830' + "px";
            //            }
            //            else
            //            {
            //                document.getElementById('div2').style.top='180';
            //                document.getElementById('div2').style.left='650';
            //            }
            var activeid = document.activeElement.id;
            var listboxid = "lstprorec";
            var objchannel = document.getElementById(listboxid);
            var divid = "div2";

            aTag = eval(document.getElementById(activeid))
            var btag;
            var leftpos = 0;
            var toppos = 0;
            do {
                aTag = eval(aTag.offsetParent);
                leftpos += aTag.offsetLeft;
                toppos += aTag.offsetTop;
                btag = eval(aTag)
            } while (aTag.tagName != "BODY" && aTag.tagName != "HTML");

            //document.getElementById(activeid).style.backgroundColor="#FFFF80";
            document.getElementById("div2").style.display = "block";




            document.getElementById("div2").style.top = document.getElementById(activeid).offsetHeight + toppos + "px";
            document.getElementById("div2").style.left = document.getElementById(activeid).offsetLeft + leftpos + "px";

            var UNIT = document.getElementById('drpunit').value;
            var prorec = document.getElementById('protxtreceiptno').value;
            ReceiptEntry.bindprovrec(document.getElementById('hiddencompcode').value, doctype, pay_reason, UNIT, prorec, bindprov_callback);

        }
    }

    else if (key == 27) {
        if (document.getElementById("div1").style.display == "block") {
            document.getElementById("div1").style.display = "none"
            document.getElementById('txtagency').focus();
        }
        if (document.getElementById("div2").style.display == "block") {
            document.getElementById("div2").style.display = "none"
            document.getElementById('protxtreceiptno').focus();
        }

        if (document.getElementById("divseg").style.display == "block") {
            document.getElementById("divseg").style.display = "none"
            document.getElementById('txtseg').focus();
        }
    }
    else if (key == 13 || key == 9 && event.shiftKey == false) {
        if (document.activeElement.id.indexOf("aglist") >= 0) {
            document.getElementById(activeid).value = document.getElementById(document.activeElement.id).value;
            document.getElementById(activeid).style.backgroundColor = "#FFFFFF";
            document.getElementById('agdiv').style.display = "none";
        }

        else if (document.activeElement.id == "lstagency") {
            if (document.getElementById('lstagency').value == "0") {
                alert("Please select the agency sub code");
                return false;
            }
            document.getElementById("div1").style.display = "none";
            var datetime = new Date();
            var page = document.getElementById('lstagency').value;
            document.getElementById('hiddenagency').value = page;

            agencycodeglo = page;

            var id = "";
            if (browser != "Microsoft Internet Explorer") {
                var httpRequest = null;;
                httpRequest = new XMLHttpRequest();
                if (httpRequest.overrideMimeType) {
                    httpRequest.overrideMimeType('text/xml');
                }

                httpRequest.onreadystatechange = function () { alertContents(httpRequest) };

                httpRequest.open("GET", "clientName.aspx?page=" + page + "&datetime=" + datetime + "&value=0", false);
                httpRequest.send('');
                //alert(httpRequest.readyState);
                if (httpRequest.readyState == 4) {
                    //alert(httpRequest.status);
                    if (httpRequest.status == 200) {
                        id = httpRequest.responseText;
                    }
                    else {
                        alert('There was a problem with the request.');
                    }
                }
            }
            else {
                var xml = new ActiveXObject("Microsoft.XMLHTTP");
                xml.Open("GET", "clientName.aspx?page=" + page + "&datetime=" + datetime + "&value=0", false);
                xml.Send();
                id = xml.responseText;
            }
            var split = id.split("+");
            var nameagen = split[0];
            var code = split[1];
            var subcode = split[2];
            var reg = split[3];
            var repname = split[4];
            document.getElementById('txtagency').value = nameagen;
            document.getElementById('txtagcode').value = code;
            document.getElementById('txtagsubcode').value = subcode;
            document.getElementById('drpreceivedrg').value = reg;
            chbankdt(document.getElementById('drppaymode').value);
            if (document.getElementById('txtchno').disabled == false) {
                document.getElementById('txtchno').focus();
                return false;
            }
            else {
                document.getElementById('txtRep').focus();
                return false;
            }

            return false;
        }
        else if (document.activeElement.id == "lstprorec") {

            if (document.getElementById('lstprorec').value == "0") {
                alert("Please select the receipt");
                return false;
            }
            document.getElementById("div2").style.display = "none";
            var datetime = new Date();
            var page = document.getElementById('lstprorec').value;
            //===================add for data=============
            var id = "";
            if (browser != "Microsoft Internet Explorer") {
                var httpRequest = null;;
                httpRequest = new XMLHttpRequest();
                if (httpRequest.overrideMimeType) {
                    httpRequest.overrideMimeType('text/xml');
                }

                httpRequest.onreadystatechange = function () { alertContents(httpRequest) };

                httpRequest.open("GET", "clientName.aspx?page=" + page + "&datetime=" + datetime + "&value=1", false);
                httpRequest.send('');
                //alert(httpRequest.readyState);
                if (httpRequest.readyState == 4) {
                    //alert(httpRequest.status);
                    if (httpRequest.status == 200) {
                        id = httpRequest.responseText;
                    }
                    else {
                        alert('There was a problem with the request.');
                    }
                }
            }
            else {
                var xml = new ActiveXObject("Microsoft.XMLHTTP");
                xml.Open("GET", "clientName.aspx?page=" + page + "&datetime=" + datetime + "&value=1", false);
                xml.Send();
                id = xml.responseText;
            }
            var split = id.split("+");
            var REASON = split[0];
            if (REASON == "AAA")
                REASON = "CH0";
            var REPCODE = split[1];
            var AGCODE = split[2];
            var REMARK = split[3];
            var CHNO = split[4];
            var CHDT1 = split[5];
            CHDT1 = CHDT1.split(' ');
            var CHDT = CHDT1[0];
            var BANK = split[13];
            var AMOUNT = split[7];
            var RECEIVED_REGION = split[8];
            var AG_MAIN_CODE = split[9];
            var AG_SUB_CODE = split[10];
            document.getElementById('protxtreceiptno').value = page;
            document.getElementById('drppaymode').value = REASON;
            cash();
            document.getElementById('txtagency').value = AGCODE;
            document.getElementById('txtagcode').value = AG_MAIN_CODE;
            document.getElementById('txtagsubcode').value = AG_SUB_CODE;
            document.getElementById('drpreceivedrg').value = RECEIVED_REGION;
            document.getElementById('drpbank').value = BANK;
            document.getElementById('txtchno').value = CHNO;
            document.getElementById('txtchdate').value = CHDT;
            document.getElementById('txtRep').value = REPCODE;
            document.getElementById('txtNarration').value = REMARK;
            document.getElementById('txtamount').value = AMOUNT;
            document.getElementById('txtadjustamt').value = '0';
            document.getElementById('txtamthand').value = AMOUNT;
            if (document.getElementById('drpbank').disabled == false) {
                //document.getElementById('drpcaba').focus();
                return false;
            }
            else {
                //document.getElementById('drpcaba').focus();
                return false;
            }

            disabllfield();
        }
        //return key;
    }
    else {
        if (document.activeElement.id == "txtagency") {
            document.getElementById('txtagcode').value = ""
            document.getElementById('txtagsubcode').value = "";
        }
    }
    //==============add for enter===============
    if (key == 13) {
        //alert("1");

        if (document.activeElement.id == "drptype") {
            if (document.getElementById("drptype").value == "0") {
                alert("Plese select Doctype");
                document.getElementById("drptype").focus();
                return false;
            }
            else {
                document.getElementById("drppaymode").focus();
                return false;
            }
        }


        if (document.activeElement.id == "drppaymode") {
            if (document.getElementById("drppaymode").value == "0") {
                alert("Please choose Payment Reason");
                document.getElementById("drppaymode").focus();
                return false;
            }
            else {
                document.getElementById("txtDate").focus();
                return false;
            }
        }

        if (document.activeElement.id == "txtDate") {
            if (document.getElementById("txtDate").value == "") {
                alert("Please fill date");
                document.getElementById("txtDate").focus();
                return false;
            }
            else {
                document.getElementById("protxtreceiptno").focus();
                return false;
            }
        }

        if (document.activeElement.id == "txtamount") {
            if (document.getElementById('txtamount').value == "") {
                alert("Please fill amount");
                document.getElementById('txtamount').focus();
                return false;
            }
            else {//txtRep
                document.getElementById('txtRep').focus();
                return false;
            }
        }

        

        if (document.activeElement.id == "txt_credit") {
            if (document.getElementById('btnSave').disabled == false) {
                document.getElementById('btnSave').focus();
            }
            return;

        }
        else if (document.activeElement.type == "button" || document.activeElement.type == "submit" || document.activeElement.type == "image") {
            if (document.activeElement.id != "chq_ok") {
                key = event.keyCode;
                return event.keyCode;
            }
        }
        else if (document.activeElement.id == "txtNarration") {
            if (document.getElementById('txt_cash').disabled == false) {
                if (document.getElementById('txt_cash').value == "") {
                    document.getElementById('txt_cash').focus();
                    return false;
                }
            }

        }

        if (document.activeElement.id == "txt_cash") {
            if (document.getElementById('txt_credit').disabled == false) {
                if (document.getElementById('txt_credit').value == "") {
                    document.getElementById('txt_credit').focus();
                    return false;
                }
            }
        }

        if (document.activeElement.id == "txt_credit") {
            document.getElementById('btnSave').focus();
        }


        else if (document.activeElement.id == "protxtreceiptno") {
            document.getElementById('txtprovoucherdate').focus();
        }
        else if (document.activeElement.id == "txtprovoucherdate") {
            if (document.getElementById('txtrefreceiptdt').disabled == false)
                document.getElementById('txtrefreceiptdt').focus();
            else
                document.getElementById('txtagency').focus();
            return false;
        }
        else if (document.activeElement.id == "txtagency") {
            if (document.getElementById('txtagency').value == "") {
                alert("Please Select Agency");
                document.getElementById('txtagency').focus();
                return false;
            }
            else
                if (document.getElementById('txtchno').disabled == false) {
                    document.getElementById('txtchno').focus();
                    return false;
                }
                else {
                    document.getElementById('txtRep').focus();
                    return false;
                }
        }

        else if (document.activeElement.id == "txtchno") {
            if (document.getElementById('txtchno').value == "") {
                alert("Please Insert Cheque No");
                document.getElementById('txtchno').focus();
                return false;
            }
            else {

                document.getElementById('txtchdate').focus();
                return false;
            }


        }
        if (document.activeElement.id == "txtchdate") {
            if (document.getElementById('txtchdate').value == "") {
                alert("Please select Cheque Date");
                document.getElementById('txtchdate').focus();
                return false;
            }
            else {

                document.getElementById('drpbank').focus();
                return false;
            }


        }
        if (document.activeElement.id == "drpbank") {
            if (document.getElementById('drpbank1').value == "") {
                alert("Please select Bank Name");
                document.getElementById('drpbank').focus();
                return false;
            }
            else {

                document.getElementById('txtbankbranch').focus();
                return false;
            }


        }

        else if (document.activeElement.id == "txtbankbranch") {
            document.getElementById('txtamount').focus();
            return false;
        }

        else if (document.activeElement.id == "txtRep") {
            var alrt = "";
            if (browser != "Microsoft Internet Explorer") {
                alrt = document.getElementById('Representative').textContent;
            }
            else {
                alrt = document.getElementById('Representative').innerText;
            }
            if (alrt.indexOf('*') >= 0) {
                if (document.getElementById('hiddenRepresentative').value == "") {
                    alert("Please Select Representative");
                    document.getElementById('txtRep').focus();
                    return false;
                }
            }
            else
                if (document.getElementById('drpclear').disabled == true) {
                    document.getElementById('txtNarration').focus();
                    return false;
                }
                else {
                    if (document.getElementById("drpclear").style.display == "block") {
                        document.getElementById('drpclear').focus();
                        return false;
                    }
                    else {
                        document.getElementById('txtNarration').focus();
                        //  document.getElementById('txtamount').focus();
                    }
                }
        }
        else if (document.activeElement.id == "drpcaba") {
            document.getElementById('txtamount').focus();
            return false;
        }

       

        else {
            if (document.activeElement.id == "") {
                if (document.getElementById(txtpub) != null && document.getElementById(txtpub).style.display != "" && document.getElementById(txtpub).style.display != "none" && document.getElementById(txtpub).disabled != true)
                    document.getElementById(txtpub).focus();
            }
                //    if(document.activeElement.id.indexOf("gddrpunit")>=0)
                //    {
                //        var cnt=document.activeElement.id.substring(9,document.activeElement.id.length)
                //    }
            else {
                event.keyCode = 9;
                return event.keyCode;
                return false;
            }
        }
    }
    else {
        if (document.activeElement.id == "" || document.activeElement.id == "drtype") {
            //fillpaymodereason();
            return false;
        }

    }

    //-=======================end here======================
}

function BINDSEG_COLLBACK(response) {
    ds = response.value;
    if (ds.Tables[1].Rows.length == 0) {
        alert("Segment flag is not selected So you can not select Segment Name for this account head!")
        document.getElementById("divseg").style.display = "none";
        return false;
    }
    else {
        document.getElementById('hdnflgseg').value = "Y";
        var pkgitem = document.getElementById("lstseg");
        pkgitem.options.length = 0;
        pkgitem.options[0] = new Option("-Select Segment-", "0");
        if (ds != null && typeof (ds) == "object" && ds.Tables[1].Rows.length > 0) {
            pkgitem.options.length = 1;
            //alert(pkgitem.options.length);SEG_CODE,SEG_DESC
            for (var i = 0; i < ds.Tables[1].Rows.length; ++i) {
                pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[1].Rows[i].SEG_DESC, ds.Tables[1].Rows[i].SEG_CODE);
                pkgitem.options.length;
            }
            document.getElementById("lstseg").value = "0";
            document.getElementById("lstseg").focus();
        }

    }
    //document.getElementById('txtseg').value="";
    return false;
}
function bindagencyname_callback(response) {
    ds = response.value;
    //document.getElementById('drpretainer').value="";
    var pkgitem = document.getElementById("lstagency");
    pkgitem.options.length = 0;
    pkgitem.options[0] = new Option("-Select Agency-", "0");
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        pkgitem.options.length = 1;
        //alert(pkgitem.options.length);
        for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i) {
            if (ds.Tables[0].Rows[i].CITYNAME != null && ds.Tables[0].Rows[i].CITYNAME != "null") {
                pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].agency_name + "(" + ds.Tables[0].Rows[i].CITYNAME + ")", ds.Tables[0].Rows[i].code_subcode, ds.Tables[0].Rows[i].VAT);
            }
            else {

                pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].agency_name, ds.Tables[0].Rows[i].code_subcode);

            }
            pkgitem.options.length;
        }
    }
    document.getElementById('txtagency').value = "";
    document.getElementById("lstagency").value = "0";
    document.getElementById("lstagency").focus();
    return false;
}


function bindprov_callback(response) {
    ds = response.value;
    //document.getElementById('drpretainer').value="";
    var pkgitem = document.getElementById("lstprorec");
    pkgitem.options.length = 0;
    pkgitem.options[0] = new Option("-Select Receipt-", "0");
    if (ds != null && typeof (ds) == "object" && ds.Tables[0].Rows.length > 0) {
        pkgitem.options.length = 1;
        //alert(pkgitem.options.length);
        for (var i = 0  ; i < ds.Tables[0].Rows.length; ++i) {
            pkgitem.options[pkgitem.options.length] = new Option(ds.Tables[0].Rows[i].RECPTNO + "(" + ds.Tables[0].Rows[i].VOUCHERDATE + ")" + "~" + ds.Tables[0].Rows[i].MANNUAL_RECPT_NO, ds.Tables[0].Rows[i].RECPTNO);
            pkgitem.options.length;
        }
    }
    document.getElementById('protxtreceiptno').value = "";
    document.getElementById("lstprorec").value = "0";
    document.getElementById("lstprorec").focus();
    return false;
}


////////////////this function is called when we open the list box of agency than on mouse click it get the agency

function insertagency(event) {

    var key = event.keyCode ? event.keyCode : event.which;

    if (key == 13 || event.type == "click") {
        var doctype = document.getElementById('drptype').value;
        var pay_reason = document.getElementById('drppaymode').value;

        if (document.activeElement.id == "lstagency") {

            if (document.getElementById('lstagency').value == "0")// || document.getElementById('hiddensavemod').value=="01")
            {
                alert("Please select the agency code");
                return false;
            }
            document.getElementById("div1").style.display = "none";
            var datetime = document.getElementById('hiddendt').value;

            var page = document.getElementById('lstagency').value;
            document.getElementById('hiddenagency').value = page;
            // agencycodeglo=page;

            var id = "";
            if (browser != "Microsoft Internet Explorer") {

                var httpRequest = null;
                httpRequest = new XMLHttpRequest();
                if (httpRequest.overrideMimeType) {
                    httpRequest.overrideMimeType('text/xml');
                }
                httpRequest.onreadystatechange = function () { alertContents(httpRequest) };
                httpRequest.open("GET", "clientName.aspx?page=" + page + "&datetime=" + datetime + "&value=0", false);
                httpRequest.send('');
                //alert(httpRequest.readyState);
                if (httpRequest.readyState == 4) {
                    //alert(httpRequest.status);
                    if (httpRequest.status == 200) {
                        id = httpRequest.responseText;
                    }
                    else {
                        alert('There was a problem with the request.');
                    }
                }
            }
            else {
                var xml = new ActiveXObject("Microsoft.XMLHTTP");
                xml.Open("GET", "clientName.aspx?page=" + page + "&datetime=" + datetime + "&value=0", false);
                xml.Send();
                if (browser != "Microsoft Internet Explorer") {
                    id = xml.responseHTML;
                }
                else {
                    id = xml.responseText;
                }
            }

            var split = id.split("+");
            var nameagen = split[0];
            var code = split[1];
            var subcode = split[2];
            var reg = split[3];
            var repname = split[4];
            var tanno = split[5];
            document.getElementById('txtagency').value = nameagen;
            document.getElementById('txtagcode').value = code;
            document.getElementById('txtagsubcode').value = subcode;
            document.getElementById('drpreceivedrg').value = reg;
            document.getElementById('hdntanno').value = tanno;
            document.getElementById('txtagency').focus();
            chbankdt(document.getElementById('drppaymode').value);
            checktds(document.getElementById('hiddencompcode').value, document.getElementById('drptype').value, document.getElementById('drppaymode').value);

            if (document.getElementById('txtchno').disabled == false) {
                document.getElementById('txtchno').focus();
            }
            else {
                document.getElementById('txtRep').focus();
            }
            return false;
        }
        else if (document.activeElement.id == "lstprorec") {
            if (document.getElementById('lstprorec').value == "0") {
                alert("Please select the receipt");
                return false;
            }
            document.getElementById("div2").style.display = "none";
            var datetime = new Date();
            var page = document.getElementById('lstprorec').value;


            //===================add for data=============
            var id = "";
            if (browser != "Microsoft Internet Explorer") {
                var httpRequest = null;;
                httpRequest = new XMLHttpRequest();
                if (httpRequest.overrideMimeType) {
                    httpRequest.overrideMimeType('text/xml');
                }

                httpRequest.onreadystatechange = function () { alertContents(httpRequest) };


                httpRequest.open("GET", "clientName.aspx?page=" + page + "&datetime=" + datetime + "&value=1", false);
                httpRequest.send('');

                //alert(httpRequest.readyState);
                if (httpRequest.readyState == 4) {
                    //alert(httpRequest.status);
                    if (httpRequest.status == 200) {
                        id = httpRequest.responseText;
                    }
                    else {
                        alert('There was a problem with the request.');
                    }
                }
            }
            else {
                var xml = new ActiveXObject("Microsoft.XMLHTTP");
                xml.Open("GET", "clientName.aspx?page=" + page + "&datetime=" + datetime + "&value=1", false);
                xml.Send();
                id = xml.responseText;
            }

            var split = id.split("+");
            var REASON = split[0];
            if (REASON == "AAA")
                REASON = "CH0";
            var REPCODE = split[1];
            var AGCODE = split[2];


            var REMARK = split[3];
            var CHNO = split[4];
            var CHDT1 = split[5];
            CHDT1 = CHDT1.split(' ');
            var CHDT = CHDT1[0];
            var CHEQUE_DEPOSIT_DATE1 = split[13];
            CHEQUE_DEPOSIT_DATE1 = CHEQUE_DEPOSIT_DATE1.split(' ');
            var CHEQUE_DEPOSIT_DATE = CHEQUE_DEPOSIT_DATE1[0]
            var BANK = split[6];
            var AMOUNT = split[7];
            var RECEIVED_REGION = split[8];
            var AG_MAIN_CODE = split[9];
            var AG_SUB_CODE = split[10];

            var repcode1 = split[11];
            var rdt = split[12];
            var BANK_NAME = split[14];
            var CASHBANK = split[16];
            var REVENUE = split[17];
            var CASHBANKNAME = split[18];
            var REVENUENAME = split[19];

            var RECEIVED_FROM = split[15];

            var manualrepno = split[20];
            var manualrepdt = split[21];

            var CASHBANK_CDS = split[22];
            var REVENUE_CDS = split[23];

            var CASHBANK_CDS_NM = split[24];
            var REVENUE_CDS_NM = split[25];
            var CHQBANK_BRANCH = split[26]



            var dtform = document.getElementById('hiddendateformat').value;
            if (dtform == "dd/mm/yyyy") {
                if (document.getElementById('hiddencontrol').value == "sql1") {
                    var rdtarr = rdt.split('/');
                    rdt = rdtarr[1] + "/" + rdtarr[0] + "/" + rdtarr[2]
                }
                if (CHDT != "") {
                    var cdtarr = CHDT.split('/');
                    CHDT = cdtarr[1] + "/" + cdtarr[0] + "/" + cdtarr[2]
                }
                if (CHEQUE_DEPOSIT_DATE != "") {
                    var cdtarr1 = CHEQUE_DEPOSIT_DATE.split('/');
                    CHEQUE_DEPOSIT_DATE = cdtarr1[1] + "/" + cdtarr1[0] + "/" + cdtarr1[2]
                }
            }
            else if (dtform == "yyyy/mm/dd") {
                var rdtarr = rdt.split('/');
                rdt = rdtarr[2] + "/" + rdtarr[1] + "/" + rdtarr[0]
                var cdtarr = CHDT.split('/');
                CHDT = cdtarr[2] + "/" + cdtarr[1] + "/" + cdtarr[0]
                var cdtarr1 = CHEQUE_DEPOSIT_DATE.split('/');
                CHEQUE_DEPOSIT_DATE = cdtarr1[2] + "/" + cdtarr1[1] + "/" + cdtarr1[0]

            }
            else {
                rdt = rdt;
                CHDT = CHDT
                CHEQUE_DEPOSIT_DATE = CHEQUE_DEPOSIT_DATE;
            }



            document.getElementById('hiddenrepcode').value = REPCODE;
            document.getElementById('protxtreceiptno').value = page;
            document.getElementById('drppaymode').value = REASON;

            cash();

            document.getElementById('txtagency').value = AGCODE;

            document.getElementById('txtagcode').value = AG_MAIN_CODE;
            document.getElementById('txtagsubcode').value = AG_SUB_CODE;

            document.getElementById('drpreceivedrg').value = RECEIVED_REGION;


            document.getElementById('txtRep').value = repcode1;
            document.getElementById('txtNarration').value = REMARK;
            document.getElementById('txtamount').value = AMOUNT;
            document.getElementById('txtadjustamt').value = '0';
            document.getElementById('txtamthand').value = AMOUNT;
            document.getElementById('txtprovoucherdate').value = rdt;

            cash();
            document.getElementById('drpbank').value = BANK_NAME;
            document.getElementById('drpbank1').value = BANK;
            document.getElementById('txtchno').value = CHNO;
            document.getElementById('txtchdate').value = CHDT;


            document.getElementById('hidden_debit_code').value = CASHBANK;
            document.getElementById('txt_cash').value = CASHBANKNAME;
            document.getElementById('hidden_credit_code').value = REVENUE;
            document.getElementById('txt_credit').value = REVENUENAME;
            document.getElementById('txtrecfrom').value = RECEIVED_FROM;
            document.getElementById('txtdepositdate').value = CHEQUE_DEPOSIT_DATE;


            document.getElementById('hdncashback_cds').value = CASHBANK_CDS;
            document.getElementById('txt_cdp').value = CASHBANK_CDS_NM;
            document.getElementById('hdnrevenue_cds').value = REVENUE_CDS;
            document.getElementById('txt_cds').value = REVENUE_CDS_NM;
            document.getElementById('txtmanrecptno').value = manualrepno;
            document.getElementById('txtmanrecptdt').value = manualrepdt;
            document.getElementById('txtbankbranch').value = CHQBANK_BRANCH;

            if (document.getElementById('txtchno').disabled == false) {
                document.getElementById('txtchno').focus();
            }
            else {
                //document.getElementById('drpcaba').disabled=false
                //document.getElementById('drpcaba').focus();
            }

            // document.getElementById('txtamount').focus();
            /*   if( document.getElementById('drppaymode').value=="CA0")
            {
            document.getElementById('drprep').focus();
            }
            else
            {        
            document.getElementById('drpbank').focus();
            }*/

            disabllfield();
        }

        return key;
    }

}
    
 

function dateenter(event) {
    //alert(event.keyCode);

    if ((event.keyCode >= 46 && event.keyCode <= 57) || (event.keyCode >= 96 && event.keyCode <= 105) || (event.keyCode == 111) || (event.keyCode == 127) || (event.keyCode == 191) || (event.keyCode == 8) || (event.keyCode == 9) || (event.keyCode == 13)) {
        return true;
    }
    else {
        return false;
    }
}

function disabllfield() {
    if (document.getElementById('protxtreceiptno').value == "") {
        document.getElementById('txtagency').disabled = false;
    }
    else {
        document.getElementById('txtagency').disabled = false;
    }

    if (document.getElementById('drppaymode').value == "CA0") {
        document.getElementById('txtprovoucherdate').focus();
    }
    else if (document.getElementById('drppaymode').value == "0") {
        alert('Select paymode/reason');
        document.getElementById('drppaymode').focus();
    }
    else if (document.activeElement.id == "protxtreceiptno") {
        document.getElementById('txtprovoucherdate').focus();
    }
    else if (document.activeElement.id == "txtprovoucherdate") {
        document.getElementById('txtagency').focus();
    }
    else if (document.activeElement.id == "txtagency") {
        if (document.getElementById('drpbank').disabled == false) {
            document.getElementById('drpbank').focus();
            return false;
        }
        else {
            document.getElementById('txtRep').focus();
            return false;
        }
    }

}

/////////////////////////////////////


function clickseg(event) {

    var key = event.keyCode ? event.keyCode : event.which;
    if (key == 13 || event.type == "click") {
        if (document.activeElement.id == "lstseg") {

            if (document.getElementById('lstseg').value == "0") {
                alert("Please select Debit A/c Head Name");
                return true;
            }

            var page_new = document.getElementById('lstseg').value;
            repcode = page_new;

            if (browser != "Microsoft Internet Explorer") {

                for (var k = 0; k <= document.getElementById('lstseg').length - 1; k++) {
                    var abc = document.getElementById('lstseg').options[k].innerHTML;
                    if (document.getElementById('lstseg').options[k].value == page_new) {
                        var abc = document.getElementById('lstseg').options[k].innerHTML;
                        document.getElementById('lstseg').value = repcode;
                        document.getElementById('hdnseg').value = page_new;
                        alert(document.getElementById('hdnseg').value);
                        document.getElementById('txtseg').value = abc;
                        // $('hiddenrepupdate').value="updateRepresentaive";
                        document.getElementById('txt_cash').focus();
                        document.getElementById("divseg").style.display = "none";
                        break;
                    }
                }
            }
            else {

                for (var k = 0; k <= document.getElementById('lstseg').length - 1; k++) {
                    if (document.getElementById('lstseg').options[k].value == page_new) {
                        var abc = document.getElementById('lstseg').options[k].innerText;

                        document.getElementById('hdnseg').value = page_new;
                        document.getElementById('txtseg').value = abc;
                        //$('hiddenrepupdate').value="updateRepresentaive";
                        document.getElementById('txtseg').focus();
                        document.getElementById("divseg").style.display = "none";
                        break;
                    }
                }
            }
            document.getElementById("divseg").style.display = "none";
            return false;
        }
    }
    else if (key == 27) {
        document.getElementById("divseg").style.display = "none";
        document.getElementById('txtseg').focus();
        return false;
    }
}
