# encoding: UTF-8

module RedmineReveal
    module Hooks
        class MacroDialog < Redmine::Hook::ViewListener
            render_on :view_layouts_base_body_bottom, :partial => "dialogs/macro_dialog"
        end
    end
end
