require 'rails_helper'

RSpec.describe Relationship, type: :model do

  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { should be_valid }

  describe "follower method" do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    specify { expect(relationship.follower).to eq follower }
    specify { expect(relationship.followed).to eq followed }
  end

  describe "when followed id is not presence" do
    before { relationship.followed_id = nil }
    it { should_not be_valid }
  end

  describe "when follower id is not presence" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end

end
