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
  # the convention is that the there is a folder named defaults in /assets which has user-medium.png file
  # user-medium => user is the class name and medium is the size name
  # for e.g: if the class name is JackFruit, then:
  #   the filename which it expect would be /assets/defaults/jackfruit-medium.png
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
    options.reverse_merge!(size: "small")
    options.reverse_merge!(
      width: "100%",
      height: "auto",
      place_holder: {},
      class: object.persisted? ? "#{object.id}-#{options[:size]}-image" : ""
    )

    img_url = image_url(object, method_name, **options)
    return image_tag(img_url, class: options[:class], width: options[:width], height: options[:height])
  end

  # @example Basic Usage
  #
  #   >>> display_user_image(@user, 'profile_picture.image.thumb.url')
  #   "<div><div class="rounded" style="width:60px;height:60px;"><img alt="Thumb krishnan" class="" src="/uploads/image/profile_picture/39/thumb_krishnan.jpg" style="width:100%;height:auto;cursor:default;"></div></div>"
  #
  # @example Advanced Usage with
  #
  #   >>> display_user_image(@user, 'profile_picture.image.thumb.url', width: 100px, height: 100px)
  #   "<div><div class="rounded" style="width:100px;height:60px;"><img alt="Thumb krishnan" class="" src="/uploads/image/profile_picture/39/thumb_krishnan.jpg" style="width:100%;height:auto;cursor:default;"></div></div>"
  def display_user_image(user, method_name, **options)

    url_domain = defined?(QAuthRubyCustomer) ? QAuthRubyCustomer.configuration.q_auth_url : ""

    options.reverse_merge!(
      width: "60px",
      height: "auto",
      size: "medium",
      url_domain: url_domain,
      place_holder: {},
      html_options: {}
    )

    options[:html_options].reverse_merge!(
      style: "width:100%;height:auto;cursor:#{options.has_key?(:popover) ? "pointer" : "default"};",
      class: user.persisted? ? "#{user.id}-#{options[:size]}-image" : ""
    )

    if user.respond_to?(:name)
      options[:place_holder].reverse_merge!(text: namify(user.name))
    end

    options[:html_options].reverse_merge!(
      "data-toggle" => "popover",
      "data-placement" => "bottom",
      "title" => user.name,
      "data-content" => options[:popover] === true ? "" : options[:popover].to_s
    ) if options[:popover]

    begin
      image_path = user.send(:eval, method_name)
      if image_path.starts_with?(:http)
        url = image_path
      else
        url = options[:url_domain] + image_path
      end
    rescue
      url = image_url(user, method_name, **options)
    end

    content_tag(:div) do
      content_tag(:div, class: "rounded", style: "width:#{options[:width]};height:#{options[:height]}") do
        image_tag(url, options[:html_options])
      end
    end
  end

  # Displays the image with a edit button below it
  # @example Basic Usage
  #   >>> edit_image(@project, "logo.image.url", edit_url, width: "100px", height: "auto")
  #   ""
  def edit_image(object, method_name, edit_url, **options)
    options.reverse_merge!(
      remote: true,
      text: "Change Image",
      icon: "photo",
      classes: "btn btn-white btn-block btn-xs mt-10"
    )
    img_tag = display_image(object, method_name, **options)
    btn_display = raw(theme_fa_icon(options[:icon]) + theme_button_text(options[:text]))
    link_to(img_tag, edit_url, :remote => options[:remote]) +
    link_to(btn_display, edit_url, :class=>options[:classes], :remote=>options[:remote])
  end

  # Displays the user image in a rounded frame with a edit button below it
  # @example Basic Usage
  #   >>> edit_user_image(@project, "logo.image.url", edit_url, width: "100px", height: "auto")
  #   ""
  def edit_user_image(object, method_name, edit_url, **options)
    options.reverse_merge!(
      remote: true,
      text: "Change Image",
      icon: "photo",
      classes: "btn btn-default btn-xs mt-10"
    )
    img_tag = display_user_image(object, method_name, **options)
    btn_display = raw(theme_fa_icon(options[:icon]) + theme_button_text(options[:text]))
    link_to(img_tag, edit_url, :remote => options[:remote]) +
    link_to(btn_display, edit_url, :class=>options[:classes], :remote=>options[:remote])
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
    photo_object = nil
    photo_object =  object.send(assoc_name) if object.respond_to?(assoc_name)
    #binding.pry
    if photo_object.present? && photo_object.persisted?
      url_for([:edit, scope, :image, id: photo_object.id, imageable_id: object.id, imageable_type: object.class.to_s, image_type: photo_object.class.name, account_id: options[:account_id]])
    else
      photo_object = object.send("build_#{assoc_name}")
      url_for([:new, scope, :image, imageable_id: object.id, imageable_type: object.class.to_s, image_type: photo_object.class.name, account_id: options[:account_id]])
    end
  end
end
