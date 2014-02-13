# encoding: utf-8
class Micropost < ActiveRecord::Base
  attr_accessible :content #, :user_id

  belongs_to :user

  validates :user_id,presence: true
  validates :content,presence: { message: "不能为空"},length: {maximum: 560,message: "最大长度为560个字符"}

  default_scope order: 'microposts.created_at DESC'

  def self.from_users_followed_by(user)
	  followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
	  where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
		   user_id: user.id)
  end
end
