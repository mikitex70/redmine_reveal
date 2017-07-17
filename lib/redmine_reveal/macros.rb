# encoding: utf-8
require 'redmine'

Redmine::WikiFormatting::Macros.register do
    desc <<EOF
Configure default values for slide shows. Example usage:

{{slideSetup([...options...])}}

options:
theme=league               : default theme (beige, black, blood, league, moon, night, serif, simple, sky, solarized, white)
code_style=default         : default schema color for code highlight; see https://highlightjs.org for the complete list
transition=slide           : slide transition (none, fade, slide, convex, concave, zoom)
                             use two transitions to indicate different in and out effects, like transition=zoom slide
speed=default              : transition effect speed (slow, default fast)
background_color           : background color of slides, in HTML format (#rrggbb where r, g and b are hex digits)
background_image           : background image for the slide
background_size=cover      : background image size; length, percentage or one of cover, contain, auto
background_position=center :
background_repeat=no-repeat: background image repetition (no-repeat, repeat-x, repeat-y, repeat)
background_transition      : background transition (none, fade, slide, convex, concave, zoom)
parallax_image             : image for the background parallax effect (attachment or url)
parallax_image_size        : parallax image size, in the format "WIDTHpx HEIGHTpx"; mandatory if parallax_image is present
EOF
    macro :slideSetup do |obj, args|
        return "«Please save content first»" unless obj
        return "" unless obj.is_a?(WikiContent)
        
        args, options = extract_macro_options(args, :transition, :speed, :theme, :background_color, :background_image, :background_size, :background_position, :background_repeat, :background_transition,
        :code_style, :parallax_image, :parallax_image_size)
        
        obj.slide_options.theme                 = getTheme(obj, options[:theme])
        obj.slide_options.code_style            = getCodeStyle(obj, options[:code_style])
        obj.slide_options.transition            = getTransition(obj, options[:transition])
        obj.slide_options.speed                 = getSpeed(obj, options[:speed])
        obj.slide_options.background_color      = getBackgroundColor(obj, options[:background_color])
        obj.slide_options.background_image      = getBackgroundImage(obj, options[:background_image])
        obj.slide_options.background_size       = getBackgroundSize(obj, options[:background_size])
        obj.slide_options.background_position   = getBackgroundPosition(obj, options[:background_position])
        obj.slide_options.background_repeat     = getBackgroundRepeat(obj, options[:background_repeat])
        obj.slide_options.background_transition = getBackgroundTransition(obj, options[:background_transition])
        obj.slide_options.parallax_image        = getParallaxImage(obj, options[:parallax_image])
        obj.slide_options.parallax_image_size   = getParallaxImageSize(obj, options[:parallax_image_size])
        
        ""
    end
    
    desc <<EOF
Macro that transform a section in a slide. Example usage:

{{slide([...options...])
h2. My title

* Point 1
* Point 2
* Point 3
}}

options:
transition=slide           : slide transition (none, fade, slide, convex, concave, zoom)
                             use two transitions to indicate different in and out effects, like transition=zoom slide
speed=default              : transition effect speed (slow, default fast)
background_color           : background color of slides, in HTML format (#rrggbb where r, g and b are hex digits)
background_image           : background image for the slide
background_size=cover      : background image size; length, percentage or one of cover, contain, auto
background_position=center :
background_repeat=no-repeat: background image repetition (no-repeat, repeat-x, repeat-y, repeat)
background_transition      : background transition (none, fade, slide, convex, concave, zoom)

After using this macro you will see a link named "Presentation" in the wiki action bar.

In the body of the slide can be used other macros, but they must be closed with }\}. For example:

{{slide
...
{{insert_attach(attach_name)}\}
}}
EOF
    macro :slide do |obj, args, text|
        return "«Please save content first»" unless obj
        return "" unless obj.is_a?(WikiContent)
        
        args, options = extract_macro_options(args, :transition, :speed, :background_color, :background_image, :background_size, :background_position, :background_repeat, :background_transition)
        
        "<section class='slide #{obj.slide_options.theme}' #{section_opts(obj, options)}>".html_safe +
            textilizable(text.gsub(/\}\\\}/, "}}"), :object => obj ) +
            "</section>".html_safe
    end
    
    desc <<EOF
Macro that adds a "vertical slide" to previous slide. Example usage:

{{slide
This is tha main slide number 1
}}

{{subslide
This is slide 1.1
}}

{{subslide([...options...])
This is slide 1.2
}}

options:
transition=slide           : slide transition (none, fade, slide, convex, concave, zoom)
                             use two transitions to indicate different in and out effects, like transition=zoom slide
speed=default              : transition effect speed (slow, default fast)
background_color           : background color of slides, in HTML format (#rrggbb where r, g and b are hex digits)
background_image           : background image for the slide
background_size=cover      : background image size; length, percentage or one of cover, contain, auto
background_position=center :
background_repeat=no-repeat: background image repetition (no-repeat, repeat-x, repeat-y, repeat)
background_transition      : background transition (none, fade, slide, convex, concave, zoom)

In the body of the slide can be used other macros, but they must be closed with }\}. For example:

{{slide
...
{{insert_attach(attach_name)}\}
}}
EOF
    macro :subslide do |obj, args, text|
        return "«Please save content first»" unless obj
        return "" unless obj.is_a?(WikiContent)
        
        args, options = extract_macro_options(args, :transition, :speed, :background_color, :background_image, :background_size, :background_position, :background_repeat, :background_transition)
        
        "<section class='subslide #{obj.slide_options.theme}' #{section_opts(obj, options)}>".html_safe +
            textilizable(text.gsub(/\}\\\}/, "}}"), :object => obj) +
            "</section>".html_safe
    end
    
    desc <<EOF
Macro that add speaker notes to previous slide. Example usage:

{{slide
...
}}

{{speakerNote
This is a note for the speaker.
}}
EOF
    macro :speakerNote do |obj, args, text|
        return "«Please save content first»" unless obj
        return "" unless obj.is_a?(WikiContent)
        
        opts = ""
        
        "<aside class='notes #{obj.slide_options.theme}' #{opts}>".html_safe +
            textilizable(text.gsub(/\}\\\}/, "}}"), :object => obj) +
            "</aside>".html_safe
    end
end

Redmine::WikiFormatting::Macros.register do
    desc <<EOF
Macro that ignores its content. Example usage:

{{comment
text to ignore
}}
EOF
    macro :comment do |obj, args, text|
        return ""
    end
    
end

Redmine::WikiFormatting::Macros.register do
    desc <<EOF
Insert a text attachment in a pre formatted code, like if it is type directly.
Usefull to include piece of code. Example usage:

{{insert_attch(attach_name.ext)}}
EOF
    macro :insert_attach do |obj, args|
        return "«Please save content first»" unless obj

        args, options = extract_macro_options(args)
        filename = args.first
        
        if obj.is_a?(WikiContent)
            container = obj.page
        else
            container = obj
        end
        
        attach = container.attachments.find_by_filename(filename)
        
        file = File.open(attach.diskfile)
        contents = file.read
        file.close
        
        return "<pre><code>#{contents}</pre></code>".html_safe
    end
end

private

def section_opts(obj, options)
    "#{slide_options(obj, options)}#{style(obj, options)}"
end

def slide_options(obj, options)
    transition            = getTransition(obj, options[:transition])
    speed                 = getSpeed(obj, options[:speed])
    background_color      = getBackgroundColor(obj, options[:background_color])
    background_image      = getBackgroundImage(obj, options[:background_image])
    background_size       = getBackgroundSize(obj, options[:background_size])
    background_position   = getBackgroundPosition(obj, options[:background_position])
    background_repeat     = getBackgroundRepeat(obj, options[:background_repeat])
    background_transition = getBackgroundTransition(obj, options[:background_transition])
    
    opts  = "data-transition=\"#{transition}\" data-transition-speed=\"#{speed}\""
    opts += " data-background-color=\"#{background_color}\"" unless background_color.blank?
    
    unless background_image.blank?
        opts += " data-background-image=\"#{background_image}\""
        opts += " data-background-size=\"#{background_size}\""             unless background_size.blank?
        opts += " data-background-position=\"#{background_position}\""     unless background_position.blank?
        opts += " data-background-repeat=\"#{background_repeat}\""         unless background_repeat.blank?
        opts += " data-background-transition=\"#{background_transition}\"" unless background_transition.blank?
    end
    
    opts
end

def style(obj, options)
    background_color    = getBackgroundColor(obj, options[:background_color])
    
    style = ""
    style += "background-color:#{background_color};" unless background_color.blank?
    return " style=\"#{style}\"" unless style.blank?
    ""
end

def getTransition(obj, value)
    default = obj.slide_options.transition
    
    return default if value.blank?
    
    values = value.gsub(/\s+/m, ' ').strip.split(" ")
    
    return default                        if values.length == 0
    return getTransition1(obj, values[0]) if values.length < 2
    
    transitionIn  = getTransition1(obj, values[0])
    transitionOut = getTransition1(obj, values[1])
    
    return transitionIn if transitionIn == transitionOut
    "#{transitionIn}-in #{transitionOut}-out"
end

def getTransition1(obj, value)
#     default = obj.slide_options.transition
    
    check_transition value, obj.slide_options.transition
#     return default if value.blank?
#     return value   if ['none','fade','slide','convex','concave','zoom'].include? value
#     default
end

def check_transition(value, default)
    return default if value.blank?
    return value   if ['none','fade','slide','convex','concave','zoom'].include? value
    default
end

def getSpeed(obj, value)
    default = obj.slide_options.speed
    
    return default if value.blank?
    return value   if ['default','fast','slow'].include? value
    default
end

def getTheme(obj, value)
    default = obj.slide_options.theme
    
    return default if value.blank?
    return value   if ['beige', 'black', 'blood', 'league', 'moon', 'night', 'serif', 'simple', 'sky', 'solarized', 'white'].include? value
    default
end

def getCodeStyle(obj ,value)
    default = obj.slide_options.code_style
    
    return default if value.blank?
    
    value
end

def getBackgroundColor(obj , value)
    default = obj.slide_options.background_color
    
    return default if value.blank?
    
    value
end

def getBackgroundImage(obj, value)
    default = obj.slide_options.background_image
    
    return default if value.blank?
    return value   if value =~ /^https?:/
    
    attachment = obj.attachments.find_by_filename value
    
    return default if attachment.nil?
    download_named_attachment_url(attachment, attachment.filename)
end

def getBackgroundSize(obj, value)
    default = obj.slide_options.background_size
    
    return default if value.blank?
    
    value
end

def getBackgroundPosition(obj, value)
    default = obj.slide_options.background_position
    
    return default if value.blank?
    
    value
end

def getBackgroundRepeat(obj, value)
    default = obj.slide_options.background_repeat
    
    return default if value.blank?
    
    value
end

def getBackgroundTransition(obj, value)
    check_transition value, obj.slide_options.background_transition
end

def getParallaxImage(obj, value)
    default = obj.slide_options.parallax_image
    
    return default if value.blank?
    return value   if value =~ /^https?:/

    attachment = obj.attachments.find_by_filename value
    
    return default if attachment.nil?
    download_named_attachment_url(attachment, attachment.filename)
end

def getParallaxImageSize(obj, value)
    default = obj.slide_options.parallax_image_size
    
    return default if value.blank?
    
    value
end
