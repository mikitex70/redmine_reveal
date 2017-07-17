$(function() {
  if ($('body.controller-wiki.action-show #content section').length > 0) {
    var first_p = $('#content .wiki-page').children().first();
    
    if (first_p.text() == '' && first_p.prop("tagName") == 'P') {
      first_p.remove();
    }

    var url = window.location.pathname + '/presentation';
    $("body.controller-wiki.action-show #content .contextual")
      .append($('<a>').attr('target', '_blank')
                      .attr('href', url)
                      .addClass('icon icon-test')
                      .text(RMReveal.strings['reveal_presentation_start']));
  }
  
  $("section.slide[data-background-image]").each(function(index, elem) {
      var data = $(elem).data();
      
      $(elem).css("background-image"   , "url("+data.backgroundImage+")")
             .css("background-size"    , data.backgroundSize)
             .css("background-position", data.backgroundPosition)
             .css("background-repeat"  , data.backgroundRepeat)
  });
});
