FactoryBot.define do
  factory :session do
    last_used_at { 30.minutes.ago }
    status { true }
    token { SecureRandom.base58(32) }
    user
  end
end
