FactoryBot.define do
  factory :user_verification do
    status { 'pending' }
    token { SecureRandom.base58(32) }
    verify_type { 'confirm_email' }
    user
  end
end
