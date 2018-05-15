module Kuppayam
  class BaseController < ActionController::Base
    
    protect_from_forgery with: :null_session
    rescue_from ActionController::InvalidAuthenticityToken, :with => :handle_invalid_authenticity_token
    
    # Choose the theme and set one of the following in your inherited controllers 
    before_action :set_layout, :stylesheet_filename, :javascript_filename
    before_action :set_locale, :set_default_title, :set_navs, :parse_pagination_params
    before_action :configure_filters, :configure_notification, :configure_breadcrumbs

    layout :determine_layout

    include ParamsParserHelper
    include RenderHelper
    
    include FlashHelper
    include NotificationHelper
    include MetaTagsHelper
    include NavigationHelper
    include BreadcrumbsHelper
    include KuppayamHelper
    
    include ImageHelper
    include FilterHelper
    include ResourceViewHelper
    
    private

    # Setting the Locale from User Preferences
    # With this approach, http://localhost:3000?locale=pt 
    # renders the Portuguese localization, while 
    # http://localhost:3000?locale=de 
    # loads a German localization.
    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

    # Every helper method dependent on url_for 
    # (e.g. helpers for named routes like root_path 
    # or root_url, resource routes like books_path 
    # or books_url, etc.) will now automatically 
    # include the locale in the query string, 
    # like this: http://localhost:3001/?locale=ja.
    def default_url_options
      { locale: I18n.locale }
    end

    def set_navs
      set_nav("home")
    end

    def stylesheet_filename
      @stylesheet_filename = "kuppayam-#{@current_layout}"
    end

    def javascript_filename
      @javascript_filename = "kuppayam-#{@current_layout}"
    end

    def set_default_title
      set_title("Kuppayam - #{@current_layout.capitalize} Theme - Dress up in no time!")
    end

    def set_layout
      # Possible Options - xenon, materialize, bootstrap4
      @current_layout = "xenon"
    end

    def determine_layout
      "kuppayam/#{@current_layout}/admin"
    end
    
    def generate_sidebar_links
      {}
    end

  end	
end
