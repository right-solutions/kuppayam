class GalleryImageUploader < ImageUploader
	
  def store_dir
    "uploads/gallery_images/#{model.id}"
  end

	version :large do
    process :resize_to_fill => [800, 400]
  end

  version :small do
    process :resize_to_fill => [140, 70]
  end
  
  version :large_square do
    process :resize_to_fill => [800, 800]
  end

  version :small_square do
    process :resize_to_fill => [140, 140]
  end
  
end
