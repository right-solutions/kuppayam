module Kuppayam
  class Engine < ::Rails::Engine

    require 'kaminari'
    require 'jquery-rails'
    
    config.autoload_paths << File.expand_path("../extras", __FILE__)
    
  	initializer "kuppayam.assets.precompile" do |app|
      app.config.assets.precompile += %w( kuppayam.js jquery_and_family.js kuppayam.css jquery_and_family.css wysiwyg-color.css)
    end

    config.before_initialize do                                                      
      config.i18n.load_path += Dir["#{config.root}/config/locales/**/*.yml"]
    end

    initializer "kuppayam.action_view" do |app|
      ActiveSupport.on_load :action_view do
        include Kuppayam::ActionView::FormHelper
        include Kuppayam::ActionView::ModalHelper
        include Kuppayam::ActionView::ThemeHelper
      end
    end

    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

    config.generators do |g|
      g.test_framework      :rspec, :fixture => false
      g.fixture_replacement :factory_bot, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

  end
end
