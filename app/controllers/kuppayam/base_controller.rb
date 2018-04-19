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
      if @current_layout == "xenon"
        @stylesheet_filename = "kuppayam-xenon"
      else
        @stylesheet_filename = "kuppayam-materialize"
      end
    end

    def javascript_filename
      if @current_layout == "xenon"
        @javascript_filename = "kuppayam-xenon"
      else
        @javascript_filename = "kuppayam-materialize"
      end
    end

    def set_default_title
      set_title("Kuppayam - #{@current_layout.capitalize} Theme - Dress up in no time!")
    end

    def set_layout
      # @current_layout = "xenon"
      @current_layout = "materialize"
    end

    def determine_layout
      case @current_layout
      when "xenon"
        "kuppayam/xenon/admin"
      when "materialize"
        "kuppayam/materialize/admin"
      else
        false
      end
    end

  end	
end
