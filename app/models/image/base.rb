class Image::Base < Kuppayam::ApplicationRecord

  # Constants
  UPLOAD_LIMIT = 1

  self.table_name = "images"
  self.inheritance_column = :image_type

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  # Validations
  validates :image, :presence => true
  validate :file_size

  # Associations
  belongs_to :imageable, :polymorphic => true  #, optional: false

  # Callbacks
  after_save :crop_image

  # ------------------
  # Class Methods
  # ------------------

  # return an published record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> image.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda { |query| where("LOWER(imageable_type) LIKE LOWER('%#{query}%') OR\
                                        LOWER(imageable_id) LIKE LOWER('%#{query}%')")
                        }

  # ------------------
  # Instance Methods
  # ------------------

  def crop_image
    image.recreate_versions! if crop_x.present?
  end

  def file_size
    if image && image.file && image.file.size.to_f > UPLOAD_LIMIT.megabytes.to_f
      errors.add(:image, "You cannot upload an image greater than #{UPLOAD_LIMIT.to_f} MB")
    end
  end

  def display_name
    "#{id} - #{self.class.name.split('::').last.titleize}"
  end

end
