class Event < ApplicationRecord

  # Including the State Machine Methods
  include Publishable
  include Featureable

  # Validations
  validates :title, presence: true, length: {minimum: 5, maximum: 500}, allow_blank: false
  validates :venue, length: {minimum: 3, maximum: 250}, allow_blank: true
  validates :description, presence: true
  
  # Associations
  has_one :cover_image, :as => :imageable, :dependent => :destroy, :class_name => "Image::CoverImage"
  has_many :gallery_images, :as => :imageable, :dependent => :destroy, :class_name => "Image::GalleryImage"
  has_one :brochure, :as => :documentable, :dependent => :destroy, :class_name => "Document::EventBrochure"
  
  # ------------------
  # Class Methods
  # ------------------

  scope :search, lambda { |query| where("LOWER(title) LIKE LOWER('%#{query}%') OR\
                                        LOWER(venue) LIKE LOWER('%#{query}%') OR\
                                        LOWER(description) LIKE LOWER('%#{query}%')") }

  scope :upcoming, lambda { where("starts_at >= ?", Time.now) }
  scope :past, lambda { where("starts_at < ?", Time.now) }
  
  # ------------------
  # Instance Methods
  # ------------------

  # Generic Methods
  # ---------------

  def to_param
    "#{id}-#{title.parameterize[0..32]}"
  end

  def display_name
    "#{title_was}"
  end

  def display_status
    STATUS_REVERSE[self.status]
  end

  # Permission Methods
  # ------------------

  def can_be_edited?
    status?(:published) or status?(:unpublished)
  end

  def can_be_deleted?
    status?(:removed)
  end
  
end
