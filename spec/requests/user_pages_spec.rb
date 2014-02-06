# encoding: utf-8
require 'spec_helper'

describe "UserPages" do
	subject { page } 

	describe "注册界面" do
		before { visit signup_path }
		let(:submit) { "生成我的帐户" }

		describe "验证不能通过" do
			it "不能生成用户" do
				expect { click_button submit}.not_to change(User,:count)
			end
		end
		describe "验证通过" do
			before do
				fill_in "用户名",with: "Example User"
				fill_in "邮箱",with: "user@example.com"
				fill_in "密码",with: "foobar"
				fill_in "确认密码",with: "foobar"
			end
			it "应该生成用户" do
				expect { click_button submit}.to change(User,:count).by(1)
			end
		end
	end
	describe "个人资料 界面" do
		let(:user) { FactoryGirl.create(:user)}
		before { visit user_path(user) }
		it { should have_selector('h1',text: user.name)}
		it { should have_selector('title',text: user.name)}
	end
end
