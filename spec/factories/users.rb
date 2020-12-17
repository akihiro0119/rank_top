FactoryBot.define do
  factory :user do
    name {Faker::Name.last_name}
    email{ Faker::Internet.email }
    password = Faker::Alphanumeric.alphanumeric(number: 6, min_alpha: 3, min_numeric: 3)
    password {password}
    profile { "あア亜"}
  end
end
