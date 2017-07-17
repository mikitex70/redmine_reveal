# encoding: utf-8
require 'redmine'

class PresentationViewListener < Redmine::Hook::ViewListener

    # This method will add the necessary CSS and JS scripts to the page header.
    # The scripts are loaded before the 'jstoolbar-textile.min.js' is loaded so
    # the toolbar cannot be patched.
    # A second step is required: the textile_helper.rb inserts a small Javascript
    # fragment after the jstoolbar-textile is loaded, which pathes the jsToolBar
    # object.
    def view_layouts_base_html_head(context={})
        o = ''
        
        if editable?(context) or has_slides?(context)
            if editable?(context)
                lang = current_language.to_s.downcase
                o << stylesheet_link_tag('spectrum.css'             , :plugin => 'redmine_reveal', :media => 'screen')
                o << javascript_include_tag('spectrum.js'           , :plugin => 'redmine_reveal')
                o << javascript_include_tag("i18n/jquery.spectrum-#{lang}.js", :plugin => 'redmine_reveal')
                o << javascript_include_tag('jquery.validate.min.js', :plugin => 'redmine_reveal')
                o << javascript_include_tag("localization/messages_#{lang}.min.js", :plugin => 'redmine_reveal')
                o << javascript_include_tag('reveal_jstoolbar.js'   , :plugin => 'redmine_reveal')
            end
        
            o << javascript_include_tag('lang/reveal_jstoolbar-en.js', :plugin => 'redmine_reveal')
            o << javascript_include_tag("lang/reveal_jstoolbar-#{lang}.js", :plugin => 'redmine_reveal') if lang_supported? lang
        
            if has_slides?(context)
                o << stylesheet_link_tag('presentation.css'  , :plugin => 'redmine_reveal', :media => 'all')
                o << javascript_include_tag('wikipage_fix.js', :plugin => 'redmine_reveal')
            end
        end
    
        o
    end

    private
    
    def editable?(context)
        context[:controller] && context[:controller].is_a?(WikiController) && User.current.allowed_to?(:edit_wiki_pages, context[:project])
    end
    
    def has_slides?(context)
        true 
    end

    def lang_supported? lang
        return False if lang == 'en' # English is always loaded, avoid double load
        File.exist? "#{File.expand_path('../../../../assets/javascripts/lang', __FILE__)}/reveal_jstoolbar-#{lang}.js"
    end
    
end

