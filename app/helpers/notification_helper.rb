module NotificationHelper
  
  def default_notification_configuration
    {
      success: false,
      title: "<NOT SET>",
      message: "<NO MESSAGE SET>"
    }
  end

  def configure_notification
    if defined?(@notification)
      @notification.reverse_merge!(default_notification_configuration)
    else
      @notification = default_notification_configuration
    end
  end
  
  # This function will set a notification message depending up on the request type (ajax - xml http or direct http)
  # Example
  #   set_notification("Success", "The message has been sent successfully")
  #   set_notification("Success", "Permission denied")
  def set_notification(success, title, message)
    @notification[:success] = success
    @notification[:title] = title
    @notification[:message] = message
  end

  def set_resource_notification(obj)
    if obj.errors.any?
      @notification[:success] = false
      @notification[:title] = I18n.translate("status.error")
      @notification[:message] = obj.errors.full_messages.join("<br>")
    else
      @notification[:success] = true
      @notification[:title] = I18n.translate("status.success")
      @notification[:message] = I18n.translate("success.saved", item: default_item_name.titleize)
    end
  end

end
