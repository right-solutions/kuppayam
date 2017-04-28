class ImportData < Kuppayam::ApplicationRecord

	# Constants
  PENDING = "pending"
  FAILED = "failed"
  SUCCEEDED = "succeeded"
  
  STATUS_HASH = {"Pending" => PENDING, "Failed" => FAILED, "Succeeded" => SUCCEEDED}
  STATUS_HASH_REVERSE = {PENDING => "Pending", FAILED => "Failed", SUCCEEDED => "Succeeded"}

  # Associations
  belongs_to :importable, :polymorphic => true  #, optional: false
  has_one :data, :as => :documentable, :dependent => :destroy, :class_name => "Document::ImportDataFile"
  has_one :report, :as => :documentable, :dependent => :destroy, :class_name => "Document::ImportReportFile"
  
  # Validations
  validates :importable, presence: true
  validates :data_type, presence: true

  # ------------------
  # Class Methods
  # ------------------

  # ------------------
  # Instance Methods
  # ------------------

  def display_name
    if self.importable
      "#{self.id} - Import Data for #{self.importable.display_name}"
    else
      "#{self.id} - Import Data (No Importable)"
    end
  end


end
