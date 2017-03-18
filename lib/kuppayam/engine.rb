module Kuppayam
  class Engine < ::Rails::Engine

    require 'kaminari'
    require 'jquery-rails'
    
  	config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer "kuppayam.assets.precompile" do |app|
      app.config.assets.precompile += %w( kuppayam.js jquery_with_ujs.js kuppayam.css )
    end

    # initializer 'kuppayam.action_controller' do |app|
    #   ActiveSupport.on_load :action_controller do
    #     helper Kuppayam::Engine::helpers
    #     include Kuppayam::Engine::helpers
    #   end
    # end

    initializer "kuppayam.action_view" do |app|
      ActiveSupport.on_load :action_view do
        include Kuppayam::ActionView::FormHelper
        include Kuppayam::ActionView::ModalHelper
        include Kuppayam::ActionView::ThemeHelper
      end
    end

  end
end
