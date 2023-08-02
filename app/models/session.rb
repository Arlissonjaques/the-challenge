class Session < ApplicationRecord
  belongs_to :user

  def self.search(user_id, token)
    Session.find_by(token: token, status: true, user_id: user_id)
  end

  def is_late?
    if (last_used_at + TOKEN_LIFETIME) >= Time.now
      false
    else
      update(status: false)

      true
    end
  end

  def used
    update(last_used_at: Time.now)
  end
end
