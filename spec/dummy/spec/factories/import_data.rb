FactoryBot.define do
  
  factory :import_data do
    data_type :csv
  end

  factory :event_import_data, class: "ImportData" do
    data_type :csv
    association :importable, factory: :event
    association :data, factory: :import_data_file
  end

  factory :event_oversized_import_data, class: "ImportData" do
    data_type :csv
    association :importable, factory: :event
    association :data, factory: :oversized_import_data_file
  end

  factory :event_import_report, class: "ImportData" do
    data_type :csv
    association :importable, factory: :event
    association :data, factory: :import_report_file
  end
  
end