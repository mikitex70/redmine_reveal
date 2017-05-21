module RedmineRevealHelper
    
  def js_url(jsFile)
      "#{ActionController::Base.relative_url_root}/#{Engines.plugins['redmine_reveal'].public_asset_directory}/#{jsFile}"
  end
  
end
