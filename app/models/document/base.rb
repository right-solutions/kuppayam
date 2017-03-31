class Document::Base < Kuppayam::ApplicationRecord

	# Constants
  UPLOAD_LIMIT = 10

  self.table_name = "documents"
  self.inheritance_column = :image_type

  # Validations
  validates :document, :presence => true
  validate :file_size

  # Associations
  belongs_to :documentable, :polymorphic => true, optional: true

  # ------------------
  # Class Methods
  # ------------------

  # return an published record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> document.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda { |query| where("LOWER(imageable_type) LIKE LOWER('%#{query}%') OR\
                                        LOWER(imageable_id) LIKE LOWER('%#{query}%')")
                        }

  # ------------------
  # Instance Methods
  # ------------------

  def file_size
    if document && document.file && document.file.size.to_f > UPLOAD_LIMIT.megabytes.to_f
      errors.add(:document, "You cannot upload a document greater than #{UPLOAD_LIMIT.to_f} MB")
    end
  end

  def display_name
    "#{id} - #{self.class.name.split('::').last.titleize}"
  end

end
