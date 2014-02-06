# encoding: utf-8
require 'spec_helper'

describe "MicropostPages" do
	subject { page }
	let(:user) { FactoryGirl.create(:user)}
	before{ sign_in user }

	describe "微博创建" do
		before { visit root_path}
		describe "信息不合法" do
			it "不应该创建微博" do
				expect { click_button "发布"}.not_to change(Micropost,:count).by(1)
			end
			describe "错误信息" do
				before { click_button "发布"}
				it { should have_content('错误')}
			end
		end
		describe "信息合法" do
			before { fill_in 'micropost_content',with: 'Lorem ipsum'}
			it "应该创建一条微博" do
				expect { click_button "发布"}.to change(Micropost,:count).by(1)
			end
		end
	end
	describe "微博销毁" do
		before { FactoryGirl.create(:micropost,user: user)}
		describe "作为正确用户" do
			before { visit root_path}
			it "应该删除一条微博" do
				expect { click_link "删除"}.to change(Micropost,:count).by(-1)
			end
		end
	end
end

