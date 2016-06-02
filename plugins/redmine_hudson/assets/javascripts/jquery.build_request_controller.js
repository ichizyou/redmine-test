(function(jQuery) {
  jQuery.fn.buildRequestController = function(options){
    var options = jQuery.extend({
      url: '',
      message_success: '',
      message_failure: ''
    }, options);

    function showBuildRequestResult(id, message) {
      jQuery(id).html(message).fadeIn("normal");
    }

    function requestSuccess(jobName, data) {
      if (data.indexOf('OK:') == 0) {
        message = options.message_success.replace('${job_name}', jobName);
        showBuildRequestResult('#info', message);
      } else {
        message = options.message_failure.replace('${job_name}', jobName);
        showBuildRequestResult('#error', message + "<br/>" +
                                         "server errror<br/>" + data);
      }
    }

    function requestFailure(jobName, data) {
      message = options.message_failure.replace('${job_name}', jobName);
      showBuildRequestResult('#error', message + "<br/>" +
                                       "request error<br/>" +
                                       "request.state: '" + data.state() + "' " +
                                       "statusText: '" + data.statusText + "' ");
    }

    return this.each(function(i, elem) {
      jQuery(elem).click(function() {
        jQuery("#info").text("").hide();
        jQuery("#error").text("").hide();

        jobId = jQuery(this).attr("id").substring("build-request-".length);
        jobName = jQuery("h3#job-name-" + jobId + " a").text();
        
        jQuery.ajax({
          type: "GET",
          url: options.url,
          data: "job_id=" + jobId,
          cache: false,
          success: function(data, dataType) {
            requestSuccess(jobName, data);
          },
          error: function(request, status, ex) {
            requestFailure(jobName, request);
          },
        });
      });
    });

  };
})(jQuery);
