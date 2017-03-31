class ImportData < Kuppayam::ApplicationRecord

	# Constants
  PENDING = "pending"
  FAILED = "failed"
  SUCCEEDED = "succeeded"
  
  STATUS_HASH = {"Pending" => PENDING, "Failed" => FAILED, "Succeeded" => SUCCEEDED}
  STATUS_HASH_REVERSE = {PENDING => "Pending", FAILED => "Failed", SUCCEEDED => "Succeeded"}

  # Associations
  has_one :data, :as => :documentable, :dependent => :destroy, :class_name => "Document::ImportData"
  has_one :report, :as => :documentable, :dependent => :destroy, :class_name => "Document::ImportReport"
  
  # Validations
  validates :data_type, presence: true



end
