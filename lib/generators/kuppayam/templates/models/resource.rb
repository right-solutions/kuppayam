class <%= model_class %> < ApplicationRecord

  # Set Table Name
  # self.table_name = "<%= table_name %>"

  # Including the State Machine Methods
  include Publishable
  include Featureable

  # Validations
  <%- fields.each do |name, type| -%>
    <%- if type == "string" -%>
  validates :<%= name %>, presence: true
    <%- elsif type == "text" -%>
  validates :<%= name %>, presence: true
    <%- elsif type == "integer" -%>
  validates :<%= name %>, presence: true, numericality: true, if: proc{|x| x.condition? }
    <%- elsif type == "decimal" || type == "float" -%>
  validates :<%= name %>, format: { with: /^\d+??(?:\.\d{0,2})?$/ },
:numericality =>{:greater_than => 0}
    <%- elsif type != "boolean" -%>
  validates :<%= name %>, presence: true
    <%- end -%>
  <%- end -%>

  # Associations
  # has_one :cover_image, :as => :imageable, :dependent => :destroy, :class_name => "Image::CoverImage"
  # has_many :gallery_images, :as => :imageable, :dependent => :destroy, :class_name => "Image::GalleryImage"

  # ------------------
  # Class Methods
  # ------------------

  scope :search, lambda {|query| where("
<% string_fields_including_main_field.each_with_index do |sfield, i| -%>
<% if string_fields_including_main_field.size - 1  != i -%>
                                            LOWER(<%= sfield %>) LIKE LOWER('%#{query}%') OR\
<% else -%>
                                            LOWER(<%= sfield %>) LIKE LOWER('%#{query}%')")
<% end -%>
<% end -%>
  }
  
  scope :upcoming, lambda { where("created_at >= ?", Time.now) }
  scope :past, lambda { where("created_at < ?", Time.now) }

  # ------------------
  # Instance variables
  # ------------------

  # Generic Methods
  # ---------------
  def to_param
    "#{id}-#{title.parameterize[0..32]}"
  end

  def display_name
    "#{title_was}"
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