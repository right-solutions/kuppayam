class <%= model_class %> < ActiveRecord::Base

  # Validations
  <%- fields.each do |name, type| -%>
    <%- if type == "string" %>
  #validates :<%= name %>, presence: true
    <%- elsif type == "text" %>
  #validates :<%= name %>, presence: true
    <%- elsif type == "integer" %>
  #validates :<%= name %>, presence: true, numericality: true, if: proc{|x| x.condition? }
    <%- elsif type == "decimal" || type == "float" %>
  #validates :<%= name %>, format: { with: /^\d+??(?:\.\d{0,2})?$/ },
:numericality =>{:greater_than => 0}
    <%- elsif type != "boolean" %>
  #validates :<%= name %>, presence: true
    <%- end -%>
  <%- end -%>

  # Validation Examples
  #LANDLINE_LIST = ["1234567890", "0987654321"]
  #validates :first_name,
  #           presence: true,
  #           length: {minimum: ConfigCenter::GeneralValidations::FIRST_NAME_MIN_LEN ,
  #           maximum: ConfigCenter::GeneralValidations::FIRST_NAME_MAX_LEN, message: "should be less than x and greater than y"},
  #           uniqueness: {scope: [:user_id, :status], case_sensitive: false},
  #           format: {with: ConfigCenter::GeneralValidations::FIRST_NAME_FORMAT_REG_EXP, message: "Invalid format"},
  #           inclusion: { in: PHONE_LIST, message: "not included in the list" },
  #           unless: proc{|user| user.password.blank? }


  # Associations
  #belongs_to :user, foreign_key: :owner_id
  #has_many :products

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> <%= instance_name %>.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| where("
<% string_fields_including_main_field.each_with_index do |sfield, i| -%>
<% if string_fields_including_main_field.size - 1  != i -%>
                                            LOWER(<%= sfield %>) LIKE LOWER('%#{query}%') OR\
<% else -%>
                                            LOWER(<%= sfield %>) LIKE LOWER('%#{query}%')")
<% end -%>
<% end -%>
                        }

end