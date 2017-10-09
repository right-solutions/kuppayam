FactoryGirl.define do
  
  factory :pending_classified, class: Classified do

    title "Event Title"
    description "Some Event Description"

  end

  factory :approved_classified, parent: :pending_classified do
    after :build do |e|
      e.approve
    end
  end

  factory :blocked_classified, parent: :pending_classified do
    after :build do |e|
      e.block
    end
  end

  factory :suspended_classified, parent: :pending_classified do |e|
    after :build do |e|
      e.suspend
    end
  end

  factory :removed_classified, parent: :pending_classified do |e|
    after :build do |e|
      e.remove
    end
  end

end