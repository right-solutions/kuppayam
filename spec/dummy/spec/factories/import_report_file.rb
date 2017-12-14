FactoryBot.define do
  
  factory :import_report_file, class: Document::ImportReportFile do
    document { Rack::Test::UploadedFile.new('spec/dummy/spec/factories/test.csv', 'text/csv') }
    association :documentable, factory: :import_data
  end
  
end