require 'faker'

FactoryGirl.define do
  factory :book_format_type do |f|
    f.name  { Faker::Lorem.word }
    f.physical true
  end
end
