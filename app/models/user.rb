# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email_address   :string(255)
#  likes           :integer          default(50)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :email_address, :name, :likes, :password, :password_confirmation
  has_secure_password
  has_many :emails
  
  before_save { |user| user.email_address = email_address.downcase }
  before_save :create_remember_token

  validates :name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email_address, presence:   true,
    format:     { with: VALID_EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  validates :password, presence: true, on: :create
  validates :password_confirmation, presence: true, on: :create


  def self.incr_decr_likes(liked_user, user_who_likes)
      liked_user.increment!(:likes, 5)
      user_who_likes.decrement!(:likes, 5)
      liked_user.save!
      user_who_likes.save!
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

end
