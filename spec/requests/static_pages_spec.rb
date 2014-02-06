# encoding: utf-8
require 'spec_helper'

describe "StaticPages" do

	subject { page }
	describe "首页" do
		before { visit root_path }
		it "不应该有自定义标题" do
			page.should_not have_selector('title',
									 text: "| 首页")
		end
		it "应该有基础标题" do
			page.should have_selector('title',
									 text: full_title(''))
		end
		it "应该有h1 '微博'" do
			page.should have_selector('h1',
									 text: "我的微博")
		end
	end
	describe "帮助页面" do
		before { visit help_path }
		it "应该有h1 '帮助'"  do
			page.should have_selector('h1',
									text: "帮助")
		end
		it "应该有标题 '帮助'" do
			page.should have_selector('title',
									title: full_title('帮助'))
		end
	end
	describe "'关于我们'页面" do
		before { visit about_path }
		it "应该有h1 '关于我们'" do
			page.should have_selector('h1',
									text: "关于我们")
		end
		it "应该有标题 '关于我们'" do
			page.should have_selector('title',
									text: full_title('关于我们'))
		end
	end
	describe "'联系我们'页面" do
		before { visit contact_path}
		it "应该有h1 '联系我们'" do
			page.should have_selector('h1',
									 text: "联系我们")
		end
		it "应该有标题 '联系我们'" do
			page.should have_selector('title',
									 text: full_title('联系我们'))
		end
	end
end
