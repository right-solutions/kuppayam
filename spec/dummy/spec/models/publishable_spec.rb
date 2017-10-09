require 'spec_helper'

RSpec.describe Event, type: :model do

  let(:published_event) {FactoryGirl.create(:published_event)}
  let(:unpublished_event) {FactoryGirl.create(:unpublished_event)}
  let(:removed_event) {FactoryGirl.create(:removed_event)}
  let(:archived_event) {FactoryGirl.create(:archived_event)}
  
  context "Publishable" do
    it "should publish" do
      expect(unpublished_event.publish).to be_truthy
      expect(unpublished_event.status?(:published)).to be_truthy
      expect(unpublished_event.published?).to be_truthy

      expect(archived_event.publish).to be_truthy
      expect(archived_event.status?(:published)).to be_truthy
      expect(archived_event.published?).to be_truthy

      expect(removed_event.publish).to be_falsy
      expect(removed_event.status?(:removed)).to be_truthy
      expect(removed_event.removed?).to be_truthy

      expect(published_event.publish).to be_falsy
    end

    it "should unpublish" do
      expect(published_event.unpublish).to be_truthy
      expect(published_event.status?(:unpublished)).to be_truthy
      expect(published_event.unpublished?).to be_truthy

      expect(archived_event.unpublish).to be_truthy
      expect(archived_event.status?(:unpublished)).to be_truthy
      expect(archived_event.unpublished?).to be_truthy

      expect(removed_event.unpublish).to be_truthy
      expect(removed_event.status?(:unpublished)).to be_truthy
      expect(removed_event.unpublished?).to be_truthy

      expect(unpublished_event.unpublish).to be_falsy
    end

    it "should remove" do
      expect(published_event.remove).to be_truthy
      expect(published_event.status?(:removed)).to be_truthy
      expect(published_event.removed?).to be_truthy

      expect(unpublished_event.remove).to be_truthy
      expect(unpublished_event.status?(:removed)).to be_truthy
      expect(unpublished_event.removed?).to be_truthy

      expect(archived_event.remove).to be_truthy
      expect(archived_event.status?(:removed)).to be_truthy
      expect(archived_event.removed?).to be_truthy

      expect(removed_event.remove).to be_falsy
    end

    it "should archive" do
      expect(published_event.archive).to be_truthy
      expect(published_event.status?(:archived)).to be_truthy
      expect(published_event.archived?).to be_truthy

      expect(unpublished_event.archive).to be_truthy
      expect(unpublished_event.status?(:archived)).to be_truthy
      expect(unpublished_event.archived?).to be_truthy

      expect(removed_event.archive).to be_truthy
      expect(removed_event.status?(:archived)).to be_truthy
      expect(removed_event.archived?).to be_truthy

      expect(archived_event.archive).to be_falsy
    end

    it "should check if possible to change status" do
      expect(published_event.can_publish?).to be_falsy
      expect(published_event.can_unpublish?).to be_truthy
      expect(published_event.can_remove?).to be_truthy
      expect(published_event.can_archive?).to be_truthy

      expect(unpublished_event.can_publish?).to be_truthy
      expect(unpublished_event.can_unpublish?).to be_falsy
      expect(unpublished_event.can_remove?).to be_truthy
      expect(unpublished_event.can_archive?).to be_truthy

      expect(removed_event.can_publish?).to be_falsy
      expect(removed_event.can_unpublish?).to be_truthy
      expect(removed_event.can_remove?).to be_falsy
      expect(removed_event.can_archive?).to be_truthy

      expect(archived_event.can_publish?).to be_truthy
      expect(archived_event.can_unpublish?).to be_truthy
      expect(archived_event.can_remove?).to be_truthy
      expect(archived_event.can_archive?).to be_falsy
    end
  end

end