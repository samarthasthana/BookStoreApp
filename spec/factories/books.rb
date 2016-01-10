require 'faker'

FactoryGirl.define do
  factory :book do |f|
    f.title { Faker::Lorem.sentence }
    f.publisher_id { Faker::Number.between(1, 1000) }
    f.author_id {Faker::Number.between(1, 1000)}
  end
end
