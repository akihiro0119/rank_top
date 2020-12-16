FactoryBot.define do
  factory :post do
    title             { 'test' }
    rank1             { 'test00' }
    rank2             { 'test00' }
    rank3             { 'test00' }
    likes_count       {0}
    association :user
    created_at        { '1930-02-01' }
    updated_at        { '1930-02-01' }
  end
end
