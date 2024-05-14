FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence(word_count: 3) }
    text { Faker::Lorem.sentence(word_count: 10) }
    author { create(:user) }
  end
end
