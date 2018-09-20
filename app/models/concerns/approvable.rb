module Approvable
  
  extend ActiveSupport::Concern

  # Constants
  APPROVED = "approved"
  PENDING = "pending"
  BLOCKED = "blocked"
  SUSPENDED = "suspended"
  REMOVED = "removed"
  
  STATUS = {"Approved" => APPROVED, "Pending" => PENDING, "Suspended" => SUSPENDED, "Blocked" => BLOCKED, "Removed" => REMOVED}
  STATUS_REVERSE = {APPROVED => "Approved", PENDING => "Pending", SUSPENDED => "Suspended", BLOCKED => "Blocked", REMOVED => "Removed"}
  
  included do

	  validates :status, :presence=> true, :inclusion => {:in => STATUS_REVERSE.keys, :presence_of => :status, :message => "%{value} is not a valid status" }

    state_machine :status, initial: PENDING do
      event :approve do
	      transition [PENDING, SUSPENDED] => APPROVED
	    end
	    event :pending do
	      transition [APPROVED, SUSPENDED, BLOCKED, REMOVED] => PENDING
	    end
	    event :suspend do
	      transition [APPROVED, PENDING, BLOCKED] => SUSPENDED
	    end
	    event :block do
	      transition [APPROVED, PENDING, SUSPENDED] => BLOCKED
	    end
	    event :remove do
	      transition [APPROVED, PENDING, SUSPENDED, BLOCKED] => REMOVED
	    end
    end

    scope :pending_or_approved, -> { where(status: [PENDING, APPROVED]) }
    scope :pending_or_approved_suspended_blocked, -> { where(status: [PENDING, APPROVED, SUSPENDED, BLOCKED]) }
    scope :approved, -> { where(status: APPROVED) }
	  scope :pending, -> { where(status: PENDING) }
	  scope :blocked, -> { where(status: BLOCKED) }
	  scope :suspended, -> { where(status: SUSPENDED) }
	  scope :removed, -> { where(status: REMOVED) }

	  scope :status, lambda { |status| where("LOWER(status)='#{status}'") }

  end

end