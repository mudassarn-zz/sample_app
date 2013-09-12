class User < ActiveRecord::Base
  before_save {self.email=self.email.downcase}
  attr_accessible :email, :name, :password_digest, :password, :password_confirmation

  validates :name, presence: true, length: {maximum: 50}
  #VALID_EMAIL_REGEX = 
  validates :email, presence: true, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, length: {minimum: 6}
end
