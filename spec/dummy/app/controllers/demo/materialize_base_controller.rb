module Demo
  class MaterializeBaseController < ApplicationController
    
    layout 'kuppayam/materialize/admin'
    
    private

    def stylesheet_filename
      @stylesheet_filename = "kuppayam-materialize"
    end

    def javascript_filename
      @javascript_filename = "kuppayam-materialize"
    end

    def set_default_title
      set_title("Kuppayam - Materialize Theme - Dress up in no time!")
    end

    def configure_filter_param_mapping
      @filter_param_mapping = default_filter_param_mapping
      @filter_param_mapping[:super_admin] = :sa
      @filter_param_mapping[:user] = :us
      @filter_param_mapping[:feature] = :ft
    end
  end	
end
