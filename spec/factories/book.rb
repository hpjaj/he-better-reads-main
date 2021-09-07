FactoryBot.define do
  factory :book do
    author
    title { Faker::Book.title }
    description { Faker::Hipster.paragraphs(number: (5..10).to_a.sample).join(' ') }
  end
end
