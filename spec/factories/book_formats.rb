require 'faker'

FactoryGirl.define do
  factory :book_format do |f|
    f.book_id { Faker::Number.between(1, 1000) }
    f.book_format_type_id {Faker::Number.between(1, 1000)}
  end
end
