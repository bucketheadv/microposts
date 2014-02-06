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
			describe "提交之后" do
				before { click_button submit}
				it { should have_selector('title',text: '注册用户')}
				it { should have_content('错误')}
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

			describe "保存用户之后" do
				before { click_button submit }
				let(:user) { User.find_by_email('user@example.com')}
				it { should have_selector('title',text: user.name)}
				it { should have_selector('div.alert.alert-success',text: '欢迎')}
				it { should have_link("登出")}
			end
		end
	end
	describe "个人资料 界面" do
		let(:user) { FactoryGirl.create(:user)}
		before { visit user_path(user) }
		it { should have_selector('h1',text: user.name)}
		it { should have_selector('title',text: user.name)}
	end
	describe "登录页面" do
		before { visit signin_path }
		describe "信息不合法" do
			before { click_button "登录"}
			it { should have_selector('title',text: "登录")}
			it { should have_selector('div.alert.alert-error',text: "不正确")}
		end
		describe "信息合法" do
			let(:user) { FactoryGirl.create(:user)}
			before do
				fill_in "邮箱",with: user.email
				fill_in "密码",with: user.password
				click_button "登录"
			end
			it { should have_selector('title',text: user.name)}
			it { should have_link('个人资料',href: user_path(user))}
			it { should have_link('登出',href: signout_path)}
			it { should_not have_link('登录',href: signin_path)}
		end
	end
end
