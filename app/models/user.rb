class User < ActiveRecord::Base
  has_many :books
  has_secure_password
  validates_presence_of :username, :email

  def slug
    username.gsub(/\s/, "-")
  end

  def self.find_by_slug(slug)
    username = slug.gsub(/-/, " ")
    User.find_by(username: username)
  end

  def self.logged_in?(session)
    !!session[:user_id]
  end

  def self.current_user(session)
    User.find_by(id: session[:user_id])
  end
end
