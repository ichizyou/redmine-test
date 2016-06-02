(function(jQuery) {
  jQuery.fn.buildResultAppender = function(options) {
    var options = jQuery.extend({
      revisions: {} 
    }, options);

    jQuery(document).ready(function() {
      jQuery.each(options.revisions, function(revision, results) {
        changeset_refs = jQuery("div#issue-changesets div.changeset:has(a[title^='Revision " + revision + "']) div.wiki");
        message = jQuery("<p/>", {
                          class: 'hudson-build-results'
                        });
        jQuery.each(results, function() {

          linked_build = jQuery("<a/>", {
                                 class: "built-by",
                                 text: this.jobName + " #" + this.number,
                                 href: this.url
                               });

          styled_result = jQuery("<span/>", {
                                  class: "result " + this.result.toLowerCase(),
                                  style: 'font-weight:bold;',
                                  text:  this.result
                                }); 

          message.append(styled_result);
          message.append(" builded by ");
          message.append(linked_build);
          message.append(" at ");
          message.append(this.finished_at_tag);
          message.append(" ago<br/>");
        });
        changeset_refs.before(message);
      });
    });
  };
})(jQuery);
