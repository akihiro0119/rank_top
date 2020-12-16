FactoryBot.define do
  factory :user do
    name {Faker::Name.last_name}
    email {Faker::Internet.free_email}
    password = Faker::Alphanumeric.alphanumeric(number: 6)
    password {password}
    password_confirmation {password}
    profile { "あア亜"}
  end
end
