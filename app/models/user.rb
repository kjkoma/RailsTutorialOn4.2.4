class User < ActiveRecord::Base

  # association
  has_many :microposts, dependent: :destroy

  # callback
  before_save :callback_before_save
  before_create :callback_before_create

  # constant
  VALID_EMAIL_FORMAT = /\A[\w+\-.]+@([a-z\d\-]|([.][^..]))+\.[a-z]+\z/i

  # validation
  validates :name, presence: true, length: { maximum: 40 }
  validates :email, presence: true, format: { with: VALID_EMAIL_FORMAT }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  has_secure_password

  # class method
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  # private method
  private

    def callback_before_save
        self.email = email.downcase
    end

    def callback_before_create
        self.remember_token = User.encrypt(User.new_remember_token)
    end

end
