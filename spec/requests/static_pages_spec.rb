# encoding: utf-8
require 'spec_helper'

describe "StaticPages" do
	describe "主页" do
		before { visit '/static_pages/home' }
		it "不应该有自定义标题" do
			page.should_not have_selector('title',
									 text: "| 主页")
		end
		it "应该有基础标题" do
			page.should have_selector('title',
									 text: "基于Ruby on Rails的微博")
		end
		it "应该有h1 '微博'" do
			page.should have_selector('h1',
									 text: "我的微博")
		end
	end
	describe "帮助页面" do
		before { visit '/static_pages/help' }
		it "应该有h1 '帮助'"  do
			page.should have_selector('h1',
									text: "帮助")
		end
		it "应该有标题 '关于我们'" do
			page.should have_selector('title',
									title: "基于Ruby on Rails的微博 | 帮助")
		end
	end
	describe "'关于我们'页面" do
		before { visit '/static_pages/about' }
		it "应该有h1 '关于我们'" do
			page.should have_selector('h1',
									text: "关于我们")
		end
		it "应该有标题 '关于我们'" do
			page.should have_selector('title',
									text: "基于Ruby on Rails的微博 | 关于我们")
		end
	end
end
