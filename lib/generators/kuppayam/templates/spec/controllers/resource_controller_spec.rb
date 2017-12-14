require 'spec_helper'
# require 'pattana/factories.rb'
# require 'usman/factories.rb'

describe <%= controller_class -%>, :type => :controller do

  let(:user) {FactoryBot.create(:user)}
  let(:suspended_user) {FactoryBot.create(:suspended_user)}
  
  let(:site_role) {FactoryBot.create(:role, name: "Site Admin")}
  
  let(:super_admin_user) {FactoryBot.create(:super_admin_user)}
  let(:site_admin_user) { 
    site_role
    user = FactoryBot.create(:approved_user)
    user.add_role("Site Admin")
    user 
  }
  let(:approved_user) {FactoryBot.create(:approved_user)}

  let(:published_<%= instance_name %>) {FactoryBot.create(:published_<%= instance_name %>)}
  let(:unpublished_<%= instance_name %>) {FactoryBot.create(:unpublished_<%= instance_name %>)}
  let(:suspended_<%= instance_name %>) {FactoryBot.create(:suspended_<%= instance_name %>)}
  let(:blocked_<%= instance_name %>) {FactoryBot.create(:blocked_<%= instance_name %>)}
  let(:removed_<%= instance_name %>) {FactoryBot.create(:removed_<%= instance_name %>)}
  
  describe "index" do
    2.times { FactoryBot.create(:published_<%= instance_name %>) }
    context "Positive Case" do
      it "should be able to view the list of countries" do
        session[:id] = site_admin_user.id
        get :index, params: { use_route: 'dhatu' }
        expect(response.status).to eq(200)
      end

      it "should be able to search an <%= instance_name %>" do
        session[:id] = site_admin_user.id
        get :index, params: { use_route: 'dhatu', query: "India" }, xhr: true
        expect(response.status).to eq(200)
      end
    end
  end

  describe "show" do
    context "Positive Case" do
      it "should be able to view single <%= instance_name %> details" do
        session[:id] = site_admin_user.id
        get :show, params: { use_route: 'dhatu', id: published_<%= instance_name %>.id }, xhr: true
        expect(response.status).to eq(200)
      end
    end
  end

  describe "update_status" do
    context "Positive Case" do
      it "should be update status - publish" do
        session[:id] = site_admin_user.id
        unpublished_<%= instance_name %> = FactoryBot.create(:unpublished_<%= instance_name %>)
        put :update_status, params: { use_route: 'dhatu', id: unpublished_<%= instance_name %>.id, status: :published }, xhr: true
        unpublished_<%= instance_name %>.reload
        expect(unpublished_<%= instance_name %>.published?).to be_truthy
        expect(response.status).to eq(200)
      end

      it "should be update status - unpublish" do
        session[:id] = site_admin_user.id
        published_<%= instance_name %> = FactoryBot.create(:published_<%= instance_name %>)
        put :update_status, params: { use_route: 'dhatu', id: published_<%= instance_name %>.id, status: :unpublished }, xhr: true
        published_<%= instance_name %>.reload
        expect(published_<%= instance_name %>.unpublished?).to be_truthy
        expect(response.status).to eq(200)
      end

      it "should be update status - remove" do
        session[:id] = site_admin_user.id
        unpublished_<%= instance_name %> = FactoryBot.create(:unpublished_<%= instance_name %>)
        put :update_status, params: { use_route: 'dhatu', id: unpublished_<%= instance_name %>.id, status: :removed }, xhr: true
        unpublished_<%= instance_name %>.reload
        expect(unpublished_<%= instance_name %>.removed?).to be_truthy
        expect(response.status).to eq(200)
      end

      it "should be update status - archive" do
        session[:id] = site_admin_user.id
        unpublished_<%= instance_name %> = FactoryBot.create(:unpublished_<%= instance_name %>)
        put :update_status, params: { use_route: 'dhatu', id: unpublished_<%= instance_name %>.id, status: :archived }, xhr: true
        unpublished_<%= instance_name %>.reload
        expect(unpublished_<%= instance_name %>.archived?).to be_truthy
        expect(response.status).to eq(200)
      end
    end
  end

  describe "new" do
    context "Positive Case" do
      it "should display the new form for site admin" do
        session[:id] = site_admin_user.id
        get :new, params: { use_route: 'dhatu' }, xhr: true
        expect(response.status).to eq(200)
      end
    end
  end

  describe "edit" do
    context "Positive Case" do
      it "should display the edit form for site admin" do
        session[:id] = site_admin_user.id
        get :edit, params: { use_route: 'dhatu' }, xhr: true
        expect(response.status).to eq(200)
      end
    end
  end

  describe "create" do
    context "Positive Case" do
      it "site admin should be able to create a region" do
        session[:id] = site_admin_user.id
        <%= instance_name %>_params = FactoryBot.build(:unpublished_<%= instance_name %>, name: "Some Name").attributes
        expect do
          post :create, params: { use_route: 'dhatu', "<%= instance_name %>": <%= instance_name %>_params }, xhr: true
        end.to change(<%= model_class -%>, :count).by(1)
        expect(<%= model_class -%>.last.name).to match("Some Name")
      end
    end
  end

  describe "update" do
    context "Positive Case" do
      it "site admin should be able to update a <%= instance_name %>" do
        session[:id] = site_admin_user.id
        published_<%= instance_name %> = FactoryBot.create(:published_<%= instance_name %>, title: "Some Title")
        <%= instance_name %>_params = published_<%= instance_name %>.attributes.clone
        <%= instance_name %>_params["title"] = "Changed Title"
        expect do
          put :update, params: { use_route: 'dhatu', id: published_<%= instance_name %>.id, "<%= instance_name %>": <%= instance_name %>_params }, xhr: true
        end.to change(<%= model_class -%>, :count).by(0)
        expect(published_<%= instance_name %>.reload.title).to match("Changed Title")
      end
    end
  end

  describe "destroy" do
    context "Positive Case" do
      it "site admin should be able to remove a <%= instance_name %>" do
        session[:id] = site_admin_user.id
        removed_<%= instance_name %>
        expect do
          delete :destroy, params: { use_route: 'dhatu', id: removed_<%= instance_name %>.id }, xhr: true
        end.to change(<%= model_class -%>, :count).by(-1)
      end
    end
  end

end
