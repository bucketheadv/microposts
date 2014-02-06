# encoding: utf-8
def full_title(page_title)
	base_title = "基于Ruby on Rails的微博"
	if page_title.empty?
		base_title
	else
		"#{base_title} | #{page_title}"
	end
end

def sign_in(user)
	visit signin_path
	fill_in "邮箱",with: user.email
	fill_in "密码",with: user.password

	click_button "登录"
	cookies[:remember_token] = user.remember_token
end
