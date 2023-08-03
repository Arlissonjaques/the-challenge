class Session < ApplicationRecord
  TOKEN_LENGTH = 32
  TOKEN_LIFETIME = 30.minutes

  belongs_to :user

  before_validation :generate_token, on: :create

  validates :token, presence: true, uniqueness: { case_sensitive: true }

  after_create :last_used

  def self.search(user_id, token)
    Session.find_by(token: token, status: true, user_id: user_id)
  end

  def expired?
    if (last_used_at + TOKEN_LIFETIME) <= Time.now
      update(status: false)
      true
    else
      false
    end
  end

  def last_used
    update(last_used_at: Time.now)
  end

  def close_session
    update(status: false)
  end

  def generate_token
    self.token = loop do
      random_token = SecureRandom.base58(TOKEN_LENGTH)
      break random_token unless Session.exists?(token: random_token)
    end
  end
end
