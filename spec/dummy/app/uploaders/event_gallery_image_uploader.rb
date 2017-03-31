class EventGalleryImageUploader < ImageUploader
	
  def store_dir
    "uploads/event_gallery_images/#{model.id}"
  end

	version :large do
    process :resize_to_fill => [500, 500]
  end

  version :medium do
    process :resize_to_fill => [200, 200]
  end

  version :small do
    process :resize_to_fill => [140, 140]
  end

  version :tiny do
    process :resize_to_fill => [80, 80]
  end
end
