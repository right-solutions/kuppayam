module Kuppayam
  class DocumentsController < Kuppayam::ResourceController

    before_action :get_document_class
    before_action :get_resource

    def index
      get_collections
    end

    def show
      @document = @document_class.find(params[:id])
    end

    def new
      @document = @document_class.new
    end

    def edit
      @document = @document_class.find(params[:id])
    end

    def create
      @document = @document_class.new
      @document.documentable = @resource
      @document.document = params[:document]
      @document.save
      set_flash_message("Document has been created successfully", :success)
      render layout: "kuppayam/document_upload"
    end

    def update
      @document = @document_class.find(params[:id])
      @document.document = params[:document]
      @document.save
      set_flash_message("Document has been updated successfully", :success)
      render layout: "kuppayam/document_upload"
    end

    def crop
      @document = @document_class.find(params[:id])
      @document.assign_attributes(document_params)
      @document.document = params[:document]
      @document.save
      set_flash_message("Document has been cropped successfully", :success)
      render layout: "kuppayam/document_upload"
    end

    private

    def document_params
      params.require(:document).permit(:crop_x, :crop_y, :crop_w, :crop_h, :document)
    end

    def get_document_class
      @document_type = params[:document_type]
      @document_class = @document_type.constantize if @document_type
    end

    def get_resource
      @resource = params[:documentable_type].constantize.find(params[:documentable_id]) if params[:documentable_type] && params[:documentable_id]
    end

    def save_document
      @document = @document_class.new
      @document.documentable = @resource
      @document.document = params[:document][:document]
      @document.save
    end

    def get_collections
      @relation = Document::Base.where("")
      parse_filters
      apply_filters
      @documents = @relation.page(@current_page).per(@per_page)
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
