(function() {
    // Fix for Redmine 3.4.0+: fragment classes have a prefix
    $("[class^='wiki-class-']").each(function() {
        var el = $(this);
        var fixedClasses = el.attr("class").replace(/wiki-class-/g, "");
        
        el.attr("class", fixedClasses);
    });
    
    // Fix for fades on lists: move classes from span to li tag
    $("li span.fade-down,li span.fade-up,li span.fade-left,li span.fade-right,li span.fade-out,li span.fade-in").each(function() {
        var el = $(this);
        var fadeClass = $.grep(el.attr("class").split(" "), function(cls) {
            return cls.startsWith("fade-");
        })[0];
        el.parent().addClass("fragment").addClass(fadeClass);
        el.removeClass("fragment").removeClass(fadeClass);
    });
    
    function moveSlideDefinitions() {
        var lastSection = null,
            lastSlide   = null;

        $(".reveal .slides section,.reveal .slides aside.notes").each(function(idx, item) {
            if($(item).prop("tagName").toLowerCase() === "section") {
                if($(item).hasClass("subslide"))
                    $(item).appendTo(lastSection);
                else
                    lastSection = $(item);
                
                lastSlide = $(item);
            }
            else if($(item).prop("tagName").toLowerCase() === "aside")
                $(item).appendTo(lastSlide);
        });
    }

    moveSlideDefinitions();
    /*$.hook("addClass");
    $.hook("removeClass");
    $("div:has(span.fragment)".bind("onafteraddClass" function(e) {
        console.log("class added", e);
    }).bind("onafterremoveClass" function(e) {
        console.log("class removed", e);
    });*/
})();
