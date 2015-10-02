class User < ActiveRecord::Base
  before_save do
      self.email = email.downcase
  end

  VALID_EMAIL_FORMAT = /\A[\w+\-.]+@([a-z\d\-]|([.][^..]))+\.[a-z]+\z/i

  validates :name, presence: true, length: { maximum: 40 }
  validates :email, presence: true, format: { with: VALID_EMAIL_FORMAT }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }
  has_secure_password

end
