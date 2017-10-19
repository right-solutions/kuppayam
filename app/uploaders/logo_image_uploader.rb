class LogoImageUploader < ImageUploader
	
  def store_dir
    "uploads/logo_images/#{model.id}"
  end

	version :large do
    process :resize_to_fill => [750, 368]
  end

  version :medium do
    process :resize_to_fill => [550, 294]
  end

  version :small do
    process :resize_to_fill => [300, 160]
  end

  version :tiny do
    process :resize_to_fill => [100, 54]
  end
end
