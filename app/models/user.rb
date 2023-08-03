class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :user_verifications, dependent: :destroy

  before_save :downcase_email!

  validates :first_name, :last_name, presence: true
  validates :email, presence: true,
            uniqueness: {
              case_sensitive: false
            },
            format: {
              with: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/,
              message: I18n.t("errors.models.user.format_email")
            }
  validates :password,
            format: {
              with: /\A(?=.*).{8,72}\z/,
              message: I18n.t("errors.models.user.format_password")
            }, if: :password_required?

  after_create :send_confirm_email

  def email_confirmed?
    !email_confirmed_at.nil?
  end

  def confirm
    update(email_confirmed_at: Time.now)
  end

  def send_confirm_email
    unless email_confirmed?
      verification = UserVerification.create(user_id: id, verify_type: :confirm_email)
      # TODO: send confirmation email
    end
  end

  def send_reset_password_email
    if email_confirmed?
      verification = UserVerification.create(user_id: id, verify_type: :reset_email)
      # TODO: send reset password email
    end
  end

  def downcase_email!
    email&.donwcase!
  end
end
