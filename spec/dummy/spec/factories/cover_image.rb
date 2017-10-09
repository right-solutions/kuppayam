FactoryGirl.define do
  
  factory :cover_image, class: Image::CoverImage do
    image { Rack::Test::UploadedFile.new('spec/dummy/spec/factories/test.jpg', 'image.png') }
  end

  factory :oversized_cover_image, class: Image::CoverImage do
    image { Rack::Test::UploadedFile.new('spec/dummy/spec/factories/test.jpg', 'image.png') }
  end

  factory :event_cover_image, parent: :cover_image do
    association :imageable, factory: :unpublished_event
  end

  factory :oversized_event_cover_image, parent: :oversized_cover_image do
    association :imageable, factory: :unpublished_event
  end
  
end