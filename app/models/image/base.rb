require 'filesize'

class Image::Base < Kuppayam::ApplicationRecord

  self.table_name = "images"
  self.inheritance_column = :image_type

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  # Validations
  validates :image, :presence => true
  validates :imageable, :presence => true
  validate :check_file_size

  # Associations
  belongs_to :imageable, :polymorphic => true  #, optional: false

  # Callbacks
  after_save :crop_image

  # ------------------
  # Class Methods
  # ------------------

  # ------------------
  # Instance Methods
  # ------------------

  def crop_image
    image.recreate_versions! if crop_x.present?
  end

  def check_file_size
    if image && image.file 
      if image.file.size.to_f > self.max_upload_limit
        errors.add(:image, "You cannot upload an image greater than #{Filesize.from(self.max_upload_limit.to_s+ " b").pretty}")
      end
      if image.file.size.to_f < self.min_upload_limit
        errors.add(:image, "You cannot upload an image lesser than #{Filesize.from(self.min_upload_limit.to_s+ " b").pretty}")
      end
    end
  end

  def display_name
    "#{id} - #{self.class.name.split('::').last.titleize}"
  end

  # Configuration
  # -------------
  def self.image_configuration
    {
      max_upload_limit: 10485760,
      min_upload_limit: 1,
      resolutions: [550, 275],
      form_upload_image_label: "Upload a new Image",
      form_title: "Upload an Image",
      form_sub_title: "Please read the instructions below:",
      form_instructions: [
        "the filename should be in .jpg / .jpeg or .png format",
        "the image resolutions should be <strong>550 x 275 Pixels</strong>",
        "the file size should be greater than 100 Kb and or lesser than <strong>10 MB</strong>",
        "Note: most cameras and camera phones will produce images bigger than this"
      ]
     }
  end

  def get_image_configuration
    imageable = self.imageable
    hsh = {}
    if imageable.respond_to?(:image_configuration)
      hsh = imageable.image_configuration[self.image_type]
    elsif self.class.respond_to?(:image_configuration)
      hsh = self.class.image_configuration
    else
      hsh = Image::Base.image_configuration  
    end
    hsh.nil? ? {} : hsh
  end

  def max_upload_limit
    get_image_configuration[:max_upload_limit]
  end

  def min_upload_limit
    get_image_configuration[:min_upload_limit]
  end

end
