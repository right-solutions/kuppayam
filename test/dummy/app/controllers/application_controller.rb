class ApplicationController < ActionController::Base
  
  protect_from_forgery with: :exception

  before_action :stylesheet_filename, :javascript_filename,
                :set_default_title, :set_navs, :parse_pagination_params

  include Kuppayam::Engine::helpers

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
