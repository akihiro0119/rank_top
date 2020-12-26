FactoryBot.define do
  factory :post do

    association :user

    title             { Faker::Name.last_name }
    rank1             { Faker::Name.last_name }
    rank2             { Faker::Name.last_name }
    rank3             { Faker::Name.last_name }
    likes_count       { 0 }
    created_at        { '1930-02-01' }
    updated_at        { '1930-02-01' }
    tag_ids             {Faker::Number.between(from: 1, to: 10) }

  end
end
