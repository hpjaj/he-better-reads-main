FactoryBot.define do
  factory :review do
    user
    reviewable { FactoryBot.create(:book) }
    rating { 3 }
    description { Faker::Hipster.paragraphs(number: (5..10).to_a.sample).join(' ') }
  end
end
