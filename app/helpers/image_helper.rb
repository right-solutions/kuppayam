module ImageHelper

  # namify returns the first letters of first name and last name
  # @examples Basic usage
  #
  #   >>> namify("Krishnaprasad Varma")
  #   => "KV"
  def namify(name)
    name.split(" ").map{|x| x.first.capitalize}[0..1].join("")
  end

  # placeholdit is a helper method used to return placechold.it urls with custom width, height and text
  # It is quite useful for POC Applications to get started with place holder images while developing views
  #
  # @example Without Any Arguments
  #
  #   >>> placeholdit()
  #   "http://placehold.it/60x60&text=<No Image>"
  #
  # @example With width, height and custom text
  #
  #   >>> placeholdit(width: 120, height: 80, text: "User")
  #   "http://placehold.it/120x80&text=User"
  def placeholdit(**options)
    options.reverse_merge!( width: 60, height:  60, text: "<No Image>" )
    "http://placehold.it/#{options[:width]}x#{options[:height]}&text=#{options[:text]}"
  end

  # image_url is a helper method which can be used along with carrier_wave gem
  # Suppose, you have an object 'user' which has a profile_picture
  # image_url will return you the system default image url if profile_picture is not set else it will return you the carrier wave url
  # the convention is that the there is a folder named defaults in /assets which has user-small.png file
  # user-small => user is the class name and small is the size name
  # for e.g: if the class name is JackFruit, then:
  #   the filename which it expect would be /assets/defaults/jackfruit-small.png
  #
  # @example Basic Usage without Image
  #
  #   >>> image_url(user, "profile_picture.image.thumb.url")
  #   "/assets/defaults/user-thumb.png"
  #
  # @example Basic Usage with Image
  #
  #   >>> image_url(user_with_image, "profile_picture.image.thumb.url")
  #   "uploads/profile_picture/image/1/thumb_test.jpg"
  #
  # @example Advance Usage with Placehold.it Arguments
  #
  #   >>> image_url(user, "profile_picture.image.large.url", {width: 40, height: 10, text: "Pic"})
  #   "/assets/defaults/user-large.png"
  def image_url(object, method_name, **options)
    begin
      url = object.send :eval, method_name
      raise if url.blank?
    rescue
      options.reverse_merge!(size: "small")
      url = object.respond_to?(:default_image_url) ? object.default_image_url(options[:size]) : "/assets/kuppayam/defaults/default-#{options[:size]}.png"
    end
    return url
  end

  # This method will render the image with required width and height.
  # The image url will be set to the placeholder url if the object doesn't respond to the image method
  #
  # @example Basic Usage without Image
  #
  #   >>> display_image(user, "profile_picture.image.thumb.url")
  #   "<img class=\"\" width=\"100%\" height=\"auto\" src=\"http://placehold.it/100x60&amp;text=&lt;No Image&gt;\" alt=\"100x60&amp;text=&lt;no image&gt;\" />"
  #
  # @example Basic Usage with image
  #
  #   >>> display_image(user, "profile_picture.image.thumb.url", width: "100%", height:"100%")
  #   "<img class=\"\" width=\"100%\" height=\"100%\" src=\"http://placehold.it/100x60&amp;text=&lt;No Image&gt;\" alt=\"100x60&amp;text=&lt;no image&gt;\" />"
  #
  # @example Advanced Usage with width & height
  #
  #   >>> display_image(user_with_image, 'profile_picture.image.large.url', width: "30px", height: "50px", size: "small")
  #   "<img class=\"\" width=\"30px\" height=\"50px\" src=\"/spec/dummy/uploads/image/profile_picture/1/large_test.jpg\" alt=\"Large test\" />"
  def display_image(object, method_name, **options)
    options.reverse_merge!(size: "large")
    options.reverse_merge!(
      width: "100%",
      height: "auto",
      place_holder: {},
      class: "",
      alt: ""
    )

    options[:class] = options[:class] + (object.persisted? ? " #{object.id}-#{options[:size]}-image" : "")

    img_url = image_url(object, method_name, **options)
    return image_tag(img_url, class: options[:class], width: options[:width], height: options[:height], alt: options[:alt])
  end

  # Displays the image with a edit button below it
  # @example Basic Usage
  #   >>> edit_image(@project, "logo.image.url", edit_url, width: "100px", height: "auto")
  #   ""
  def edit_image(object, method_name, edit_url, delete_url, **options)
    options.reverse_merge!(
      image_options: {},
      edit_options: {},
      delete_options: {}
    )

    # options[:image_options].reverse_merge!()
    options[:edit_options].reverse_merge!(
      remote: true,
      text: "Change",
      icon: "photo",
      class: "btn btn-primary btn-block btn-only-hover btn-xs",
    )

    options[:delete_options].reverse_merge!(
      remote: true,
      text: "Remove",
      icon: "trash",
      class: "btn btn-danger btn-block btn-only-hover btn-xs"
    )

    # Image HTML    
    image_tag = display_image(object, method_name, **options[:image_options])

    # Edit Button
    edit_btn_display = raw(theme_fa_icon(options[:edit_options][:icon]) + theme_button_text(options[:edit_options][:text]))
    edit_btn = link_to(edit_btn_display, edit_url, :class=>options[:edit_options][:class], :remote=>options[:edit_options][:remote])

    # Remove Button (only if the object is persisted)
    assoc_name = options[:image_options][:assoc_name]
    image_object = nil
    image_object =  object.send(assoc_name) if object.respond_to?(assoc_name)
    if image_object && image_object.persisted?
      remove_btn_display = raw(theme_fa_icon(options[:delete_options][:icon]) + theme_button_text(options[:delete_options][:text]))
      remove_btn = link_to(remove_btn_display, delete_url, :class=>options[:delete_options][:class], :remote=>options[:delete_options][:remote], method: :delete)
    end

    link_to(image_tag, edit_url, :remote => options[:edit_options][:remote]) +
    content_tag(:div, class: "btn-group btn-group-justified mt-30") do
      edit_btn + (object.persisted? ? remove_btn : "")
    end
  end

  # Returns new photo url or edit existing photo url based on object is associated with photo or not
  # @example Basic Usage - User without Image
  #   >>> upload_image_link(@user, :profile_picture, :admin)
  #   "/admin/images/new"
  #
  # @example Basic Usage - User with Iamge
  #
  #   >>> upload_image_link(@user_with_image, :profile_picture, :admin)
  #   "/admin/images/1/edit"
  #
  # @example Basic Usage - Custom Scope
  #
  #   >>> upload_image_link(@project, :profile_picture, :customer)
  #   "/customer/images/new"
  #   >>> upload_image_link(@project_with_image, :profile_picture, :customer)
  #   "/customer/images/1/edit"
  def upload_image_link(object, assoc_name=:photo, scope=:admin, **options)
    image_object = nil
    image_object =  object.send(assoc_name) if object.respond_to?(assoc_name)
    if image_object.present? && image_object.persisted?
      main_app.url_for([:edit, scope, :image, id: image_object.id, imageable_id: object.id, imageable_type: object.class.to_s, image_type: image_object.class.name])
    else
      image_object = object.send("build_#{assoc_name}")
      main_app.url_for([:new, scope, :image, imageable_id: object.id, imageable_type: object.class.to_s, image_type: image_object.class.name])
    end
  end

  def upload_multiple_image_link(object, assoc_name=:photo, scope=:admin, **options)
    image_object = object.class.new.send("#{assoc_name}").build
    main_app.url_for([:new, scope, :image, imageable_id: object.id, imageable_type: object.class.to_s, image_type: image_object.class.name, multiple: true])
  end

  def remove_image_link(object, assoc_name=:photo, scope=:admin, **options)
    image_object = nil
    image_object =  object.send(assoc_name) if object.respond_to?(assoc_name)
    if image_object.persisted?
      main_app.url_for([scope, :image, id: image_object.id, imageable_id: object.id, imageable_type: object.class.to_s, image_type: image_object.class.name])
    else
      "#"
    end
  end
end
