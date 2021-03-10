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
function openfile(id) {
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