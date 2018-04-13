module Verifiable
  
  extend ActiveSupport::Concern

  # Constants
  VERIFIED = "verified"
  PENDING = "pending"
  REMOVED = "removed"
  
  STATUS = {"Approved" => VERIFIED, "Pending" => PENDING, "Removed" => REMOVED}
  STATUS_REVERSE = {VERIFIED => "Approved", PENDING => "Pending", REMOVED => "Removed"}
  
  included do

	  validates :status, :presence=> true, :inclusion => {:in => STATUS_REVERSE.keys, :presence_of => :status, :message => "%{value} is not a valid status" }

    state_machine :status, initial: PENDING do
      event :approve do
	      transition [PENDING, REMOVED] => VERIFIED
	    end
	    event :pending do
	      transition [VERIFIED, REMOVED] => PENDING
	    end
	    event :remove do
	      transition [VERIFIED, PENDING] => REMOVED
	    end
    end

    scope :verified, -> { where(status: VERIFIED) }
	  scope :pending, -> { where(status: PENDING) }
	  scope :removed, -> { where(status: REMOVED) }

	  scope :status, lambda { |status| where("LOWER(status)='#{status}'") }

  end

end