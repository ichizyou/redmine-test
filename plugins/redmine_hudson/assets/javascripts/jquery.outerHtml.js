jQuery.fn.outerHtml = function(){
  return $('<div></div>').append(this.clone()).html();
}
