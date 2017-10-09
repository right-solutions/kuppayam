module Featureable
  
  extend ActiveSupport::Concern

  # Constants
  FEATURED = {"Featured" => true, "Non Featured" => false}
	FEATURED_REVERSE = {true => "Featured", false => "Non Featured"}
	
  included do

  	scope :featured, lambda { |val| where(featured: val) }

	  def mark_as_featured
	  	self.update_attribute(:featured, true)
	  end

	  def remove_from_featured
	  	self.update_attribute(:featured, false)
	  end

  end

end