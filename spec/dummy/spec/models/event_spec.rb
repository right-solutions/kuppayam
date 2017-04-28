require 'spec_helper'

RSpec.describe Event, type: :model do

  let(:event) {FactoryGirl.build(:event)}
  
  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryGirl.build(:event).valid?).to be true
    end
  end

  context "Validations" do
    it { should validate_presence_of :title }
    it { should allow_value('Event Title').for(:title )}
    it { should_not allow_value('EVTL').for(:title )}
    it { should_not allow_value("x"*501).for(:title )}
  end

  context "Associations" do
    it { should have_one(:cover_image) }
    it { should have_many(:gallery_images) }
  end

end