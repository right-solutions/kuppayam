module Kuppayam
  class BaseController < ActionController::Base
    
    protect_from_forgery with: :exception
    rescue_from ActionController::InvalidAuthenticityToken, :with => :handle_invalid_authenticity_token

    layout 'kuppayam/admin'

    before_action :set_locale, :stylesheet_filename, :javascript_filename,
                  :set_default_title, :set_navs, :parse_pagination_params,
                  :configure_filters, :configure_notification, :configure_breadcrumbs

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

    def stylesheet_filename
      @stylesheet_filename = "kuppayam"
    end

    def javascript_filename
      @javascript_filename = "kuppayam"
    end

    def set_default_title
      set_title("Kuppayam - Dress up in no time!")
    end

    def set_navs
      set_nav("home")
    end

  end	
end
