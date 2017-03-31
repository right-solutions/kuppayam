module Demo
  class BaseController < ApplicationController
    
    layout 'kuppayam/admin'
    
    private

    def set_default_title
      set_title("Demo | Admin Page")
    end

    def configure_filter_param_mapping
      @filter_param_mapping = default_filter_param_mapping
      @filter_param_mapping[:super_admin] = :sa
      @filter_param_mapping[:user] = :us
      @filter_param_mapping[:feature] = :ft
    end
  end	
end
