# encoding: utf-8
class SessionsController < ApplicationController
	def new
	end
	
	def create 
		user = User.find_by_email(params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			if params[:session][:remember_token].to_i == 1
				#flash.now.alert = "永久登录"
				sign_in_permanent user
			else
				#flash.now.alert = "临时登录"
				sign_in user
			end
			redirect_back_or user
		else
			flash.now[:error] = "用户名或密码不正确"
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
