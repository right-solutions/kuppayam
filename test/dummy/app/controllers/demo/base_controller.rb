module Demo
  class BaseController < ApplicationController
    
    layout 'kuppayam/admin'
    
    private

    def set_default_title
      set_title("Demo | Admin Page")
    end

    def stylesheet_filename
      @stylesheet_filename = "kuppayam"
    end

    def javascript_filename
      @javascript_filename = "kuppayam"
    end
  end	
end
