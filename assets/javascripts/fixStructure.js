(function() {
    // Fix for Redmine 3.4.0+: fragment classes have a prefix
    $("span[class^='wiki-class-']").each(function() {
        var el = $(this);
        var fixedClasses = el.attr("class").replace(/wiki-class-/g, "");
        
        el.attr("class", fixedClasses);
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
})();
