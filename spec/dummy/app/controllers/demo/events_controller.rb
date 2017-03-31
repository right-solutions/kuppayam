module Demo
  class EventsController < Kuppayam::ResourceController

    private

    def permitted_params
      params[:event].permit(:title, :venue, :description, :date, :starts_at, :ends_at, :status, :featured)
    end

    def get_collections
      @relation = Event.includes(:cover_image).where("")
      parse_filters
      apply_filters
      @events = @r_objects = @relation.page(@current_page).per(@per_page)
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
          display_hash: Event::STATUS_HASH,
          current_value: @status,
          values: Event::STATUS_HASH_REVERSE,
          current_filters: @filters,
          filters_to_remove: [],
          filters_to_add: {},
          url_method_name: 'events_url',
          show_all_filter_on_top: true
        }
      }
    end

    def resource_controller_configuration
      {
        view_path: "/demo/events"
      }
    end

    def breadcrumbs_configuration
      {
        heading: "Manage Events",
        description: "Listing all Events",
        links: [{name: "Home", link: root_path, icon: 'fa-home'}, 
                  {name: "Manage Events", link: events_path, icon: 'fa-calendar', active: true}]
      }
    end

    def set_navs
      set_nav("demo/events")
    end

  end
end
