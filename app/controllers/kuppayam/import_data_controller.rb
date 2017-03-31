module Kuppayam
  class ImportDataController < Kuppayam::ResourceController

    private

    def permitted_params
      params.require(:document).permit(:document)
    end

    def get_collections
      @relation = ImportData.where("")
      @events = @relation.page(@current_page).per(@per_page)
      return true
    end

    def resource_url(obj)
      import_data_url(obj)
    end

    def configure_resource_controller
      @resource_options = {
        collection_name: :import_datas,
        item_name: :import_data,
        class: ImportData
      }
      super
    end

    def set_navs
      set_nav("import_data")
    end

  end
end
