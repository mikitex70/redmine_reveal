# encoding: utf-8

# Patches
require File.expand_path('../redmine_reveal/patches/controller_patch', __FILE__)
require File.expand_path('../redmine_reveal/patches/wiki_content_patch', __FILE__)

# Helpers
require File.expand_path('../redmine_reveal/helpers/textile_helper', __FILE__)
require File.expand_path('../redmine_reveal/helpers/markdown_helper', __FILE__)

# Hooks
require File.expand_path('../redmine_reveal/hooks/view_hooks', __FILE__)
require File.expand_path('../redmine_reveal/hooks/macro_dialog', __FILE__)

# Macros
require File.expand_path('../redmine_reveal/macros', __FILE__)


module RedmineReveal
end
