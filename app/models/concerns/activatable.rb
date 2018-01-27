module Activatable
  
  extend ActiveSupport::Concern

  # Constants
  ACTIVE = "active"
  INACTIVE = "inactive"
  REMOVED = "removed"
  ARCHIVED = "archived"
  
  STATUS = {"Active" => ACTIVE, "Inactive" => INACTIVE, "Archived" => ARCHIVED, "Removed" => REMOVED}
  STATUS_REVERSE = {ACTIVE => "Active", INACTIVE => "Inactive", ARCHIVED => "Archived", REMOVED => "Removed"}
  STATUS_UI_CLASS = {ACTIVE => "success", INACTIVE => "default", ARCHIVED => "default", REMOVED => "danger"}
  STATUS_UI_ICON = {ACTIVE => "fa-check", INACTIVE => "fa-square-o", ARCHIVED => "fa-archive", REMOVED => "fa-remove"}

  included do

	  validates :status, :presence=> true, :inclusion => {:in => STATUS_REVERSE.keys, :presence_of => :status, :message => "%{value} is not a valid status" }
	  
    state_machine :status, initial: INACTIVE do
      event :publish do
	      transition [INACTIVE, ARCHIVED] => ACTIVE
	    end
	    event :unpublish do
	      transition [ACTIVE, REMOVED, ARCHIVED] => INACTIVE
	    end
	    event :remove do
	      transition [ACTIVE, INACTIVE, ARCHIVED] => REMOVED
	    end
	    event :archive do
	      transition [ACTIVE, INACTIVE, REMOVED] => ARCHIVED
	    end
    end

    scope :active, -> { where(status: ACTIVE) }
	  scope :inactive, -> { where(status: INACTIVE) }
	  scope :removed, -> { where(status: REMOVED) }
	  scope :archived, -> { where(status: ARCHIVED) }

    scope :active_and_inactive, -> { where(status: [ACTIVE, INACTIVE]) }

	  scope :status, lambda { |status| where("LOWER(status)='#{status}'") }
  end

  def display_status
    STATUS_REVERSE[self.status]
  end

end