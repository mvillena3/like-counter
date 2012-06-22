# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  likes           :integer          default(50)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email, :name, :likes, :password, :password_confirmation
  has_secure_password
  
  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
    format:     { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  validates :password, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :create

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def incr_decr_likes(liked_user)
      user_liked.increment!(:likes, 5)
      user_who_likes = current_user
      user_who_likes.decrement!(:likes, 5)
      user_liked.save!
      user_who_likes.save!
      sign_in current_user 
  end
end
