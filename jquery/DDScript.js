/*
* Created by Raju Dasa on 30-oct-2011
* www.RajuDasa.blogspot.com
* free source, change code for ur purpose.
*/
//maindiv//
//var sanjeet = jQuery.noConflict();//
var jQuery = $.noConflict();
jQuery(function() {
jQuery("#btnattach").click(function()
    {
       jQuery("#maindiv").show("slow");
    //jQuery("#maindiv").fadeIn("slow");
       // jQuery("#maindiv1").show("slow");
        jQuery("#btnFinal").show("slow");
        jQuery("#btnFinal1").hide();

        var compcode = jQuery('#hdncompcode').val();
        var extra1 = ""; //jQuery('#txt_dept_name').val();
        var extra2 = "";
        var extra3 = "";
        var extra4 = "";
        jQuery.ajax({
            type: "POST",
            url: "fin_budget_hierarchy.aspx/GetJsonData",
            contentType: "application/json; charset=utf-8",
            // data: "{'compcode':'" + compcode + "', 'unitcode':'" + unitcode + "', 'brancode':'" + brancode + "', 'ptype':'" + ptype + "','pdate':'" + pdate + "', 'dateformat':'" + dateformat + "','userid':'" + userid + "','extra1':'" + extra1 + "','extra2':'" + extra2 + "','extra3':'" + extra3 + "','extra4':'" + extra4 + "'}",
            data: "{'compcode':'" + compcode + "','extra1':'" + extra1 + "','extra2':'" + extra2 + "','extra3':'" + extra3 + "','extra4':'" + extra4 + "'}",
            dataType: "json",
            success: function(result) {
                var $json = jQuery.parseJSON(result.d);
                pageload($json);
            }
        });
    });
});
jQuery(function() {
    jQuery("#btnattach0").click(function() {
        jQuery("#maindiv").show("slow");
       // jQuery("#maindiv1").show("slow");
        jQuery("#btnFinal1").show("slow");
        jQuery("#btnFinal").hide();
        var comp_code = jQuery('#hdncompcode').val();
        var bud_category = ""; //jQuery('#txt_cat_name').val();
        var bud_id = "";
        var user_code = jQuery('#hdnuserid').val();
        var extra1 = "MULTIPLE";
        var extra2 = "";
        var extra3 = "";
        var extra4 = "";
        var extra5 = "";
        var extra6 = "";
        var extra7 = "";
        var extra8 = "";
        var extra9 = "";
        var extra10 = "";
        jQuery.ajax({
            type: "POST",
            url: "fin_budget_hierarchy.aspx/GetJsonData1",
            contentType: "application/json; charset=utf-8",
            // data: "{'compcode':'" + compcode + "', 'unitcode':'" + unitcode + "', 'brancode':'" + brancode + "', 'ptype':'" + ptype + "','pdate':'" + pdate + "', 'dateformat':'" + dateformat + "','userid':'" + userid + "','extra1':'" + extra1 + "','extra2':'" + extra2 + "','extra3':'" + extra3 + "','extra4':'" + extra4 + "'}",
            data: "{'comp_code':'" + comp_code + "','bud_category':'" + bud_category + "','bud_id':'" + bud_id + "','user_code':'" + user_code + "','extra1':'" + extra1 + "','extra2':'" + extra2 + "','extra3':'" + extra3 + "','extra4':'" + extra4 + "','extra5':'" + extra5 + "','extra6':'" + extra6 + "','extra7':'" + extra7 + "','extra8':'" + extra8 + "','extra9':'" + extra9 + "','extra10':'" + extra10 + "'}",
            dataType: "json",
            success: function(result) {
                var $json = jQuery.parseJSON(result.d);
                pageload($json);
            }
        });
    });
});



function pageload($json) 
{            
    jQuery("#list1").empty().addItems($json);
        
    jQuery("#list1, #list2").sortable({
        connectWith: ".connectedSortable",
        beforeStop: function(event, ui) { 
            ui.helper.removeClass("selectedItem"); 
            ui.helper.die();   
        },
        change: function(event, ui) {  //for issue solving                    
            var placeHolder = ui.helper.children(".ui-sortable-placeholder");
            if(placeHolder){
                placeHolder.detach().appendTo(ui.helper.parent());
            }
        },
        start: function(event, ui) { 
            if(ui.helper){
                var cnt = ui.helper.parent().children(".selectedItem:not(.ui-sortable-placeholder)").length;
                if(cnt > 1)
                {
                    var parent = ui.helper.parent();
                    var childs = parent.children("div.selectedItem:not(.ui-sortable-placeholder)");
                    jQuery.each(childs, function(index, child) {
                        child = jQuery(child);
                        if(ui.helper.attr('id') != child.attr('id'))
                        { 
                            child = child.detach();
                            child.appendTo(ui.helper);
                            child.css("margin","0px").css("padding","0px"); //addClass not working
                        }
                    });
                }
            }
         },
        stop: function(event, ui) {  
            //console.log(ui.helper);
            if(ui.item){
                var cnt = jQuery(ui.item[0]).children("div").length;
                if(cnt > 0)
                {
                    //ui.helper is null
                    var dropItem = jQuery(ui.item[0]);
                    jQuery.each(dropItem.children("div"), function(index, child) {                                                               
                            child = jQuery(child).detach();
                            child.insertAfter(dropItem);
                            child.removeClass("selectedItem");
                            child.css("margin","").css("padding","");
                    });
                }
            }
         }
    }).disableSelection();

    //click color handling
   jQuery("#list1>div, #list2>div").live("click",function(e){
   if(!e.ctrlKey)
   {
       jQuery(this).parent().children().removeClass("selectedItem"); 
   }
   jQuery(this).toggleClass("selectedItem"); 
   });           
}
  
//custom jQuery function/plugin : used instead of template plugin
jQuery.fn.addItems = function(data) {
return this.each(function() {
	var parent = this;
	jQuery.each(data, function(index, itemData) {
		jQuery("<div>")
       .text(itemData.name)
       .attr("id", "div"+itemData.id)
       .appendTo(parent); 
	});
});
};

//finally create json
var json;
function CreateJson()
{
    json = "[";
    jQuery.each( jQuery("#list2>div"), function(index, div) {
        var $div = jQuery(div);
        if(index>0) json += ",";
        json += '{"id":' + $div.attr('id').replace("div","");
        json += ',"name":"' + $div.text() + '"}';
    });
    json = json + "]";
    jQuery("#hidJsonHolder").val(json);
    //=============================
    
    //==============================
    return json;
}





//$(function(){
//    $("#button1").click(function(){
//        $("#list1 > option:selected").each(function(){
//            $(this).remove().appendTo("#list2");
//        });
//    });

//    $("#button2").click(function(){
//        $("#list2 > option:selected").each(function(){
//            $(this).remove().appendTo("#list1");
//        });
//    });
//});​