# encoding: utf-8

Refinery::I18n.configure do |config|
  config.enabled = true

  config.default_locale = :ru

  config.current_locale = :ru

  config.default_frontend_locale = :fr

  config.frontend_locales = [:ru, :en]

  config.locales = {:ru=>"Русский", :en=>"English"}
end
