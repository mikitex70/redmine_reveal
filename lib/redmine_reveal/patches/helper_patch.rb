require_dependency("application_helper")

module RedmineReveal::Patches::HelperPatch
  def self.included(base)
    base.send(:include, InstanceMethod)
  end

  module InstanceMethod
    def favicon_link_tag(source, options={})
      if plugin = options.delete(:plugin)
        source = "/plugin_assets/#{plugin}/images/#{source}"
      end
      super(source, options)
    end
  end
end

ApplicationHelper.send(:include, RedmineReveal::Patches::HelperPatch)
