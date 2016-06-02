(function(jQuery) {
  jQuery.fn.buildHistoryController = function(options){
    var options = jQuery.extend({
      url: ''
    }, options);

    function showBuildHistory(icon, htmlText) {
      var target = jQuery("#build-history");
      target.html(htmlText);
      target.css("top", icon.position().top + icon.height() + 5 + "px");
      target.css("left", icon.position().left + 2 + "px");
      target.fadeIn("normal");
    }

    $("body").click(function(e) {
      if (jQuery(e.target).attr("class") == "icon-build-history") {
        return;
      }
      myParents = jQuery(e.target).parents().map(function() {
        return jQuery(this).attr("id");
      });
      if (jQuery.inArray("build-history", myParents) >= 0) {
        return;
      }
      jQuery("#build-history").fadeOut("fast");
    });


    return this.each(function(i, elem) {
      jQuery(elem).click(function() {
        jQuery("#build-histroy").text("");
        jQuery("#build-history").hide();

        jobId = jQuery(this).attr("id").substring("build-history-".length);
        
        jQuery.ajax({
          type: "GET",
          url: options.url,
          data: "job_id=" + jobId,
          cache: false,
          success: function(data, dataType) {
            showBuildHistory(jQuery(elem), data);
          },
          error: function(request, status, ex) {
            showBuildHistory(jQuery(elem), "<span>Can't get build history. http-status: " + request.text_status) + "</span>";
          },
        });
      });
    });

  };
})(jQuery);
