// The container for global settings
if(typeof(RMReveal) === 'undefined')
    RMReveal = {};

// Container for localized strings
RMReveal.strings = {};

(function () {
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
    
    // Add regex-based validator
    $.validator.addMethod(
        "regex",
        function(value, element, regexp) {
            var re = new RegExp(regexp);
            return this.optional(element) || re.test(value);
        },
        "Please check your input."
    );
    
    /**
     * Find where starts the expectedMacro and returs its parameters.<br/>
     * It expects that the cursor is positioned inside the macro.<br/>
     * The macro header (the opening brackets, the macro name and the
     * optional parameters) will be selected, so inserting the new
     * macro header will overwite the old.
     * @param editor The editor where to find the macro
     * @param expectedMacro The expected macro name
     * @return An hash with the macro arguments, {@code null} if not found or
     *         {@code false} if wrong macro found.
     */
    function findMacro(editor, expectedMacro) {
        var text = $(editor.textarea).val();
        var caretPos = $(editor.textarea).prop("selectionStart");
        
        // Move left to find macro start; the test on }} is needed for not go too much ahead
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
                
                if(match[1]) {
                    var args = match[1].split(',');
                    
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
//             else
//                 return false;
        }
//         else {
//             console.debug("No macro found")
//         }
        
        return null;
    }
    
    // The dialog must be defined only when the document is ready
    var dlg;
    
    $(function() {
        var dlgButtons = {};
        
        dlgButtons[RMReveal.strings['reveal_btn_ok']] = function() {
            if(!$("#reveal_form").valid())
                return;
            
            var editor    = dlg.data("editor");
            var macroName = dlg.data("macro");
            // Extract field values as macro options
            var options   = $("[id^='reveal_']:visible").map(function() {
                if($(this).hasClass("noparam"))
                    return;  // Field does not map to a parameter
                    var optName = this.id.toString().substring("reveal_".length);
                var value   = $(this).val();
                
                if(value != "" && value != $(this).data("default"))
                    return optName+"="+value;
                
                return null;
            }).get();
            
            var width  = $("#reveal_parallax_image_width").val(),
                height = $("#reveal_parallax_image_height").val();
                
            if(width != "" && height != "")
                options.push("parallax_image_size="+width+"px "+height+"px");
            
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
        };

        dlgButtons[RMReveal.strings['reveal_btn_cancel']] = function() {
            dlg.dialog("close");
        };
        
        // The macro dialog
        dlg = $("#dlg_redmine_slide").dialog({
            autoOpen: false,
            width   : 520,
            height  : "auto",
            modal   : true,
            open    : function(event, ui) {
                if(dlg.data("macro") === "slideSetup") {
                    $("#dlg_redmine_slide .reveal_setup").show();
                    $("#reveal_form").tabs("option", "active", 0);
                }
                else {
                    $("#dlg_redmine_slide .reveal_setup").hide();
                    $("#reveal_form").tabs("option", "active", 1);
                }
                
                // Pre-set default values
                $("#dlg_redmine_slide input,#dlg_redmine_slide select").each(function() {
                    if(this.id.toString().match(/_color$/))
                        $(this).spectrum('set', null);
                    
                    $(this).val($(this).data("default") || '');
                });
                
                // Set input values from macro parameters
                var params = dlg.data("params");
                
                if(params) {
                    for(key in params)
                        $("#reveal_"+key).val(params[key]);
                    
                    var m = /(\d+)px (\d+)px/.exec(params["parallax_image_size"]);
                    
                    if(m) {
                        $("#reveal_parallax_image_width").val(m[1]);
                        $("#reveal_parallax_image_height").val(m[2]);
                    }
                }
                
                // enable/disable fields based on input values
                $("#reveal_form input[data-requires],#reveal_form select[data-requires]").each(function(index, el) {
                    var v = $("#"+$(el).data("requires")).val();
                    
                    if(v === '')
                        $(el).attr("disabled", "disabled");
                    else
                        $(el).removeAttr("disabled");
                });
                
                $("#reveal_validate_msg").empty();
                $("#reveal_form input,#reveal_form select").removeClass("error");
            },
            buttons: dlgButtons
        });
        
        $("#reveal_form").tabs();
        
        // Attach color chooser
        $("#reveal_background_color").spectrum({
            preferredFormat: "hex",
            allowEmpty     : true,
            showInput      : true,
            showInitial    : true
        });
        
        // Attach keyup events to auto enable/disable dialog fields
        $("#reveal_form input[data-requires],#reveal_form select[data-requires]").each(function(index, el) {
            var item = "#"+$(el).data("requires");
            
            $(item).keyup(function() {
                if($(this).val() === '')
                    $(el).attr("disabled", "disabled");
                else
                    $(el).removeAttr("disabled");
            });
        });
        
        // Define form validator
        $("#reveal_form").validate({
            submitHandler: function () {
                return false;
            },
            ignore: null,
            errorPlacement: function(error, element) {
                var tabID  = element.closest("fieldset").attr("id");
                var link   = $("#reveal_form ul li a[href='#"+tabID+"']");
                var tabIdx = $("#reveal_form ul li a").index(link);
                
                error.appendTo($("#reveal_validate_msg"));
                error.click(function() {
                    $("#reveal_form").tabs("option", "active", tabIdx);
                });
            },
            rules: {
                reveal_parallax_image_with: {
                    required: {
                        depends: function(element) {
                            return $("#reveal_parallax_image").val() != "";
                        }
                    }
                },
                reveal_parallax_image_height: {
                    required: {
                        depends: function(element) {
                            return $("#reveal_parallax_image").val() != "";
                        }
                    }
                },
                reveal_background_size: {
                    regex: /^auto|cover|contain|(?:\d+(?:px|pt|pc|cm|mm|in))$/
                },
                reveal_background_position: {
                    regex: /^(?:(?:left|center|right)(?:\s+top|center|bottom)?)|(?:\d+\s+\d+)|(?:\d+%\s+\d+%)$/
                }
            },
            messages: {
                reveal_background_size: {
                    regex: RMReveal.strings['reveal_backsize_validation']
                }
            }
        });
        
    });
    
    // Initialize the jsToolBar object; called explicitly after the jsToolBar has been created
    RMReveal.initToolbar = function() {
        jsToolBar.prototype.elements.slide = {
            type : 'button',
            title: RMReveal.strings['reveal_slide_btntitle'],
            fn   : {
                wiki: function() { 
                    var params = findMacro(this, "slide");
         
                    dlg.data("editor", this)
                       .data("macro", "slide")
                       .data("params", params)
                       .dialog("option", "title", RMReveal.strings['reveal_slide_dlgtitle'])
                       .dialog("open");
                }
            }
        }
        
        jsToolBar.prototype.elements.subSlide = {
            type : 'button',
            title: RMReveal.strings['reveal_subslide_btntitle'],
            fn   : {
                wiki: function() { 
                    var params = findMacro(this, "subSlide");
         
                    dlg.data("editor", this)
                       .data("macro", "subSlide")
                       .data("params", params)
                       .dialog("option", "title", RMReveal.strings['reveal_subslide_dlgtitle'])
                       .dialog("open");
                }
            }
        }
      
        jsToolBar.prototype.elements.slideSetup = {
            type : 'button',
            title: RMReveal.strings['reveal_slidesetup_btntitle'],
            fn   : {
                wiki: function() { 
                    var params = findMacro(this, "slideSetup");
         
                    dlg.data("editor", this)
                       .data("macro", "slideSetup")
                       .data("params", params)
                       .dialog("option", "title", RMReveal.strings['reveal_slidesetup_dlgtitle'])
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
    };
  
})();
