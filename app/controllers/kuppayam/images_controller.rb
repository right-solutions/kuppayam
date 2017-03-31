module Kuppayam
  class ImagesController < Kuppayam::ResourceController

    before_action :get_image_class
    before_action :get_resource

    def index
      get_collections
    end

    def show
      @image = @image_class.find(params[:id])
    end

    def new
      @image = @image_class.new
    end

    def edit
      @image = @image_class.find(params[:id])
    end

    def create
      @image = @image_class.new
      @image.imageable = @resource
      @image.image = params[:image]
      @image.save if @image.valid?
      set_flash_message("Image has been created successfully", :success)
      render layout: "kuppayam/image_upload"
    end

    def update
      @image = @image_class.find(params[:id])
      @image.image = params[:image]
      @image.save
      set_flash_message("Image has been updated successfully", :success)
      render layout: "kuppayam/image_upload"
    end

    def crop
      @image = @image_class.find(params[:id])
      @image.assign_attributes(permitted_params)
      @image.image = params[:image]
      @image.save
      set_flash_message("Image has been cropped successfully", :success)
      render layout: "kuppayam/image_upload"
    end

    private

    def permitted_params
      params.require(:image).permit(:crop_x, :crop_y, :crop_w, :crop_h, :image)
    end

    def get_image_class
      @image_type = params[:image_type]
      @image_class = @image_type.constantize if @image_type
    end

    def get_resource
      @resource = params[:imageable_type].constantize.find(params[:imageable_id]) if params[:imageable_type] && params[:imageable_id]
    end

    def save_image
      @image = @image_class.new
      @image.imageable = @resource
      @image.image = params[:image][:image]
      @image.save
    end

    def get_collections
      @relation = Image::Base.where("")
      parse_filters
      apply_filters
      @images = @relation.page(@current_page).per(@per_page)
      return true
    end

    def apply_filters
      @relation = @relation.search(@query) if @query
      
      @order_by = "created_at desc" unless @order_by
      @relation = @relation.order(@order_by)
    end

    def configure_filter_settings
      @filter_settings = {
        string_filters: [
          { filter_name: :query }
        ],

        boolean_filters: [],

        reference_filters: [],
        variable_filters: [],
      }
    end

    def configure_filter_ui_settings
      @filter_ui_settings = {}
    end

  end
end
