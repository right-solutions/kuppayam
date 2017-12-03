module Readable
  
  extend ActiveSupport::Concern

  # Constants
  NEW = "new"
  UNREAD = "unread"
  READ = "read"
  ARCHIVED = "archived"
  REMOVED = "removed"
  
  STATUS = {"New" => NEW, "Unread" => UNREAD, "Read" => READ, "Archived" => ARCHIVED, "Removed" => REMOVED}
  STATUS_REVERSE = {NEW => "New", UNREAD => "Unread", READ => "Read",ARCHIVED => "Archive", REMOVED => "Trash"}
  STATUS_UI_CLASS = {NEW => "success", UNREAD => "info", READ => "default", ARCHIVED => "default", REMOVED => "danger"}

  included do

	  validates :status, :presence=> true, :inclusion => {:in => STATUS_REVERSE.keys, :presence_of => :status, :message => "%{value} is not a valid status" }
	  
    state_machine :status, initial: NEW do
      event :read do
	      transition [NEW, UNREAD] => READ
	    end
	    event :unread do
	      transition [READ, ARCHIVED, REMOVED] => UNREAD
	    end
	    event :remove do
	      transition [NEW, READ, UNREAD, ARCHIVED] => REMOVED
	    end
	    event :archive do
        transition [NEW, READ, UNREAD, REMOVED] => ARCHIVED
	    end
    end

    scope :new_ones, -> { where(status: NEW) }
    scope :read, -> { where(status: READ) }
	  scope :unread, -> { where(status: UNREAD) }
	  scope :removed, -> { where(status: REMOVED) }
	  scope :archived, -> { where(status: ARCHIVED) }

	  scope :status, lambda { |status| where("LOWER(status)='#{status}'") }
  end

  def display_status
    STATUS_REVERSE[self.status]
  end

end