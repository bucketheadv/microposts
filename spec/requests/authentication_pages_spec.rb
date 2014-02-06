# encoding: utf-8
require 'spec_helper'

describe "AuthenticationPages" do
	subject { page }
	describe "登录页面" do
		before { visit signin_path }
		it { should have_selector('h1',text: '用户登录')}
		it { should have_selector('title',text: '用户登录')}

		describe "信息填写不正确" do
			before { click_button "登录" }
			it { should have_selector('title',text: '用户登录')}
			it { should have_selector('div.alert.alert-error',text:'不正确')}
			describe "访问其他页面之后" do
				before { click_link "首页" }
				it {should_not have_selector('div.alert.alert-error')}
			end
		end
		describe "信息填写正确" do
			let(:user) {FactoryGirl.create(:user)}
			before do
				fill_in "邮箱",with: user.email
				fill_in "密码",with: user.password
				click_button "登录"
			end
			it { should have_selector('title',text: user.name)}
			it { should have_link('个人资料',href: user_path(user))}
			it { should have_link('登出',href: signout_path)}
			it { should_not have_link('登录',href: signin_path)}

			describe "登出之后" do
				before { click_link "登出"}
				it { should have_link('登录')}
			end
		end
	end
end
