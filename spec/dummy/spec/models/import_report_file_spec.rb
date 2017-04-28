require 'spec_helper'

RSpec.describe Document::ImportReportFile, type: :model do

  context "Factory" do
    it "should validate all the factories" do
      event = FactoryGirl.build(:event)
      import_data = FactoryGirl.build(:import_data, importable: event)
      import_report_file = FactoryGirl.build(:import_report_file, documentable: import_data)
      expect(event).to be_valid
      expect(import_data).to be_valid
      expect(import_report_file).to be_valid
    end
  end

  context "Validations" do
    it { should validate_presence_of :document }
    it { should validate_presence_of :documentable }

    it "should validate filesize" do
      Document::ImportReportFile # load real ActiveRecord class
      stub_const('Document::ImportReportFile::UPLOAD_LIMIT', 600)

      event = FactoryGirl.build(:event)
      import_data = FactoryGirl.build(:import_data, importable: event)
      import_report_file = FactoryGirl.build(:import_report_file, documentable: import_data)

      error_message = "You cannot upload a document greater than 600.00 B"
      expect(import_report_file).not_to be_valid
      expect(import_report_file.errors[:document]).to match_array([error_message])
    end
  end

end