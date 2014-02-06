# encoding: utf-8
require 'spec_helper'

describe "UserPages" do
	subject { page } 

	describe "注册界面" do
		before { visit signup_path }
		it { should have_selector('h1',text: '注册') }
		it { should have_selector('title',text: full_title('注册用户'))}
	end
end
