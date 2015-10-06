class Micropost < ActiveRecord::Base

  # association
  belongs_to :user
  default_scope -> { order('created_at DESC') }

  # validation
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

end
