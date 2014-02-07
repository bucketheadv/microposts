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
			before { sign_in user }
			it { should have_selector('title',text: user.name)}
			it { should have_link('个人资料',href: user_path(user))}
			it { should have_link('登出',href: signout_path)}
			it { should have_link('设置',href: edit_user_path(user))}
			it { should have_link('用户',href: users_path)}
			it { should_not have_link('登录',href: signin_path)}

			describe "登出之后" do
				before { click_link "登出"}
				it { should have_link('登录')}
			end
		end
	end
	describe "权限认证" do
		describe "未登录用户" do
			let(:user) { FactoryGirl.create(:user)}

			describe "试图访问一个保护页面" do
				before do
					visit edit_user_path(user)
					fill_in "邮箱",with: user.email
					fill_in "密码",with: user.password
					click_button "登录"
				end
				describe "登录后" do
					it "应该渲染想要的保护页面" do
						page.should have_selector('title',text: "编辑用户")
					end
				end
			end
			describe "在Users Controller中" do
				describe "访问'编辑页面'" do
					before { visit edit_user_path(user)}
					it { should have_selector('title',text: '登录')}
				end
				describe "提交到更新action" do
					before { put user_path(user)}
					specify { response.should redirect_to(signin_path)}
				end
				describe "访问用户index" do
					before { visit users_path}
					it { should have_selector('title',text: '登录')}
				end
				describe "访问关注页面" do
					before { visit following_user_path(user)}
					it { should have_selector('title',text: '登录')}
				end
				describe "访问粉丝页面" do
					before { visit followers_user_path(user)}
					it { should have_selector('title',text: '登录')}
				end
			end
			describe "在Microposts Controller中" do
				describe "提交到create action" do
					before { post microposts_path}
					specify { response.should redirect_to(signin_path)}
				end
				describe "提交到destroy action中" do
					before { delete micropost_path(FactoryGirl.create(:micropost))}
					specify{ response.should redirect_to(signin_path)}
				end
			end
			describe "在Relationships Controller中" do
				describe "提交到create action" do
					before { post relationships_path}
					specify { response.should redirect_to(signin_path)}
				end
				describe "提交到destroy action" do
					before { delete relationship_path(1)}
					specify { response.should redirect_to(signin_path)}
				end
			end
		end
		describe "作为错误用户" do
			let(:user) {FactoryGirl.create(:user)}
			let(:wrong_user) { FactoryGirl.create(:user,email: "wrong@example.com")}
			before { sign_in user}
			describe "访问Users#edit页面" do
				before { visit edit_user_path(wrong_user)}
				it { should_not have_selector('h1',text: full_title('更新用户资料'))}
			end
			describe "提交更新请求要Users#update Action" do
				before { put user_path(wrong_user)}
				specify { response.should redirect_to(root_path)}
			end
		end
		describe "作为非管理员登录" do
			let(:user) {FactoryGirl.create(:user)}
			let(:non_admin){ FactoryGirl.create(:user)}
			before { sign_in non_admin}
			describe "提交一个删除请求到Users#destroy Action" do
				before { delete user_path(user)}
				specify { response.should redirect_to(root_path)}
			end
		end
	end
end
