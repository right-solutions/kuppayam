require 'spec_helper'

RSpec.describe ImportData, type: :model do

  context "Factory" do
    it "should validate all the factories" do
      event = FactoryGirl.build(:unpublished_event)
      import_data = FactoryGirl.build(:import_data, importable: event)
      expect(import_data).to be_valid
    end
  end

  context "Validations" do
    it { should validate_presence_of :importable }
    it { should validate_presence_of :data_type }
  end

end