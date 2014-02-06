# encoding: utf-8
require 'spec_helper'

describe Micropost do
  #pending "add some examples to (or delete) #{__FILE__}"
	let(:user) { FactoryGirl.create(:user)}
	before do
		@micropost =  user.microposts.build(content: "Lorem ipsum")
	end

	subject { @micropost }
	it { should respond_to(:content)}
	it { should respond_to(:user_id)}
	it { should respond_to(:user)}
	its(:user) { should == user}
	it { should be_valid}

	describe "当user_id为空时" do
		before {@micropost.user_id = nil}
		it { should_not be_valid}
	end
	describe "属性读取权限" do
		it "不应该允许读取user_id" do
			expect do 
				Micropost.new(user_id: user.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end
	describe "内容为空时" do
		before {@micropost.content = " "}
		it { should_not be_valid}
	end
	describe "内容过长时" do
		before { @micropost.content = "a" * 141}
		it { should_not be_valid}
	end
end
