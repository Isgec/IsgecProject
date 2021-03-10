// JScript File

function tabvalue ()
{



if(event.keyCode==13)
{

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

