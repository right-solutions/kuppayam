module Kuppayam
  class BaseController < ActionController::Base
    
    protect_from_forgery with: :exception

    layout 'kuppayam/admin'

    before_action :stylesheet_filename, :javascript_filename,
                  :set_default_title, :set_navs, :parse_pagination_params,
                  :configure_filters

    include ParamsParserHelper
    include RenderHelper

    include FlashHelper
    include MetaTagsHelper
    include NavigationHelper
    include BreadcrumbsHelper
    include KuppayamHelper
    
    include ImageHelper
    include FilterHelper
    
    private

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
