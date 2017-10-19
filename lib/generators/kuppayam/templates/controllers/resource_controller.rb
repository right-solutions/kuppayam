module Kuppayam
  class <%= controller_class -%> < ResourceController

    private

    def permitted_params
      params.require(:<%= instance_name %>).permit(<%= fields.keys.map{|x| ":" + x.downcase }.join(", ") %>)
    end

    def get_collections
      @relation = <%= model_class %>.includes(:cover_image).where("")
      params[:st] = "published" if params[:st].nil?
      parse_filters
      apply_filters
      @<%= instances_name %> = @r_objects = @relation.page(@current_page).per(@per_page)
      return true
    end

    def apply_filters
      @relation = @relation.search(@query) if @query
      @relation = @relation.status(@status) if @status
      
      @order_by = "created_at desc" unless @order_by
      @relation = @relation.order(@order_by)
    end

    def configure_filter_settings
      @filter_settings = {
        string_filters: [
          { filter_name: :query },
          { filter_name: :status }
        ],

        boolean_filters: [],

        reference_filters: [],
        variable_filters: [],
      }
    end

    def configure_filter_ui_settings
      @filter_ui_settings = {
        status: {
          object_filter: false,
          select_label: "Select Status",
          display_hash: <%= model_class %>::STATUS,
          current_value: @status,
          values: <%= model_class %>::STATUS_REVERSE,
          current_filters: @filters,
          filters_to_remove: [],
          filters_to_add: {},
          url_method_name: '<%= instances_name %>_url',
          show_all_filter_on_top: true
        }
      }
    end

    def resource_controller_configuration
      {
        page_title: "<%= model_class.pluralize.titleize %>",
        js_view_path: "/kuppayam/workflows/peacock",
        view_path: "<%= instances_name %>",
        collection_name: :<%= instances_name %>,
        item_name: :<%= instance_name %>,
        class: <%= model_class %>
      }
    end

    def breadcrumbs_configuration
      {
        heading: "Manage <%= model_class.pluralize.titleize %>",
        icon: "fa-map-marker",
        description: "Listing all <%= model_class.pluralize.titleize %>",
        links: [{name: "Dashboard", link: dashboard_path, icon: 'fa-dashboard'}, 
                  {name: "Manage <%= model_class.pluralize.titleize %>", link: dhatu.<%= instances_name %>_path, icon: 'fa-calendar', active: true}]
      }
    end

    def set_navs
      set_nav("<%= instance_name %>")
    end

  end
end
