# encoding: utf-8
require 'spec_helper'

describe Relationship do
  #pending "add some examples to (or delete) #{__FILE__}"
	let(:follower) { FactoryGirl.create(:user)}
	let(:followed) { FactoryGirl.create(:user)}
	let(:relationship) { follower.relationships.build(followed_id: followed.id)}

	subject { relationship }
	it { should be_valid }

	describe "可访问属性" do
		it "不应该允许访问follower id" do
			expect do
				Relationship.new(follower_id: follower.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end
	describe "follower方法" do
		it { should respond_to(:follower)}
		it { should respond_to(:followed)}
		its(:follower) { should == follower}
		its(:followed) { should == followed}
	end
	describe "当followed id为空" do
		before { relationship.followed_id = nil}
		it { should_not be_valid}
	end
	describe "当follower id为空" do
		before { relationship.follower_id = nil}
		it { should_not be_valid}
	end
end
