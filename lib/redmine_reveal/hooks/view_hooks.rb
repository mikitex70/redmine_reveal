# encoding: utf-8
require 'redmine'

class PresentationViewListener < Redmine::Hook::ViewListener
    # Adds javascript and stylesheet tags
    def view_layouts_base_html_head(context)
        return stylesheet_link_tag("presentation.css", :plugin => "redmine_reveal", :media => "all") +
           stylesheet_link_tag("spectrum.css", :plugin => "redmine_reveal", :media => "screen") +
           javascript_include_tag('spectrum.js', :plugin => 'redmine_reveal') +
           javascript_include_tag("run.js", :plugin => "redmine_reveal")
    end
end

