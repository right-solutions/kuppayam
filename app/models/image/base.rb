class Image::Base < Kuppayam::ApplicationRecord

  # Constants
  UPLOAD_LIMIT = 1048576 # this is in bytes which is equivalent to 1 megabyte

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
    if image && image.file && image.file.size.to_f > self.class::UPLOAD_LIMIT
      errors.add(:image, "You cannot upload an image greater than #{Filesize.from(self.class::UPLOAD_LIMIT.to_s+ " b").pretty}")
    end
  end

  def display_name
    "#{id} - #{self.class.name.split('::').last.titleize}"
  end

end
