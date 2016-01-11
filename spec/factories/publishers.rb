require 'faker'

FactoryGirl.define do
  factory :publisher do |f|
    f.name { Faker::Name.first_name }
    f.description { Faker::Lorem.sentence }
  end
end
