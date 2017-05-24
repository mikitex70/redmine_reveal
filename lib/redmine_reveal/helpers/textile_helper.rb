# encoding: utf-8
require 'redmine'

module Redmine::WikiFormatting::Textile::Helper
    def heads_for_wiki_formatter_with_slide
        heads_for_wiki_formatter_without_slide
        unless @heads_for_wiki_formatter_with_slide_included
            content_for :header_tags do
                #stylesheet_link_tag 'drawioEditor.css', :plugin => 'redmine_reveal', :media => 'screen'
                #javascript_include_tag 'spectrum', :plugin => 'redmine_reveal'
                javascript_include_tag 'reveal_jstoolbar', :plugin => 'redmine_reveal'
            end
            @heads_for_wiki_formatter_with_slide_included = true
        end
    end
    
    alias_method_chain :heads_for_wiki_formatter, :slide   
end
