# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
   "uploads/#{Rails.env}/#{model.class.to_s.underscore}/#{model.id}"
  end
  
  def cache_dir
   Rails.root.join 'tmp/uploads'
  end

end
