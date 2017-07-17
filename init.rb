# encoding: utf-8
Redmine::Plugin.register :redmine_reveal do
  name 'Redmine slideshow plugin'
  author 'Michele Tessaro'
  description 'Wiki macro plugin that transform wiki pages to slides'
  version '0.1.0'
  url 'https://github.com/mikitex70/redmine_reveal'
  author_url 'https://github.com/mikitex70'
  
  requires_redmine :version_or_higher => '3.0.0'
  
  should_be_disabled false if Redmine::Plugin.installed?(:easy_extensions)
end

unless Redmine::Plugin.installed?(:easy_extensions)
    require_relative 'after_init'
end
