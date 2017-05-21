# encoding: utf-8
require 'redmine'

module Redmine::WikiFormatting::Textile::Helper
    def heads_for_wiki_formatter_with_slide
        heads_for_wiki_formatter_without_slide
        unless @heads_for_wiki_formatter_with_slide_included
            content_for :header_tags do
                javascript_include_tag('jstoolbar', :plugin => 'redmine_reveal')
            end
            @heads_for_wiki_formatter_with_slide_included = true
        end
    end
    
    alias_method_chain :heads_for_wiki_formatter, :slide   
end
