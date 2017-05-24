$(function () {
    //$('html head').append('<style>.jstb_slide{ background-image: url(/images/duplicate.png); }</style>');
    
  if(typeof jsToolBar === 'undefined') return false;
  
  // The macro dialog
  var dlg = $("#dlg_redmine_slide").dialog({
      autoOpen: false,
      width   : "auto",
      height  : "auto",
      modal   : true,
      open    : function(event, ui) {
          if(dlg.data("macro") === "slideSetup")
              $("#dlg_redmine_slide .reveal_setup").show();
          else
              $("#dlg_redmine_slide .reveal_setup").hide();
          
          var params = dlg.data("params");
          
          if(params)
            for(key in params) {
                $("#reveal_"+key).val(params[key]);
            }
      },
      close: function() {
          // Clear input on close
          $("#dlg_redmine_slide input,#dlg_redmine_slide select").val('');
      },
      buttons : {
          "Insert macro": function() { 
              var editor                = dlg.data("editor");
              var macroName             = dlg.data("macro");
              var transition            = $("#reveal_transition").val();
              var speed                 = $("#reveal_speed").val();
              var background_color      = $("#reveal_background_color").val();
              var background_image      = $("#reveal_background_image").val();
              var background_transition = $("#reveal_background_transition").val();
              var options = [];

              if(macroName === "slideSetup") {
                  var theme      = $("#reveal_theme").val();
                  var code_style = $("#reveal_code_style").val();
                  
                  if(theme             != "") options.push("theme="+theme);
                  if(code_style        != "") options.push("code_style="+code_style);
              }
              if(transition            != "") options.push("transition="+transition);
              if(speed                 != "") options.push("speed="+speed);
              if(background_color      != "") options.push("background_color="+background_color);
              if(background_image      != "") options.push("background_image="+background_image);
              if(background_transition != "") options.push("background_transition="+background_transition);

              if(options.length)
                  options = '('+options.join(',')+')';
              else
                  options = "";
            
              if(dlg.data("params")) {
                  // Edited macro: replace the old macro (with parameters) with the new text
                  editor.encloseSelection('{{'+macroName+options, '', function(sel){ 
                      return ''; 
                  });
              }
              else
                  // New macro
                  editor.encloseSelection('{{'+macroName+options+'\n','\n}}');
              
              dlg.dialog("close");
          },
          Cancel: function() {
              dlg.dialog("close");
          }
      }
  });
  
  $("#reveal_background_color").spectrum({
      preferredFormat: "hex",
      allowEmpty     : true,
      showInput      : true,
      showInitial    : true
  });
  
  // Compatibility checks
  if(!String.prototype.startsWith) {
      String.prototype.startsWith = function(searchString, position) {
          position = position || 0;
          return this.substr(position, searchString.length) === searchString;
      };
  }
  
  if (!String.prototype.trim) {
      String.prototype.trim = function () {
          return this.replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, '');
      };
  }
  
  /**
   * Find where starts the expectedMacro and returs its parameters.<br/>
   * It expects that the cursor is positioned inside the macro.<br/>
   * The macro header (the opening brackets, the macro name and the
   * optional parameters) will be selected, so inserting the new
   * macro header will overwite the old.
   * @param editor The editor where to find the macro
   * @param expectedMacro The expected macro name
   * @return An hash with the macro arguments, or {@code null} if not found.
   */
  function findMacro(editor, expectedMacro) {
      var text = $(editor.textarea).val();
      var caretPos = $(editor.textarea).prop("selectionStart");
      
      // Move left to find macro start; the test on } is needed for not go too much ahead
      while(caretPos > 1 && !text.startsWith('{{', caretPos) && !text.startsWith('}}', caretPos))
          caretPos--;
      
          if(text.startsWith('{{', caretPos)) {
          // Start of a macro
          var macro = text.substring(caretPos);
          var match = macro.match("^\\{\\{"+expectedMacro+"(?:\\((.*)\\))?");
      
          if(match) {
              // Select macro text
              editor.textarea.focus();
              
              if(typeof(editor.textarea.selectionStart) != 'undefined') {
                  // Firefox/Chrome
                  editor.textarea.selectionStart = caretPos;
                  editor.textarea.selectionEnd   = caretPos+match[0].length;
              }
              else {
                  // IE
                  var range = document.selection.createRange();
                  
                  range.collapse(true);
                  range.moveStart("character", caretPos);
                  range.moveEnd("character", caretPos+match[0].length);
                  range.select();
              }
              
              // Extracting macro arguments
              var params = {};
              var args   = [];
              
              if(match[1]) {
                  args = match[1].split(',');
                  
                  for(var i=0; i<args.length; i++) {
                      var parts = args[i].split('=');
                      
                      if(parts.length == 2)
                          params[parts[0].trim()] = parts[1].trim();
                      else
                          params[parts[0].trim()] = null;
                  }
              }
              
              return params;
          }
          else {
              console.debug("Macro diversa");
          }
      }
      else {
          console.debug("Nessuna macro trovata")
      }
      
      return null;
  }
  
  jsToolBar.prototype.elements.slide = {
    type : 'button',
    title: 'Slide',
    fn: {
      wiki: function() { 
        var params = findMacro(this, "slide");
        
        dlg.data("editor", this)
           .data("macro", "slide")
           .data("params", params)
           .dialog("option", "title", "Add a new slide macro")
           .dialog("open");
      }
    }
  }

  jsToolBar.prototype.elements.subSlide = {
    type : 'button',
    title: 'Sub slide',
    fn: {
      wiki: function() { 
          var params = findMacro(this, "subSlide");
          
          dlg.data("editor", this)
             .data("macro", "subSlide")
             .data("params", params)
             .dialog("option", "title", "Add a new subSlide macro")
             .dialog("open");
      }
    }
  }
    
  jsToolBar.prototype.elements.slideSetup = {
    type : 'button',
    title: 'Slide setup',
    fn: {
      wiki: function() { 
          var params = findMacro(this, "slideSetup");
          
          dlg.data("editor", this)
             .data("macro", "slideSetup")
             .data("params", params)
             .dialog("option", "title", "Add a new slideSetup macro")
             .dialog("open");
      }
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
    
  wikiToolbar.draw();
});
