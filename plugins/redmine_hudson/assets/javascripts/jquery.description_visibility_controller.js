(function(jQuery) {
   jQuery.fn.descriptionVisibilityController = function(options){
     var options = jQuery.extend({ 
       initialState: true,
       labelShow: "",
       labelHide: "",
       targets: "div[class^='wiki job-description'], ul[class^='job-health-reports']"
     }, options);

     function showAll(elem) {
       jQuery(elem).text(options.labelHide);
       jQuery(options.targets).fadeIn("normal");
     }
     
     function hideAll(elem) {
       jQuery(elem).text(options.labelShow);
       jQuery(options.targets).fadeOut("normal");
     }

     function switchState(elem) {
       if (jQuery(elem).text() == options.labelHide) {
         hideAll(elem);
       } else {
         showAll(elem);
       }
     }

     return this.each(function(i, elem) {
       jQuery(elem).click(function() {
         switchState(this);
       });
       if (options.initialState) {
         showAll(elem);
       } else {
         hideAll(elem);
       }
     });
   };
})(jQuery);

