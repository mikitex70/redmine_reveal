# encoding: UTF-8

class RedmineRevealHookListener < Redmine::Hook::ViewListener
    render_on :view_layouts_base_body_bottom, :partial => "dialogs/macro_dialog"
#     render_on :view_layouts_base_body_bottom, :partial => "dialogs/fragment_dialog"
end
