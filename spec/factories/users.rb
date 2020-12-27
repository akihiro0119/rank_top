FactoryBot.define do
  factory :user do
    name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password = Faker::Alphanumeric.alphanumeric(number: 6, min_alpha: 3, min_numeric: 3)
    password { password }
    profile { 'あア亜' }

    trait :with_picture do
      image { File.new("#{Rails.root}/spec/fixtures/image.png") }
    end
  end
end
