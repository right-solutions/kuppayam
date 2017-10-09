module ResourceHelper

  def index
    get_collections
    respond_to do |format|
      format.html {}
      format.js  { 
        js_view_path = @resource_options && @resource_options[:js_view_path] ? "#{@resource_options[:js_view_path]}/index" : :index 
        render js_view_path
      }
    end
  end

  def show
    @r_object = @resource_options[:class].find_by_id(params[:id])
    if @r_object
      instance_variable_set("@#{@resource_options[:item_name]}", @r_object)
    else
      set_notification(false, I18n.t('status.error'), I18n.t('status.not_found', item: default_item_name.titleize))
    end
    render_accordingly
  end

  def new
    @r_object = @resource_options[:class].new
    instance_variable_set("@#{@resource_options[:item_name]}", @r_object)
    render_accordingly
  end

  def edit
    @r_object = @resource_options[:class].find_by_id(params[:id])
    if @r_object
      instance_variable_set("@#{@resource_options[:item_name]}", @r_object)
    else
      set_notification(false, I18n.t('status.error'), I18n.t('status.not_found', item: default_item_name.titleize))
    end
    render_accordingly
  end

  def create
    @r_object = @resource_options[:class].new
    @r_object.assign_attributes(permitted_params)
    instance_variable_set("@#{@resource_options[:item_name]}", @r_object)
    save_resource
  end

  def update
    @r_object = @resource_options[:class].find_by_id(params[:id])
    if @r_object
      @r_object.assign_attributes(permitted_params)
      instance_variable_set("@#{@resource_options[:item_name]}", @r_object)
      if @r_object.can_be_edited?
        save_resource
      else
        message = I18n.t('errors.failed_to_update', item: default_item_name.titleize)
        @r_object.errors.add :base, message
        set_flash_message(message, :failure)
        set_notification(false, I18n.t('status.error'), message)
        render_accordingly
      end
    else
      set_notification(false, I18n.t('status.error'), I18n.t('status.not_found', item: default_item_name.titleize))
      render_accordingly
    end
  end

  def destroy
    @r_object = @resource_options[:class].find_by_id(params[:id])
    if @r_object
      instance_variable_set("@#{@resource_options[:item_name]}", @r_object)
      if @r_object.can_be_deleted?
        @r_object.destroy
        get_collections
        set_flash_message(I18n.t('success.deleted'), :success)
        set_notification(true, I18n.t('status.success'), I18n.t('success.deleted', item: default_item_name.titleize))
        @destroyed = true
      else
        message = I18n.t('errors.failed_to_delete', item: default_item_name.titleize)
        set_flash_message(message, :failure)
        set_notification(false, I18n.t('status.error'), message)
        @destroyed = false
      end
    else
      set_notification(false, I18n.t('status.error'), I18n.t('status.not_found', item: default_item_name.titleize))
    end
    
    respond_to do |format|
      format.html {}
      format.js  { 
        js_view_path = @resource_options && @resource_options[:js_view_path] ? "#{@resource_options[:js_view_path]}/destroy" : :destroy 
        render js_view_path
      }
    end

  end

  def update_status
    @r_object = @resource_options[:class].find_by_id(params[:id])
    if @r_object
      instance_variable_set("@#{@resource_options[:item_name]}", @r_object)
      @r_object.update_attribute(:status, params[:status])
      if @r_object.errors.blank?
        set_notification(true, I18n.t('status.success'), I18n.t('state.changed', item: default_item_name.titleize, new_state: @r_object.status))
      else
        set_notification(false, I18n.t('status.error'), @r_object.errors.full_messages.join("<br>"))
      end
    else
      set_notification(false, I18n.t('status.not_found'), I18n.t('status.not_found', item: default_item_name.titleize))
    end
    render_row
  end

  def mark_as_featured
    @r_object = @resource_options[:class].find_by_id(params[:id])
    if @r_object
      instance_variable_set("@#{@resource_options[:item_name]}", @r_object)
      @r_object.update_attribute(:featured, true)
      if @r_object.errors.blank?
        set_notification(true, I18n.t('status.success'), I18n.t('state.changed', item: default_item_name.titleize, new_state: :featured))
      else
        set_notification(false, I18n.t('status.error'), @r_object.errors.full_messages.join("<br>"))
      end
    else
      set_notification(false, I18n.t('status.not_found'), I18n.t('status.not_found', item: default_item_name.titleize))
    end
    render_row
  end

  def remove_from_featured
    @r_object = @resource_options[:class].find_by_id(params[:id])
    if @r_object
      instance_variable_set("@#{@resource_options[:item_name]}", @r_object)
      @r_object.update_attribute(:featured, false)
      if @r_object.errors.blank?
        set_notification(true, I18n.t('status.success'), I18n.t('state.changed', item: default_item_name.titleize, new_state: :unfeatured))
      else
        set_notification(false, I18n.t('status.error'), @r_object.errors.full_messages.join("<br>"))
      end
    else
      set_notification(false, I18n.t('status.not_found'), I18n.t('status.not_found', item: default_item_name.titleize))
    end
    render_row
  end

  private

  def set_navs
    set_nav(params[:controller])
  end

  def permitted_params
    raise "method 'permitted_params' not defined"
  end

  def default_collection_name
    begin
      params[:controller].split("/").last
    rescue
      :items
    end
  end

  def default_item_name
    default_collection_name.singularize.gsub("_", " ")
  end

  def default_class
    begin
      default_collection_name.singularize.camelize.constantize
    rescue
      nil
    end
  end

  def resource_controller_configuration
    {}
  end

  def default_resource_controller_configuration
    {
      page_title: "Page Title | Kuppayam",
      current_nav: "kuppayam/current_page",
      collection_name: default_collection_name,
      item_name: default_item_name,
      class: default_class,
      layout: :table,
      show_modal_after_create: true,
      show_modal_after_update: true,
      view_path: "/kuppayam/workflows/peacock",
      js_view_path: "/kuppayam/workflows/peacock"
    }
  end

  def configure_resource_controller
    @resource_options = resource_controller_configuration
    @resource_options.reverse_merge!(default_resource_controller_configuration)

    # Set Default Title
    set_title(@resource_options[:page_title])
    set_nav(@resource_options[:current_nav])
  end

  def prepare_query
    @relation = @resource_options[:class].where("")
    if params[:query]
      @query = params[:query].strip
      @relation = @relation.search(@query) if !@query.blank?
    end
  end

  def get_collections
    prepare_query
    @r_objects = @relation.order("created_at desc").page(@current_page).per(@per_page)
    instance_variable_set("@#{@resource_options[:collection_name]}", @r_objects)
    unless instance_variable_get("@#{@resource_options[:item_name]}")
      instance_variable_set("@#{@resource_options[:item_name]}", @r_objects.first)
    end
    return true
  end

  def resource_url(obj)
    url_for(obj)
  end

  def save_resource
    if @r_object.valid?
      @r_object.save
      get_collections if @resource_options[:layout] = :table
      set_flash_message(I18n.translate("forms.save", item: default_item_name.titleize), :success) 
    end
    set_resource_notification(@r_object)
    action_name = params[:action].to_s == "create" ? "new" : "edit"
    url = @r_object.persisted? ? resource_url(@r_object) : nil
    render_or_redirect(@r_object.errors.any?, url, action_name)
  end

end
