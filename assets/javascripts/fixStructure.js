(function() {
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
