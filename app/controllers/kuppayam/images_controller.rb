module Kuppayam
  class ImagesController < Kuppayam::ResourceController

    before_action :get_image_class
    before_action :get_resource
    
    def index
      get_collections
    end

    def show
      @image = Image::Base.find(params[:id])
      get_image_configuration
      @r_object = @image = Image::Base.find(params[:id])
      unless @r_object
        set_notification(false, I18n.t('status.error'), I18n.t('status.not_found', item: "Image"))
      end
      render_accordingly
    end

    def new
      @image = @image_class.new(imageable: @resource)
      get_image_configuration
    end

    def edit
      @image = @image_class.find(params[:id])
      get_image_configuration
    end

    def create
      @image = @image_class.new
      get_image_configuration
      @image.imageable = @resource
      @image.image = params[:image]
      # @image.image_type = @image_class.name
      @image.save if @image.valid?
      set_flash_message("Image has been created successfully", :success)
      render layout: "kuppayam/image_upload"
    end

    def update
      @image = @image_class.find(params[:id])
      get_image_configuration
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

    def destroy
      @image = @r_object = @image_class.find(params[:id])
      @id = @image.id
      if @image
        @image.destroy
        set_flash_message(I18n.t('success.deleted'), :success)
        set_notification(true, I18n.t('status.success'), I18n.t('success.deleted', item: "Image"))
        @destroyed = true
      else
        set_notification(false, I18n.t('status.error'), I18n.t('status.not_found', item: "Image"))
      end
      
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

    def resource_controller_configuration
      {
        page_title: "Images",
        js_view_path: "/kuppayam/workflows/parrot",
        view_path: "/kuppayam/images"
      }
    end

    def breadcrumbs_configuration
      {
        heading: "Manage Images",
        icon: "fa-photo",
        description: "Listing all Images",
        links: [
                  {name: "Home", link: root_path, icon: 'fa-home'}, 
                  {name: "Manage Images", link: images_path, icon: 'fa-photo', active: true}
                ]
      }
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

    def get_image_configuration
      imageable = @image.imageable
      hsh = {}
      if imageable.respond_to?(:image_configuration)
        hsh = imageable.image_configuration[@image_type]
      elsif @image.class.respond_to?(:image_configuration)
        hsh = @image.class.image_configuration
      else
        hsh = Image::Base.image_configuration  
      end
      @form_upload_image_label = hsh[:form_upload_image_label]
      @form_title = hsh[:form_title]
      @form_sub_title = hsh[:form_sub_title]
      @form_instructions = hsh[:form_instructions]
    end

  end
end
