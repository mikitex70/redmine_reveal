module RedmineRevealHelper
  
  def js_url(jsFile)
      Rails.logger.error("====> Metodo RedmineRevealHelper.js_url chiamato con parametroi #{jsFile}")
      "#{ActionController::Base.relative_url_root}/#{Engines.plugins['redmine_reveal'].public_asset_directory}/#{jsFile}"
  end
  
end

Rails.logger.error("====> Modulo RedmineRevealHelper caricato")
