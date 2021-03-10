var browser = navigator.appName;

function closeattachment() {
    if (window.opener.document.getElementById('hdn_attachment').value != "") {
        window.opener.document.getElementById('hdn_attachment').value = window.opener.document.getElementById('hdn_attachment').value + "," + document.getElementById('lblfilename').innerHTML;
    }
    else {
        window.opener.document.getElementById('hdn_attachment').value = document.getElementById('lblfilename').innerHTML;
    }
    if (window.opener.document.getElementById('hdn_attachment').value != "") {
        window.opener.document.getElementById('attach_bno').src = "Images/indexred.jpg";
    }
    window.opener.document.getElementById('hdn_seqno').value = window.opener.document.getElementById('hdn_attachment').value.split("_")[0];

    window.close();
}


function closeattach(id) {

    //alert("1");
    //alert(newfile1.checked);

    if (window.opener.document.getElementById('hdn_attachment').value != "") {
        if (browser != "Microsoft Internet Explorer") {
            window.opener.document.getElementById('hdn_attachment').value = window.opener.document.getElementById('hdn_attachment').value + "," + document.getElementById('lblfilename').textContent;
        }
        else {
            window.opener.document.getElementById('hdn_attachment').value = window.opener.document.getElementById('hdn_attachment').value + "," + document.getElementById('lblfilename').innerHTML;
        }
    }
    else {
        if (browser != "Microsoft Internet Explorer") {
            window.opener.document.getElementById('hdn_attachment').value = document.getElementById('lblfilename').textContent;
        }
        else {
            window.opener.document.getElementById('hdn_attachment').value = document.getElementById('lblfilename').innerHTML;
        }
    }
    if (window.opener.document.getElementById('hdn_attachment').value != "")

        window.opener.document.getElementById('attach_bno').src = "Images/indexred.jpg";

    window.opener.document.getElementById('hdn_seqno').value = window.opener.document.getElementById('hdn_attachment').value.split("_")[0];

    //window.close();
    //window.close();

}



function openfile1(id) {
    if (id == "lblfilename") {
        //if (document.getElementById('lblfilename').innerHTML.indexOf(",") <= -1) {
        var attachment = document.getElementById('lblfilename').innerHTML;
        attachment = attachment.split(",");
        for (var i = 0; i < attachment.length; i++) {
            window.open("Attachment/" + attachment[i]);
        }
        //}
        //else {
        //    alert("You can not see preview of multiple files")
        //    return false;
        //}
    }
    return false;
}


function openfile(id) {

    if (id == "lblfilename") {
        if (browser != "Microsoft Internet Explorer") {
            var attachment = document.getElementById('lblfilename').innerHTML.split("<br>");//document.getElementById('lblfilename').textContent
        }
        else {
            var attachment = document.getElementById('lblfilename').innerHTML.split("<BR>");
            //var attachment = document.getElementById('lblfilename').innerText.split("<br>");
        }
        // alert(attachment.length)
        var foldername = "Attachment/";
        for (var i = 0; i < attachment.length; i++) {
            // alert(i);
            window.open(foldername + attachment[i]);
        }
    }
    return false;
}




function AddFileUploadControl() {

    if (!document.getElementById || !document.createElement) {
        alert("Your browser does not support multiple file upload.");
        return false;
    }
    var uploadArea = document.getElementById("uploadArea");

    if (!uploadArea)
        return;
    var newLine = document.createElement("br");
    uploadArea.appendChild(newLine);
    var newFile = document.createElement("input");
    newFile.type = "file";
    newFile.size = "60";
    var butt = document.createElement("input");
    butt.type = "button";

    butt.value = "X";

    //butt.setAttribute('src', 'images/1cross.jpg');
    if (!AddFileUploadControl.lastAssignedId)
        AddFileUploadControl.lastAssignedId = 1000;
    butt.setAttribute("id", "dynamic" + AddFileUploadControl.lastAssignedId);

    newFile.setAttribute("id", "dynamic" + AddFileUploadControl.lastAssignedId);
    newFile.setAttribute("name", "dynamic" + AddFileUploadControl.lastAssignedId);

    butt.onclick = function () {

        el = document.getElementById(newFile.id);
        el.parentNode.removeChild(el);

        document.getElementById(butt.id).style.visibility = "hidden";
    }

    uploadArea.appendChild(newFile);
    uploadArea.appendChild(butt);
    AddFileUploadControl.lastAssignedId++;
}

function Exit54() {
    if (window.opener.document.getElementById('hdn_attachment').value != "") {
        if (browser != "Microsoft Internet Explorer") {
            window.opener.document.getElementById('hdn_attachment').value = window.opener.document.getElementById('hdn_attachment').value + "," + document.getElementById('lblfilename').textContent;
        }
        else {
            window.opener.document.getElementById('hdn_attachment').value = window.opener.document.getElementById('hdn_attachment').value + "," + document.getElementById('lblfilename').innerHTML;
        }
    }
    else {
        if (browser != "Microsoft Internet Explorer") {
            window.opener.document.getElementById('hdn_attachment').value = document.getElementById('lblfilename').textContent;
        }
        else {
            window.opener.document.getElementById('hdn_attachment').value = document.getElementById('lblfilename').innerHTML;
        }
    }
    if (window.opener.document.getElementById('hdn_attachment').value != "")
        window.opener.document.getElementById('attach_bno').src = "Images/indexred.jpg";

    window.opener.document.getElementById('hdn_seqno').value = window.opener.document.getElementById('hdn_attachment').value.split("_")[0];
    window.close();
    //alert(window.opener.document.getElementById('hdnseqnomain').value);
    return false;


}