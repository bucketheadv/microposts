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
	describe "'编辑'页面" do
		let(:user) { FactoryGirl.create(:user)}
		before { 
			sign_in user
			visit edit_user_path(user)
		}
		describe "页面" do
			it { should have_selector('h1',text: "更新个人资料")}
			it { should have_selector('title',text: "编辑用户")}
			it { should have_link('修改',href: "http://gravatar.com/emails")}
			describe "信息不合法" do
				before { click_button "保存修改"}
				it { should have_content('错误')}
			end
			describe "信息合法" do
				let(:new_name) { "New Name"}
				let(:new_email) { "new@example.com" }
				before do
					fill_in "用户名",with: new_name
					fill_in "邮箱",with: new_email
					fill_in "密码",with: user.password
					fill_in "确认密码",with: user.password
					click_button "保存修改"
				end
				it { should have_selector('title',text: new_name)}
				it { should have_selector('div.alert.alert-success')}
				it { should have_link('登出',href: signout_path)}
				specify { user.reload.name.should == new_name}
				specify { user.reload.email.should == new_email}
			end
		end
	end
	describe "index" do
		let(:user) { FactoryGirl.create(:user)}
		before do
			sign_in user
			#FactoryGirl.create(:user,name: "Bob",email: "bob@example.com")
			#FactoryGirl.create(:user,name: "Ben",email: "ben@example.com")
			visit users_path
		end
		it { should have_selector('title',text: '所有用户')}
		it { should have_selector('h1',text: '所有用户')}
		describe "分页" do
			before(:all) { 30.times {FactoryGirl.create(:user)}}
			after(:all) { User.delete_all }
			it { should have_selector('div.pagination')}
			it "应该列出各个用户" do
				User.paginate(page: 1).each do |user|
					page.should have_selector('li',text: user.name)
				end
			end
		end
		describe "删除链接" do
			let(:admin) { FactoryGirl.create(:admin)}
			before do
				sign_in admin
				visit users_path
			end
			it { should have_link('删除',href: user_path(User.first))}
			it "应该能够删除其他用户" do
				expect { click_link('删除')}.to change(User,:count).by(-1)
			end
			it { should_not have_link('删除',href: user_path(admin))}
		end
	end
end
