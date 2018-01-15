module Publishable
  
  extend ActiveSupport::Concern

  # Constants
  PUBLISHED = "published"
  UNPUBLISHED = "unpublished"
  REMOVED = "removed"
  ARCHIVED = "archived"
  
  STATUS = {"Published" => PUBLISHED, "Unpublished" => UNPUBLISHED, "Archived" => ARCHIVED, "Removed" => REMOVED}
  STATUS_REVERSE = {PUBLISHED => "Published", UNPUBLISHED => "Unpublished", ARCHIVED => "Archived", REMOVED => "Removed"}
  STATUS_UI_CLASS = {PUBLISHED => "success", UNPUBLISHED => "default", ARCHIVED => "default", REMOVED => "danger"}
  STATUS_UI_ICON = {PUBLISHED => "fa-check", UNPUBLISHED => "fa-square-o", ARCHIVED => "fa-archive", REMOVED => "fa-remove"}

  included do

	  validates :status, :presence=> true, :inclusion => {:in => STATUS_REVERSE.keys, :presence_of => :status, :message => "%{value} is not a valid status" }
	  
    state_machine :status, initial: UNPUBLISHED do
      event :publish do
	      transition [UNPUBLISHED, ARCHIVED] => PUBLISHED
	    end
	    event :unpublish do
	      transition [PUBLISHED, REMOVED, ARCHIVED] => UNPUBLISHED
	    end
	    event :remove do
	      transition [PUBLISHED, UNPUBLISHED, ARCHIVED] => REMOVED
	    end
	    event :archive do
	      transition [PUBLISHED, UNPUBLISHED, REMOVED] => ARCHIVED
	    end
    end

    scope :published, -> { where(status: PUBLISHED) }
	  scope :unpublished, -> { where(status: UNPUBLISHED) }
	  scope :removed, -> { where(status: REMOVED) }
	  scope :archived, -> { where(status: ARCHIVED) }

	  scope :status, lambda { |status| where("LOWER(status)='#{status}'") }
  end

  def display_status
    STATUS_REVERSE[self.status]
  end

end