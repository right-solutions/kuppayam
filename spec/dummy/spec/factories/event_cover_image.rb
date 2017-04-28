FactoryGirl.define do
  
  factory :event_cover_image, class: Image::EventCoverImage do
    image { Rack::Test::UploadedFile.new('spec/dummy/spec/factories/test.jpg', 'image.png') }
    association :imageable, factory: :event
  end

  factory :oversized_event_cover_image, class: Image::EventCoverImage do
    image { Rack::Test::UploadedFile.new('spec/dummy/spec/factories/test.jpg', 'image.png') }
    association :imageable, factory: :event
  end
  
end