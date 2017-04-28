require 'spec_helper'

describe Kuppayam::ImagesController, :type => :controller do

  let(:event) {FactoryGirl.create(:event)}
  let(:event_cover_image) {FactoryGirl.create(:event_cover_image, imageable: event)}

  describe "index" do
    it "should display all images" do
      10.times {FactoryGirl.create(:event_cover_image, imageable: event)}
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe "show" do
    it "should display all images" do
      image_params = { 
        id: event_cover_image.id,
        image_type: "Image::EventCoverImage",
        imageable_id: event.id,
        imageable_type: event.class.name
      }
      get :show, params: image_params
      expect(response.status).to eq(200)
    end
  end

  describe "new" do
    it "should display all images" do
      image_params = { 
        image_type: "Image::EventCoverImage",
        imageable_id: event.id,
        imageable_type: event.class.name
      }
      get :new, params: image_params, xhr: true
      expect(response.status).to eq(200)
    end
  end

  describe "edit" do
    it "should display all images" do
      image_params = {
        id: event_cover_image.id, 
        image_type: "Image::EventCoverImage",
        imageable_id: event.id,
        imageable_type: event.class.name
      }
      get :edit, params: image_params, xhr: true
      expect(response.status).to eq(200)
    end
  end

  describe "create" do
    it "should display all images" do
      image_params = { 
        image_type: "Image::EventCoverImage",
        imageable_id: event.id,
        imageable_type: event.class.name,
        image: fixture_file_upload('spec/dummy/spec/factories/test.jpg', 'image.png')
      }
      post :create, params: image_params
    end
  end

  describe "update" do
    it "should display all images" do
      image_params = { 
        id: event_cover_image.id,
        image_type: "Image::EventCoverImage",
        imageable_id: event.id,
        imageable_type: event.class.name,
        image: fixture_file_upload('spec/dummy/spec/factories/test.jpg', 'image.png')
      }
      post :update, params: image_params
    end
  end

  describe "destroy" do
    it "should display all images" do
      image_params = {
        id: event_cover_image.id, 
        image_type: "Image::EventCoverImage",
        imageable_id: event.id,
        imageable_type: event.class.name
      }
      delete :destroy, params: image_params, xhr: true
      expect(response.status).to eq(200)
    end
  end
  
end
