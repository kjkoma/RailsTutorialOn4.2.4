class User < ActiveRecord::Base

  # association
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower

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

  # instance method
  def feed
    # 11.42 -> comment out by change method
    # Micropost.where("user_id = ?", id).order("created_at DESC")
    Micropost.from_users_followed_by(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

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
