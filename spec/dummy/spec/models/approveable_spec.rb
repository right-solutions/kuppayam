require 'spec_helper'

RSpec.describe Event, type: :model do

  let(:approved_classified) {FactoryBot.create(:approved_classified)}
  let(:pending_classified) {FactoryBot.create(:pending_classified)}
  let(:blocked_classified) {FactoryBot.create(:blocked_classified)}
  let(:suspended_classified) {FactoryBot.create(:suspended_classified)}
  let(:removed_classified) {FactoryBot.create(:removed_classified)}
  
  context "Approvable" do
    it "should approve" do
      expect(pending_classified.approve).to be_truthy
      expect(pending_classified.status?(:approved)).to be_truthy
      expect(pending_classified.approved?).to be_truthy

      expect(suspended_classified.approve).to be_truthy
      expect(suspended_classified.status?(:approved)).to be_truthy
      expect(suspended_classified.approved?).to be_truthy

      expect(blocked_classified.approve).to be_falsy
      expect(blocked_classified.status?(:blocked)).to be_truthy
      expect(blocked_classified.blocked?).to be_truthy

      expect(removed_classified.approve).to be_falsy
      expect(removed_classified.status?(:removed)).to be_truthy
      expect(removed_classified.removed?).to be_truthy

      expect(approved_classified.approve).to be_falsy
    end

    it "should mark as pending" do
      expect(approved_classified.pending).to be_truthy
      expect(approved_classified.status?(:pending)).to be_truthy
      expect(approved_classified.pending?).to be_truthy

      expect(suspended_classified.pending).to be_truthy
      expect(suspended_classified.status?(:pending)).to be_truthy
      expect(suspended_classified.pending?).to be_truthy

      expect(blocked_classified.pending).to be_truthy
      expect(blocked_classified.status?(:pending)).to be_truthy
      expect(blocked_classified.pending?).to be_truthy

      expect(removed_classified.pending).to be_truthy
      expect(removed_classified.status?(:pending)).to be_truthy
      expect(removed_classified.pending?).to be_truthy

      expect(pending_classified.pending).to be_falsy
    end

    it "should suspend" do
      expect(approved_classified.suspend).to be_truthy
      expect(approved_classified.status?(:suspended)).to be_truthy
      expect(approved_classified.suspended?).to be_truthy

      expect(pending_classified.suspend).to be_truthy
      expect(pending_classified.status?(:suspended)).to be_truthy
      expect(pending_classified.suspended?).to be_truthy

      expect(blocked_classified.suspend).to be_truthy
      expect(blocked_classified.status?(:suspended)).to be_truthy
      expect(blocked_classified.suspended?).to be_truthy

      expect(removed_classified.suspend).to be_falsy
      expect(removed_classified.status?(:removed)).to be_truthy
      expect(removed_classified.removed?).to be_truthy

      expect(suspended_classified.suspend).to be_falsy
    end

    it "should block" do
      expect(approved_classified.block).to be_truthy
      expect(approved_classified.status?(:blocked)).to be_truthy
      expect(approved_classified.blocked?).to be_truthy

      expect(pending_classified.block).to be_truthy
      expect(pending_classified.status?(:blocked)).to be_truthy
      expect(pending_classified.blocked?).to be_truthy

      expect(suspended_classified.block).to be_truthy
      expect(suspended_classified.status?(:blocked)).to be_truthy
      expect(suspended_classified.blocked?).to be_truthy

      expect(removed_classified.block).to be_falsy
      expect(removed_classified.status?(:removed)).to be_truthy
      expect(removed_classified.removed?).to be_truthy

      expect(blocked_classified.block).to be_falsy
    end

    it "should remove" do
      expect(approved_classified.remove).to be_truthy
      expect(approved_classified.status?(:removed)).to be_truthy
      expect(approved_classified.removed?).to be_truthy

      expect(pending_classified.remove).to be_truthy
      expect(pending_classified.status?(:removed)).to be_truthy
      expect(pending_classified.removed?).to be_truthy

      expect(suspended_classified.remove).to be_truthy
      expect(suspended_classified.status?(:removed)).to be_truthy
      expect(suspended_classified.removed?).to be_truthy

      expect(blocked_classified.remove).to be_truthy
      expect(blocked_classified.status?(:removed)).to be_truthy
      expect(blocked_classified.removed?).to be_truthy

      expect(removed_classified.remove).to be_falsy
    end

    it "should check if possible to change status" do
      expect(approved_classified.can_approve?).to be_falsy
      expect(approved_classified.can_pending?).to be_truthy
      expect(approved_classified.can_suspend?).to be_truthy
      expect(approved_classified.can_block?).to be_truthy
      expect(approved_classified.can_remove?).to be_truthy

      expect(pending_classified.can_approve?).to be_truthy
      expect(pending_classified.can_pending?).to be_falsy
      expect(pending_classified.can_suspend?).to be_truthy
      expect(pending_classified.can_block?).to be_truthy
      expect(pending_classified.can_remove?).to be_truthy

      expect(suspended_classified.can_approve?).to be_truthy
      expect(suspended_classified.can_pending?).to be_truthy
      expect(suspended_classified.can_suspend?).to be_falsy
      expect(suspended_classified.can_block?).to be_truthy
      expect(suspended_classified.can_remove?).to be_truthy

      expect(blocked_classified.can_approve?).to be_falsy
      expect(blocked_classified.can_pending?).to be_truthy
      expect(blocked_classified.can_suspend?).to be_truthy
      expect(blocked_classified.can_block?).to be_falsy
      expect(blocked_classified.can_remove?).to be_truthy

      expect(removed_classified.can_approve?).to be_falsy
      expect(removed_classified.can_pending?).to be_truthy
      expect(removed_classified.can_suspend?).to be_falsy
      expect(removed_classified.can_block?).to be_falsy
      expect(removed_classified.can_remove?).to be_falsy
    end
  end

end