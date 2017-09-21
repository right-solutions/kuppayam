class ActiveSupport::TimeWithZone
  def as_json(options = {})
    strftime('%d-%m-%Y %H:%M:%S')
  end
end

class Date
  def as_json(options = nil) #:nodoc:
  	strftime("%d-%m-%Y")
  end
end