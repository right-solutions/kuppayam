FactoryGirl.define do
  
  factory :event_brochure, class: Document::EventBrochure do
    document { Rack::Test::UploadedFile.new('spec/dummy/spec/factories/brochure.pdf', 'application/pdf') }
  end

  factory :oversized_event_brochure, class: Document::EventBrochure do
    document { Rack::Test::UploadedFile.new('spec/dummy/spec/factories/oversized_brochure.pdf', 'application/pdf') }
  end
  
end