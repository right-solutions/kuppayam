FactoryGirl.define do
  
  factory :event do

    title "Event Title"
    venue "Venue"
    description "Some Event Description"
    
    date { Date.today }

    starts_at { Time.now - 4.hours }
    ends_at { Time.now - 1.hours }
  end

  
end