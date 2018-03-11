module Demo
  class XenonBaseController < ApplicationController
    
    layout 'kuppayam/xenon/admin'

    private

    def stylesheet_filename
      @stylesheet_filename = "kuppayam-xenon"
    end

    def javascript_filename
      @javascript_filename = "kuppayam-xenon"
    end

    def set_default_title
      set_title("Kuppayam - Xenon Theme - Dress up in no time!")
    end

    def configure_filter_param_mapping
      @filter_param_mapping = default_filter_param_mapping
      @filter_param_mapping[:super_admin] = :sa
      @filter_param_mapping[:user] = :us
      @filter_param_mapping[:feature] = :ft
    end
  end	
end
