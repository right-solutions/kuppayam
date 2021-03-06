require 'spec_helper'

RSpec.describe Document::ImportDataFile, type: :model do

  context "Factory" do
    it "should validate all the factories" do
      event = FactoryBot.build(:unpublished_event)
      import_data = FactoryBot.build(:import_data, importable: event)
      import_data_file = FactoryBot.build(:import_data_file, documentable: import_data)
      
      expect(event).to be_valid
      expect(import_data).to be_valid
      expect(import_data_file).to be_valid
    end
  end

  context "Validations" do
    it { should validate_presence_of :document }
    it { should validate_presence_of :documentable }

    it "should validate filesize" do
      Document::ImportDataFile # load real ActiveRecord class
      stub_const('Document::ImportDataFile::UPLOAD_LIMIT', 600)

      event = FactoryBot.build(:unpublished_event)
      import_data = FactoryBot.build(:import_data, importable: event)
      import_data_file = FactoryBot.build(:import_data_file, documentable: import_data)

      error_message = "You cannot upload a document greater than 600.00 B"
      expect(import_data_file).not_to be_valid
      expect(import_data_file.errors[:document]).to match_array([error_message])
    end
  end

end