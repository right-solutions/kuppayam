require 'filesize'

class Document::Base < Kuppayam::ApplicationRecord

	# Constants
  UPLOAD_LIMIT = 5242880 # this is in bytes which is equivalent to 5 megabytes

  INSTRUCTIONS = [
    "<Override this instructions in your document class>"
  ]

  self.table_name = "documents"
  self.inheritance_column = :document_type

  # Validations
  validates :document, :presence => true
  validates :documentable, :presence => true
  validate  :check_file_size

  # Associations
  belongs_to :documentable, :polymorphic => true, optional: true

  # ------------------
  # Class Methods
  # ------------------

  # ------------------
  # Instance Methods
  # ------------------

  def check_file_size
    if document && document.file && document.file.size.to_f > self.class::UPLOAD_LIMIT
      errors.add(:document, "You cannot upload a document greater than #{Filesize.from(self.class::UPLOAD_LIMIT.to_s+ " b").pretty}")
    end
  end

  def display_name
    "#{id} - #{self.class.name.split('::').last.titleize}"
  end

end
