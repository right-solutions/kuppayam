FactoryGirl.define do
  
  factory :import_data_file, class: Document::ImportDataFile do
    document { Rack::Test::UploadedFile.new('spec/dummy/spec/factories/test.csv', 'text/csv') }
    association :documentable, factory: :import_data
  end
  
end