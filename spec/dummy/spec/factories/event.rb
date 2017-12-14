FactoryBot.define do
  
  factory :unpublished_event, class: Event do

    title "Event Title"
    venue "Venue"
    description "Some Event Description"
    
    date { Date.today }

    starts_at { Time.now - 4.hours }
    ends_at { Time.now - 1.hours }

  end

  factory :published_event, parent: :unpublished_event do
    after :build do |e|
      e.publish
    end
  end

  factory :removed_event, parent: :unpublished_event do
    after :build do |e|
      e.remove
    end
  end

  factory :archived_event, parent: :unpublished_event do |e|
    after :build do |e|
      e.archive
    end
  end

  factory :featured_event, parent: :published_event do |e|
    after :build do |e|
      e.mark_as_featured
    end
  end

  factory :non_featured_event, parent: :published_event do |e|
    after :build do |e|
      e.remove_from_featured
    end
  end
  
end