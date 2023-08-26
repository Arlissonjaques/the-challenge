FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email(domain: 'evil-corp') }
    password { Faker::Internet.password(min_length: 8, max_length: 72) }
    role { 1 }
    email_confirmed_at { 2.days.ago }
  end
end
