require 'spec_helper'

RSpec.describe Image::Base, type: :model do

  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryBot.build(:event_cover_image).valid?).to be true
    end
  end

  context "Validations" do
    it { should validate_presence_of :image }
    it { should validate_presence_of :imageable }

    it "should validate filesize" do
      skip
      #Image::CoverImage # load real ActiveRecord class
      #stub_const('Image::CoverImage::UPLOAD_LIMIT', 2000)

      #event = FactoryBot.build(:unpublished_event)
      #event_cover_image = FactoryBot.build(:event_cover_image, imageable: event)

      #error_message = "You cannot upload an image greater than 1.95 KiB"
      #expect(event_cover_image).not_to be_valid
      #expect(event_cover_image.errors[:image]).to match_array([error_message])
    end
  end

end