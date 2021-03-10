//No 0
//insert 1
//update 2
//delete 3
//insert update 4
//insert delete 5
//update delete 6
//all 7
//view 8

function new_button(a)
{
if(a=="Records")
    {
        document.getElementById("btnDelete").disabled=true;
        return false;
    }
    
else if(a!="Modify")
{
    if(document.getElementById("hdn_user_right").value=="7")
    {
    if(a=="Query")
        {
             document.getElementById("btnQuery").disabled=true;
            document.getElementById("btnExecute").disabled=false;
        }
        else
        {
        document.getElementById("btnQuery").disabled=false;
        document.getElementById("btnExecute").disabled=true;            
        }
        if(document.getElementById("btnNew").disabled==true)
        {
        if(a=="Query")
        {
            
            document.getElementById("btnSave").disabled=true;
            }
            else
            {
                document.getElementById("btnSave").disabled=false;
            }
        }
        else
        {
            document.getElementById("btnNew").disabled=false;
            document.getElementById("btnSave").disabled=true;
        }
        

        document.getElementById("btnModify").disabled=true;

        document.getElementById("btnCancel").disabled=false;
        document.getElementById("btnfirst").disabled=true;
        document.getElementById("btnprevious").disabled=true;
        document.getElementById("btnnext").disabled=true;
        document.getElementById("btnlast").disabled=true;
        document.getElementById("btnDelete").disabled=true;
        document.getElementById("btnExit").disabled=false;
        return false;
    }
    else if(document.getElementById("hdn_user_right").value=="1")
    {
    if(document.getElementById("btnNew").disabled==true)
    {
        
        document.getElementById("btnSave").disabled=false;
    }
    else
    {
        document.getElementById("btnNew").disabled=false;
        document.getElementById("btnSave").disabled=true;
    }
        if(a=="Query")
        {
             document.getElementById("btnQuery").disabled=true;
            document.getElementById("btnExecute").disabled=false;
        }
        else
        {
        document.getElementById("btnQuery").disabled=false;
        document.getElementById("btnExecute").disabled=true;            
        }
        document.getElementById("btnModify").disabled=true;
        //document.getElementById("btnQuery").disabled=true;
        //document.getElementById("btnExecute").disabled=true;
        document.getElementById("btnCancel").disabled=false;
        document.getElementById("btnfirst").disabled=true;
        document.getElementById("btnprevious").disabled=true;
        document.getElementById("btnnext").disabled=true;
        document.getElementById("btnlast").disabled=true;
        document.getElementById("btnDelete").disabled=true;
        document.getElementById("btnExit").disabled=false; 
       // return false;    
    }
    else if(document.getElementById("hdn_user_right").value=="2")
    {
        document.getElementById("btnNew").disabled=true;
        document.getElementById("btnSave").disabled=true;
        
        if(document.getElementById("btnQuery").disabled==true)
        {
            
            document.getElementById("btnExecute").disabled=false;
        }
        else
        {
            document.getElementById("btnQuery").disabled=false;
            document.getElementById("btnExecute").disabled=true;
        }
        
        
        document.getElementById("btnModify").disabled=true;
        document.getElementById("btnCancel").disabled=false;
        document.getElementById("btnfirst").disabled=true;
        document.getElementById("btnprevious").disabled=true;
        document.getElementById("btnnext").disabled=true;
        document.getElementById("btnlast").disabled=true;
        document.getElementById("btnDelete").disabled=true;
        document.getElementById("btnExit").disabled=false;  
        return false;   
    }
    else if(document.getElementById("hdn_user_right").value=="3")
    {
    
    
        document.getElementById("btnNew").disabled=true;
        document.getElementById("btnSave").disabled=true;
        document.getElementById("btnModify").disabled=true;
    
        if(document.getElementById("btnQuery").disabled==true)
        {
            
            document.getElementById("btnExecute").disabled=false;
        }
        else
        {
            document.getElementById("btnQuery").disabled=false;
            document.getElementById("btnExecute").disabled=true;
        }
    

        document.getElementById("btnCancel").disabled=false;
        document.getElementById("btnfirst").disabled=true;
        document.getElementById("btnprevious").disabled=true;
        document.getElementById("btnnext").disabled=true;
        document.getElementById("btnlast").disabled=true;
        document.getElementById("btnDelete").disabled=true;
        document.getElementById("btnExit").disabled=false; 
        return false;    
    }
    else if(document.getElementById("hdn_user_right").value=="4")
    {
        if(a=="Query")
        {
          document.getElementById("btnSave").disabled=true;
          document.getElementById("btnQuery").disabled=true;
          document.getElementById("btnExecute").disabled=false;
        }
        else
        {
            if(document.getElementById("btnNew").disabled==true)
            {
                  document.getElementById("btnSave").disabled=false;
                  document.getElementById("btnQuery").disabled=true;
                
            }
            else
            {
                document.getElementById("btnNew").disabled=false;
                document.getElementById("btnSave").disabled=true;
                document.getElementById("btnQuery").disabled=false;
                
            }
       } 
        
        document.getElementById("btnModify").disabled=true;
      
       
        document.getElementById("btnCancel").disabled=false;
        document.getElementById("btnfirst").disabled=true;
        document.getElementById("btnprevious").disabled=true;
        document.getElementById("btnnext").disabled=true;
        document.getElementById("btnlast").disabled=true;
        document.getElementById("btnDelete").disabled=true;
        document.getElementById("btnExit").disabled=false;  
        return false;   
    }
     else if(document.getElementById("hdn_user_right").value=="5")
    {
    
     if(a=="Query")
        {
          document.getElementById("btnSave").disabled=true;
          document.getElementById("btnQuery").disabled=true;
          document.getElementById("btnExecute").disabled=false;
        }
        else
        {
            if(document.getElementById("btnNew").disabled==true)
            {
                  document.getElementById("btnSave").disabled=false;
                  document.getElementById("btnQuery").disabled=true;
                
            }
            else
            {
                document.getElementById("btnNew").disabled=false;
                document.getElementById("btnSave").disabled=true;
                document.getElementById("btnQuery").disabled=false;
                
            }
       } 
        
        document.getElementById("btnModify").disabled=true;
      
       
        document.getElementById("btnCancel").disabled=false;
        document.getElementById("btnfirst").disabled=true;
        document.getElementById("btnprevious").disabled=true;
        document.getElementById("btnnext").disabled=true;
        document.getElementById("btnlast").disabled=true;
        document.getElementById("btnDelete").disabled=true;
        document.getElementById("btnExit").disabled=false;  
        return false;    
    }
    
    else if(document.getElementById("hdn_user_right").value=="6")
    {
       if(document.getElementById("btnQuery").disabled==true)
       {
          document.getElementById("btnQuery").disabled=true;
          document.getElementById("btnExecute").disabled=false;
       }
       else
       {
          document.getElementById("btnQuery").disabled=false;
          document.getElementById("btnExecute").disabled=true;
       }
        
        document.getElementById("btnSave").disabled=true;
        document.getElementById("btnModify").disabled=true;
        document.getElementById("btnNew").disabled=true
        document.getElementById("btnCancel").disabled=false;
        document.getElementById("btnfirst").disabled=true;
        document.getElementById("btnprevious").disabled=true;
        document.getElementById("btnnext").disabled=true;
        document.getElementById("btnlast").disabled=true;
        document.getElementById("btnDelete").disabled=true;
        document.getElementById("btnExit").disabled=false;  
        return false;   
    }
    else if(document.getElementById("hdn_user_right").value=="8")
    {
     if(document.getElementById("btnQuery").disabled==true)
       {
          document.getElementById("btnQuery").disabled=true;
          document.getElementById("btnExecute").disabled=false;
       }
       else
       {
          document.getElementById("btnQuery").disabled=false;
          document.getElementById("btnExecute").disabled=true;
       }
        document.getElementById("btnNew").disabled=true;
        document.getElementById("btnSave").disabled=true;
        document.getElementById("btnModify").disabled=true;

        document.getElementById("btnCancel").disabled=false;
        document.getElementById("btnfirst").disabled=true;
        document.getElementById("btnprevious").disabled=true;
        document.getElementById("btnnext").disabled=true;
        document.getElementById("btnlast").disabled=true;
        document.getElementById("btnDelete").disabled=true;
        document.getElementById("btnExit").disabled=false;  
        return false;   
    }
   }
    
   else
   {
    if(document.getElementById("hdn_user_right").value=="3")
    {
        document.getElementById("btnModify").disabled=true
        document.getElementById("btnSave").disabled=true;
        document.getElementById("btnDelete").disabled=false;
    }
    else if(document.getElementById("hdn_user_right").value=="4")
    {
        document.getElementById("btnDelete").disabled=true;
    }
     else if(document.getElementById("hdn_user_right").value=="5")
    {
        document.getElementById("btnSave").disabled=true;
        document.getElementById("btnDelete").disabled=false;
        
    }
    else if(document.getElementById("hdn_user_right").value=="6")
    {
        document.getElementById("btnSave").disabled=false;
        document.getElementById("btnDelete").disabled=false;
        
    }
    else if(document.getElementById("hdn_user_right").value=="8")
    {
        document.getElementById("btnSave").disabled=true;
        document.getElementById("btnDelete").disabled=true;
        
        
    }
      else if(document.getElementById("hdn_user_right").value=="7")
    {
        document.getElementById("btnSave").disabled=false;
        document.getElementById("btnDelete").disabled=false;
        
        
    }
     else if(document.getElementById("hdn_user_right").value=="2")
    {
        document.getElementById("btnDelete").disabled=true;
    }
    
   }
}    

