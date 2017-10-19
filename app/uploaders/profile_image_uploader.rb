class ProfileImageUploader < ImageUploader
	
  def store_dir
    "uploads/profile_images/#{model.id}"
  end

	version :large do
    process :resize_to_fill => [400, 400]
  end

  version :medium do
    process :resize_to_fill => [200, 200]
  end

  version :small do
    process :resize_to_fill => [100, 100]
  end

  version :tiny do
    process :resize_to_fill => [50, 50]
  end
end
