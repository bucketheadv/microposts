# encoding: utf-8
require 'spec_helper'

describe RelationshipsController do
	let(:user) { FactoryGirl.create(:user) }
	let(:other_user) { FactoryGirl.create(:user)}

	before { sign_in user }

	describe "生成一个relationship使用Ajax" do
		it "应该增加一个Relationship的数量" do
			expect do
				xhr :post,:create,relationship: { followed_id: other_user.id}
			end.to change(Relationship,:count).by(1)
		end
		it "应该返回成功" do
			xhr :post,:create,relationship:{ followed_id: other_user.id }
			response.should be_success
		end
	end
	describe "销毁一个relationship使用Ajax" do
		before { user.follow!(other_user)}
		let(:relationship) { user.relationships.find_by_followed_id(other_user)}
		it "应该减少一个Relationship的数量" do
			expect do 
				xhr :delete,:destroy,id: relationship.id
			end.to change(Relationship,:count).by(-1)
		end
		it "应该返回成功" do
			xhr :post,:destroy,id: relationship.id
			response.should be_success
		end
	end
end
