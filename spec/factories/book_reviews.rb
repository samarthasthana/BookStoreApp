require 'faker'

FactoryGirl.define do
  factory :book_review do |f|
    f.book_id { Faker::Number.between(1, 1000) }
    f.rating { Faker::Number.between(1, 5) }
  end
end
