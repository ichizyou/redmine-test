(function(jQuery) {
  jQuery.fn.buildArtifactsController = function(options){
    var options = jQuery.extend({
    }, options);

    function showBuildArtifacts(icon, list) {
      jQuery("#build-artifacts-list").append(list.clone().attr("id","").css('display','block'));

      var target = jQuery("#build-artifacts");
      target.css("top", icon.position().top + icon.height() + 5 + "px");
      target.css("left", icon.position().left + 2 + "px");
      target.fadeIn("normal");
    }

    $("body").click(function(e) {
      if (jQuery(e.target).attr("class") == "icon-build-artifacts") {
        return;
      }
      myParents = jQuery(e.target).parents().map(function() {
        return jQuery(this).attr("id");
      });
      if (jQuery.inArray("build-artifacts", myParents) >= 0) {
        return;
      }
      jQuery("#build-artifacts").fadeOut("fast");
    });

    return this.each(function(i, elem) {
      jQuery(elem).click(function() {
        jQuery("#build-artifacts-list").text("");
        jQuery("#build-artifacts").hide();

        var jobId = jQuery(this).attr("id").substring("build-artifacts-".length);

        showBuildArtifacts(jQuery(elem), jQuery("#build-artifacts-list-" + jobId));
      });
    });
  };
})(jQuery);
