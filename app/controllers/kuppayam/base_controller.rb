module Kuppayam
  class BaseController < ActionController::Base
    
    protect_from_forgery with: :null_session
    rescue_from ActionController::InvalidAuthenticityToken, :with => :handle_invalid_authenticity_token
    
    layout 'kuppayam/admin'

    before_action :get_nested_resource_objects
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

    # This is more like a hooker method which is called 
    # before all other before_action method.
    # This method can be overriden by inherited controller classes
    # An e.g: would be to call a method to get @store object from params[:store_id]
    # The object @store has to be initiated before the breadcrumbs or set_title methods are called
    def get_nested_resource_objects
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
