// Add Slide
jsToolBar.prototype.elements.slide = {
  type: 'button',
  title: 'Slide',
  fn: {
    wiki: function() { this.encloseLineSelection('{{slide\n', '\n}}') }
  }
}

// Add space
jsToolBar.prototype.elements.space_slide = {
  type: 'space'
}

// Move back the help at the end
var help = jsToolBar.prototype.elements.help;
delete(jsToolBar.prototype.elements.help);
jsToolBar.prototype.elements.help = help;

$('html head').append('<style>.jstb_slide{ background-image: url(/images/duplicate.png); }</style>');
