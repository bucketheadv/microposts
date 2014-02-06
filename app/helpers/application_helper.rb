# encoding: utf-8
module ApplicationHelper
	def full_title(page_title)
		base_title = "基于Ruby on Rails的微博"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
end
