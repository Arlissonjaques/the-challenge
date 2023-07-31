class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy

  def confirmed?
    !email_confirmed_at.nil?
  end
end
