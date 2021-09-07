FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email, 1000) { |n| "user_#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
