# encoding: utf-8
require 'redmine'

module PresentationControllerPatch
    def self.included(base)
        base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
        def presentation
            find_existing_or_new_page
            if @page.new_record?
                redirect_to :action => :edit
            else
                @content = @page.content_for_version(params[:version])
                render :layout => false
            end
        end
    end
end

# Apply the patch
require_dependency "wiki_controller"
WikiController.send(:include, PresentationControllerPatch)

# Give "presentation" same permessions as "view_wiki_pages"
Redmine::AccessControl.permission(:view_wiki_pages).instance_eval do
    @actions << "wiki/presentation"
end
