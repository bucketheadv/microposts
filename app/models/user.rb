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

class User < ActiveRecord::Base
  attr_accessible :email, :name, :password,:password_confirmation
  has_secure_password
  has_many :microposts,dependent: :destroy
  has_many :relationships,foreign_key: "follower_id",dependent: :destroy
  has_many :followed_users,through: :relationships,source: :followed
  has_many :reverse_relationships,foreign_key: "followed_id",class_name: "Relationship",dependent: :destroy
  has_many :followers,through: :reverse_relationships,source: :follower
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name,presence: { message: "不能为空"},length: {maximum: 50,message: "太长（最大长度为50）"}
  validates :email,presence: { message: "不能为空"},format: { with: VALID_EMAIL_REGEX,message: "格式不正确"},uniqueness: { case_sensitive: false,message: "已经被使用"}
  validates :password,presence: { message: "不能为空"},length: { minimum: 6,message: "最小长度为6"}
  validates :password_confirmation,presence: { message: "不能为空"}

  def feed
	  #Micropost.where("user_id = ?",id)
	  Micropost.from_users_followed_by(self)
  end
  def following?(other_user)
	  relationships.find_by_followed_id(other_user.id)
  end
  def follow!(other_user)
	  relationships.create(followed_id: other_user.id)
  end
  def unfollow!(other_user)
	  relationships.find_by_followed_id(other_user.id).destroy
  end

  def self.search(search)
	  if search
		  find(:all,:conditions => ['name LIKE ?',"%#{search}%"])
	  else
		  find(:all)
	  end
  end
  private
  def create_remember_token
	  self.remember_token = SecureRandom.urlsafe_base64
  end
end
