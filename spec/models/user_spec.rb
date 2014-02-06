# encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
# 

require 'spec_helper'

describe User do
  #pending "add some examples to (or delete) #{__FILE__}"
	before { @user = User.new(name: "Example User",
							  email: "user@example.com",
							 password: "foobar",
							 password_confirmation: "foobar")}
	subject {@user}
	it { should respond_to(:name)}
	it { should respond_to(:email)}
	it { should respond_to(:password_digest)}
	it { should respond_to(:password)}
	it { should respond_to(:password_confirmation)}
	it { should respond_to(:authenticate)}

	it { should be_valid}
	describe "当用户名为空时" do
		before { @user.name = " " }
		it { should_not be_valid}
	end
	describe "当邮箱为空时" do
		before {@user.email = " "}
		it { should_not be_valid}
	end

	describe "当用户名太长时" do
		before {@user.name = "a" * 51}
		it { should_not be_valid}
	end

	describe "当邮箱格式不正确时" do
		it "不应该通过验证" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
			end
		end
	end
	describe "当邮箱格式正确时" do
		it "应该通过验证" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
			end
		end
	end
	describe "当邮箱已经被注册" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end
		it { should_not be_valid}
	end
	describe "当密码为空时" do
		before { @user.password = @user.password_confirmation = " "}
		it { should_not be_valid }
	end
	describe "当密码与二次密码不一致时" do
		before {@user.password_confirmation = "mismatch"}
		it { should_not be_valid}
	end 
	describe "当二次密码为空时" do
		before {@user.password_confirmation = nil}
		it { should_not be_valid}
	end
	describe "用户密码过短" do
		before {@user.password = @user.password_confirmation = "a" * 5}
		it { should be_invalid}
	end
	describe "认证方法的返回值" do
		before {@user.save}
		let(:found_user) { User.find_by_email(@user.email)}

		describe "密码验证通过" do
			it { should == found_user.authenticate(@user.password)}
		end
		describe "密码验证不通过" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid")}
			it { should_not == user_for_invalid_password}
			specify { user_for_invalid_password.should be_false}
		end
	end
end
