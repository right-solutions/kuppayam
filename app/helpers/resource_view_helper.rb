module ResourceViewHelper

	def edit_link(object)
		url_for(action: 'edit', controller: object.class.to_s.tableize, id: object.id)
	end

	def delete_link(object)
		url_for(action: 'destroy', controller: object.class.to_s.tableize, id: object.id)
	end

  def serial_number(i)
    if i < 0
      raw(content_tag(:i, "", class: "fa fa-check text-success"))
    else
      raw(i + 1 + (@per_page.to_i * (@current_page.to_i - 1)))
    end
  end

	def display_thumbnail_small(object)
    url = url_for(action: 'show', controller: object.class.to_s.tableize, id: object.id)
    link_to(url, remote: true) do
      raw(display_image(object, "cover_image.image.small.url", width: "120", height: "auto", class: "img-rectangle", alt: object.display_name))
    end
  end

	def display_featured(object, **options)
    options.reverse_merge!(
      span_class: 'ml-5 mt-5 label',
    )
    if object.featured?
      content_tag(:span, "Featured", class: "#{options[:span_class]} label-warning")
    else
      content_tag(:span, "Not Featured", class: "#{options[:span_class]} label-default")
    end
  end

	def display_publishable_status(object, **options)
		options.reverse_merge!(
      span_class: 'ml-5 mt-5 label',
    )
    label_class = Publishable::STATUS_UI_CLASS[object.status]
		content_tag(:span, object.display_status, class: "#{options[:span_class]} label-#{label_class}")
	end

  def display_publishable_links(object, **options)
		options.reverse_merge!(
        publish_icon: 'fa fa-check-square',
        unpublish_icon: 'fa fa-square',
        remove_icon: 'fa fa-close',
        archive_icon: 'fa fa-archive',
        
        publish_link: url_for(action: 'update_status', controller: object.class.to_s.tableize, id: object.id, status: "published"),
        unpublish_link: url_for(action: 'update_status', controller: object.class.to_s.tableize, id: object.id, status: "unpublished"),
        remove_link: url_for(action: 'update_status', controller: object.class.to_s.tableize, id: object.id, status: "removed"),
        archive_link: url_for(action: 'update_status', controller: object.class.to_s.tableize, id: object.id, status: "archived"),
        
        publish_text: "Publish",
        unpublish_text: "UnPublish",
        remove_text: "Remove",
        archive_text: "Archive",
        
        publish_class: "edit",
        unpublish_class: "",
        remove_class: "delete",
        archive_class: ""
    )
		links = []
    links << link_to(raw("<i class=\"#{options[:publish_icon]} mr-5\"></i> #{options[:publish_text]}"), options[:publish_link], method: 'PUT', remote: true, role: "menuitem", tabindex: "-1", class: options[:publish_class]) if object.can_publish?
    links << link_to(raw("<i class=\"#{options[:unpublish_icon]} mr-5\"></i> #{options[:unpublish_text]}"), options[:unpublish_link], method: 'PUT', remote: true, role: "menuitem", tabindex: "-1", class: options[:unpublish_class]) if object.can_unpublish?
    links << link_to(raw("<i class=\"#{options[:remove_icon]} mr-5\"></i> #{options[:remove_text]}"), options[:remove_link], method: 'PUT', remote: true, role: "menuitem", tabindex: "-1", class: options[:remove_class]) if object.can_remove?
    links << link_to(raw("<i class=\"#{options[:archive_icon]} mr-5\"></i> #{options[:archive_text]}"), options[:archive_link], method: 'PUT', remote: true, role: "menuitem", tabindex: "-1", class: options[:archive_class]) if object.can_archive?
    raw(links.join(""))
  end

  def display_featurable_links(object, **options)
    options.reverse_merge!(
        feature_icon: 'fa fa-star',
        unfeature_icon: 'fa fa-star-o',
        
        feature_link: url_for(action: 'mark_as_featured', controller: object.class.to_s.tableize, id: object.id),
        unfeature_link: url_for(action: 'remove_from_featured', controller: object.class.to_s.tableize, id: object.id),
        
        feature_text: "Mark as Featured",
        unfeature_text: "Remove from Featured",
        
        feature_class: "edit",
        unfeature_class: "delete"
    )
    links = []
    links << link_to(raw("<i class=\"#{options[:feature_icon]} mr-5\"></i> #{options[:feature_text]}"), options[:feature_link], method: 'PUT', remote: true, role: "menuitem", tabindex: "-1", class: options[:feature_class]) unless object.featured?
    links << link_to(raw("<i class=\"#{options[:unfeature_icon]} mr-5\"></i> #{options[:unfeature_text]}"), options[:unfeature_link], method: 'PUT', remote: true, role: "menuitem", tabindex: "-1", class: options[:unfeature_class]) if object.featured?
    raw(links.join(""))
  end

  def display_manage_links(object, **options)
  	options.reverse_merge!(
        edit_icon: 'fa fa-edit',
        delete_icon: 'fa fa-trash',
        
        edit_link: url_for(action: "edit", controller: object.class.to_s.tableize, id: object.id),
        delete_link: url_for(action: "destroy", controller: object.class.to_s.tableize, id: object.id),
        
        edit_text: "Edit",
        delete_text: "Delete",
        
        edit_class: "edit",
        delete_class: ""
      )
		links = []
    links << link_to(raw("<i class=\"#{options[:edit_icon]} mr-5\"></i> #{options[:edit_text]}"), options[:edit_link], remote: true, role: "menuitem", tabindex: "-1", class: options[:edit_class]) if object.can_be_edited?
    links << link_to(raw("<i class=\"#{options[:delete_icon]} mr-5\"></i> #{options[:delete_text]}"), options[:delete_link], method: 'DELETE', remote: true, role: "menuitem", tabindex: "-1", class: options[:delete_class]) if object.can_be_deleted?
    raw(links.join(""))
  end

  def display_publishable_buttons(object, **options)
    options.reverse_merge!(
        publish_icon: 'fa fa-check-square',
        unpublish_icon: 'fa fa-square',
        remove_icon: 'fa fa-close',
        archive_icon: 'fa fa-archive',
        
        publish_link: url_for(action: 'update_status', controller: object.class.to_s.tableize, id: object.id, status: "published"),
        unpublish_link: url_for(action: 'update_status', controller: object.class.to_s.tableize, id: object.id, status: "unpublished"),
        remove_link: url_for(action: 'update_status', controller: object.class.to_s.tableize, id: object.id, status: "removed"),
        archive_link: url_for(action: 'update_status', controller: object.class.to_s.tableize, id: object.id, status: "archived"),
        
        publish_text: "Publish",
        unpublish_text: "UnPublish",
        remove_text: "Remove",
        archive_text: "Archive",
        
        publish_class: "btn btn-block btn-success btn-only-hover",
        unpublish_class: "btn btn-block btn-gray btn-only-hover",
        remove_class: "btn btn-block btn-danger btn-only-hover",
        archive_class: "btn btn-block btn-gray btn-only-hover"
    )
    links = []
    links << link_to(raw("<i class=\"#{options[:publish_icon]} mr-5\"></i> #{options[:publish_text]}"), options[:publish_link], method: 'PUT', remote: true, role: "menuitem", tabindex: "-1", class: options[:publish_class]) if object.can_publish?
    links << link_to(raw("<i class=\"#{options[:unpublish_icon]} mr-5\"></i> #{options[:unpublish_text]}"), options[:unpublish_link], method: 'PUT', remote: true, role: "menuitem", tabindex: "-1", class: options[:unpublish_class]) if object.can_unpublish?
    links << link_to(raw("<i class=\"#{options[:remove_icon]} mr-5\"></i> #{options[:remove_text]}"), options[:remove_link], method: 'PUT', remote: true, role: "menuitem", tabindex: "-1", class: options[:remove_class]) if object.can_remove?
    links << link_to(raw("<i class=\"#{options[:archive_icon]} mr-5\"></i> #{options[:archive_text]}"), options[:archive_link], method: 'PUT', remote: true, role: "menuitem", tabindex: "-1", class: options[:archive_class]) if object.can_archive?
    raw(links.join(""))
  end

  def display_featurable_buttons(object, **options)
    options.reverse_merge!(
        feature_icon: 'fa fa-star',
        unfeature_icon: 'fa fa-star-o',
        
        feature_link: url_for(action: 'mark_as_featured', controller: object.class.to_s.tableize, id: object.id),
        unfeature_link: url_for(action: 'remove_from_featured', controller: object.class.to_s.tableize, id: object.id),
        
        feature_text: "Mark as Featured",
        unfeature_text: "Remove from Featured",
        
        feature_class: "btn btn-block btn-success btn-only-hover",
        unfeature_class: "btn btn-block btn-danger btn-only-hover"
    )
    links = []
    links << link_to(raw("<i class=\"#{options[:feature_icon]} mr-5\"></i> #{options[:feature_text]}"), options[:feature_link], method: 'PUT', remote: true, role: "menuitem", tabindex: "-1", class: options[:feature_class]) unless object.featured?
    links << link_to(raw("<i class=\"#{options[:unfeature_icon]} mr-5\"></i> #{options[:unfeature_text]}"), options[:unfeature_link], method: 'PUT', remote: true, role: "menuitem", tabindex: "-1", class: options[:unfeature_class]) if object.featured?
    raw(links.join(""))
  end

  def display_manage_buttons(object, **options)
    options.reverse_merge!(
        edit_icon: 'fa fa-edit',
        delete_icon: 'fa fa-trash',
        
        edit_link: url_for(action: "edit", controller: object.class.to_s.tableize, id: object.id),
        delete_link: url_for(action: "destroy", controller: object.class.to_s.tableize, id: object.id),
        
        edit_text: "Edit",
        delete_text: "Delete",
        
        edit_class: "btn btn-block btn-success",
        delete_class: "btn btn-block btn-danger btn-only-hover"
      )
    links = []
    links << link_to(raw("<i class=\"#{options[:edit_icon]} mr-5\"></i> #{options[:edit_text]}"), options[:edit_link], remote: true, role: "menuitem", tabindex: "-1", class: options[:edit_class]) if object.can_be_edited?
    links << link_to(raw("<i class=\"#{options[:delete_icon]} mr-5\"></i> #{options[:delete_text]}"), options[:delete_link], method: 'DELETE', remote: true, role: "menuitem", tabindex: "-1", class: options[:delete_class]) if object.can_be_deleted?
    raw(links.join(""))
  end
end
