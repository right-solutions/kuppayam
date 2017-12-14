require 'spec_helper'

RSpec.describe Event, type: :model do

  let(:published_event) {FactoryBot.create(:published_event)}
  let(:unpublished_event) {FactoryBot.create(:unpublished_event)}
  let(:removed_event) {FactoryBot.create(:removed_event)}
  let(:archived_event) {FactoryBot.create(:archived_event)}
  let(:featured_event) {FactoryBot.create(:featured_event)}
  let(:non_featured_event) {FactoryBot.create(:non_featured_event)}
  
  context "Factory" do
    it "should validate all the factories" do
      expect(published_event.valid?).to be true
      expect(unpublished_event.valid?).to be true
      expect(removed_event.valid?).to be true
      expect(archived_event.valid?).to be true

      expect(featured_event.valid?).to be true
      expect(non_featured_event.valid?).to be true

      expect(published_event.status?(:published)).to be_truthy
      expect(published_event.published?).to be_truthy

      expect(unpublished_event.status?(:unpublished)).to be_truthy
      expect(unpublished_event.unpublished?).to be_truthy

      expect(removed_event.status?(:removed)).to be_truthy
      expect(removed_event.removed?).to be_truthy

      expect(archived_event.status?(:archived)).to be_truthy
      expect(archived_event.archived?).to be_truthy

      expect(featured_event.featured).to be_truthy
      expect(non_featured_event.featured).to be_falsy
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