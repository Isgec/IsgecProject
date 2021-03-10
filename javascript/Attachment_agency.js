function closeattachment()
{
        if (window.opener.document.getElementById('hid_attachmnt').value != "") {
            window.opener.document.getElementById('hid_attachmnt').value = window.opener.document.getElementById('hid_attachmnt').value + "," + document.getElementById('lblfilename').innerHTML;
            //window.opener.document.getElementById('lblattachment').innerText = window.opener.document.getElementById('hid_attachmnt').value
        }
        else {
            window.opener.document.getElementById('hid_attachmnt').value = document.getElementById('lblfilename').innerHTML;
            //window.opener.document.getElementById('lblattachment').innerText = window.opener.document.getElementById('hid_attachmnt').value
        }
//        if (window.opener.document.getElementById('hid_attachmnt').value != "")
//            window.opener.document.getElementById('attach_bno').src = "Images/indexred.jpg";
         
          window.close();
}


function openfile(id) {
   
        if (id == "lblfilename")
         {
            if(document.getElementById('lblfilename').innerHTML.indexOf(",")<=-1)
            {
                var attachment = document.getElementById('lblfilename').innerHTML;
                
                    window.open("Attachment/Agency/" + attachment);
               
            }
            else
            {
                  alert("You can not see preview of multiple files")
                  return false;
            }
        }
       
    return false;
}