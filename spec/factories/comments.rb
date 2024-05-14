FactoryBot.define do
  factory :comment do
    name { Faker::Lorem.sentence(word_count: 3) }
    comment { Faker::Lorem.sentence(word_count: 7) }
    post
    user
  end
end