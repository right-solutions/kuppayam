module DocumentHelper

  # Returns new associated url or edit existing associated url based on object is associated with associated or not
  # @example Basic Usage - User without Image
  #   >>> upload_document_link(@user, :profile_picture, :admin)
  #   "/admin/documents/new"
  #
  # @example Basic Usage - User with Iamge
  #
  #   >>> upload_document_link(@user_with_document, :profile_picture, :admin)
  #   "/admin/documents/1/edit"
  #
  # @example Basic Usage - Custom Scope
  #
  #   >>> upload_document_link(@project, :profile_picture, :customer)
  #   "/customer/documents/new"
  #   >>> upload_document_link(@project_with_document, :profile_picture, :customer)
  #   "/customer/documents/1/edit"
  def upload_document_link(object, assoc_name=:associated, scope=:admin, **options)
    associated_object = nil
    associated_object =  object.send(assoc_name) if object.respond_to?(assoc_name)
    if associated_object.present? && associated_object.persisted?
      main_app.url_for([:edit, scope, :document, id: associated_object.id, documentable_id: object.id, documentable_type: object.class.to_s, document_type: associated_object.class.name])
    else
      associated_object = object.send("build_#{assoc_name}")
      main_app.url_for([:new, scope, :document, documentable_id: object.id, documentable_type: object.class.to_s, document_type: associated_object.class.name])
    end
  end

  def import_data_link(object, class_name, assoc_name=:associated, scope=nil, **options)
    if object.present?
      #main_app.url_for([:edit, scope, :import_data, data_type: class_name])
      edit_import_data_url(object, data_type: class_name)
    else
      #main_app.url_for([:new, scope, :import_data, data_type: class_name])
      new_import_data_url(data_type: class_name)
    end
  end

end
