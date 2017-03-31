module Kuppayam
	class ResourceController < Kuppayam::BaseController

		include ResourceHelper

	  before_action :configure_resource_controller

	end
end
