# encoding: utf-8
require 'redmine'

# With Rails 5 there is some problem using the `alias_method`, can generate
# a `stack level too deep` exeception.
if Rails::VERSION::STRING < '5.0.0'
  # Rails 4, the `alias_method` can be used
  module Redmine::WikiFormatting
    module Textile::Helper
      def heads_for_wiki_formatter_with_reveal
        heads_for_wiki_formatter_without_reveal
        unless @heads_for_wiki_formatter_with_reveal_included
          # This code is executed only once and inserts a javascript code
          # that patches the jsToolBar adding the new buttons.
          # After that, all editors in the page will get the new buttons.
          content_for :header_tags do
            javascript_tag 'if(typeof(RMReveal) !== "undefined") RMReveal.initToolbar();'
          end
          @heads_for_wiki_formatter_with_reveal_included = true
        end
      end

      # alias_method_chain is deprecated in Rails 5: replaced with two alias_method
      # as a quick workaround. Using the 'prepend' method can generate an
      # 'stack level too deep' error in conjunction with other (non ported) plugins.
      #alias_method_chain :heads_for_wiki_formatter, :reveal
      alias_method :heads_for_wiki_formatter_without_reveal, :heads_for_wiki_formatter
      alias_method :heads_for_wiki_formatter, :heads_for_wiki_formatter_with_reveal
    end
    # Rails 4, the `alias_method` can be used
    module Markdown::Helper
      def heads_for_wiki_formatter_with_reveal
        heads_for_wiki_formatter_without_reveal
        unless @heads_for_wiki_formatter_with_reveal_included
          # This code is executed only once and inserts a javascript code
          # that patches the jsToolBar adding the new buttons.
          # After that, all editors in the page will get the new buttons.
          content_for :header_tags do
            javascript_tag 'if(typeof(RMReveal) !== "undefined") RMReveal.initToolbar();'
          end
          @heads_for_wiki_formatter_with_reveal_included = true
        end
      end

      # alias_method_chain is deprecated in Rails 5: replaced with two alias_method
      # as a quick workaround. Using the 'prepend' method can generate an
      # 'stack level too deep' error in conjunction with other (non ported) plugins.
      #alias_method_chain :heads_for_wiki_formatter, :reveal
      alias_method :heads_for_wiki_formatter_without_reveal, :heads_for_wiki_formatter
      alias_method :heads_for_wiki_formatter, :heads_for_wiki_formatter_with_reveal
    end
  end
else
  module RedmineReveal
    module Helpers
      module WikiFormatting
        # Rails 5, use new new `prepend` method
        def heads_for_wiki_formatter
          super
          unless @heads_for_wiki_formatter_with_reveal_included
            # This code is executed only once and inserts a javascript code
            # that patches the jsToolBar adding the new buttons.
            # After that, all editors in the page will get the new buttons.
            content_for :header_tags do
              javascript_tag 'if(typeof(RMReveal) !== "undefined") RMReveal.initToolbar();'
            end
            @heads_for_wiki_formatter_with_reveal_included = true
          end
        end
      end
    end
  end

  Redmine::WikiFormatting::Textile::Helper.prepend RedmineReveal::Helpers::WikiFormatting
  Redmine::WikiFormatting::Markdown::Helper.prepend RedmineReveal::Helpers::WikiFormatting
  Redmine::WikiFormatting::CommonMark::Helper.prepend RedmineReveal::Helpers::WikiFormatting
end
