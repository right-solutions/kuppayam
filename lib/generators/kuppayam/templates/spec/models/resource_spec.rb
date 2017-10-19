require 'spec_helper'

RSpec.describe <%= model_class %>, type: :model do

  let(:<%= instance_name %>) {FactoryGirl.build(:<%= instance_name %>)}
  
  context "Factory" do
    it "should validate all the factories" do
      expect(FactoryGirl.build(:published_<%= instance_name %>).valid?).to be true
      expect(FactoryGirl.build(:unpublished_<%= instance_name %>).valid?).to be true
      expect(FactoryGirl.build(:removed_<%= instance_name %>).valid?).to be true
      expect(FactoryGirl.build(:archived_<%= instance_name %>).valid?).to be true
    end
  end

  context "Validations" do
    it { should validate_presence_of :title }
    it { should allow_value('<%= model_name %> Title').for(:title )}
    it { should_not allow_value('OFTL').for(:title )}
    it { should_not allow_value("x"*257).for(:title )}

    it { should validate_presence_of :<%= instance_name %>_text }
    it { should allow_value('<%= model_name %> Text').for(:<%= instance_name %>_text )}
    it { should_not allow_value('OF').for(:<%= instance_name %>_text )}
    it { should_not allow_value("x"*65).for(:<%= instance_name %>_text )}

    it { should validate_presence_of :description }

    it { should validate_inclusion_of(:status).in_array(<%= model_class %>::STATUS.values) }
  end

  context "Associations" do
    it { should have_one(:cover_image) }
  end

end