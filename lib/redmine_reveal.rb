# encoding: utf-8

# Patches
require_relative 'redmine_reveal/patches/controller_patch'
require_relative 'redmine_reveal/patches/helper_patch'
require_relative 'redmine_reveal/patches/wiki_content_patch'

# Helpers
require_relative 'redmine_reveal/helpers/wiki_formatting'

# Hooks
require_relative 'redmine_reveal/hooks/view_hooks'
require_relative 'redmine_reveal/hooks/macro_dialog'

# Macros
require_relative 'redmine_reveal/macros'


module RedmineReveal
end
