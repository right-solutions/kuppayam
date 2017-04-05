# encoding: utf-8

class DocumentUploader < CarrierWave::Uploader::Base

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
   "#{Rails.root}/uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  def cache_dir
   Rails.root.join 'tmp/uploads'
  end

end
