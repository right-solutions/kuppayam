require 'spec_helper'

RSpec.describe Event, type: :model do

  let(:featured_event) {FactoryGirl.create(:featured_event)}
  let(:non_featured_event) {FactoryGirl.create(:non_featured_event)}
  
  context "Publishable" do
    it "should toggle featured" do
      expect(non_featured_event.mark_as_featured).to be_truthy
      expect(non_featured_event.featured).to be_truthy

      expect(featured_event.remove_from_featured).to be_truthy
      expect(featured_event.featured).to be_falsy
    end
  end

end