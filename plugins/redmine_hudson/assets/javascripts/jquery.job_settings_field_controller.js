(function(jQuery) {
   jQuery.fn.jobSettingsFieldController = function(options){
     var options = jQuery.extend({ 
     }, options);
     
     function setDisabled(rotate){
       id_base = jQuery(rotate).attr("id").substring(0, jQuery(rotate).attr("id").length - "_build_rotate".length);

       disabled = !jQuery(rotate).attr("checked");
       jQuery("#" + id_base + "_build_rotator_days_to_keep").prop("disabled", disabled);
       jQuery("#" + id_base + "_build_rotator_num_to_keep").prop("disabled", disabled);
     }
   
     return this.each(function(i, elem) {
       jQuery(elem).click(function() {
         setDisabled(this);
       });
       setDisabled(elem);
     });
   };
})(jQuery);

