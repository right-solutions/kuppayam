# encoding: utf-8

class ImportDataUploader < CarrierWave::Uploader::Base

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
  	"#{Rails.root}/uploads/import_data/#{model.id}"
  end

  def cache_dir
  	Rails.root.join 'tmp/import_data'
  end

end
