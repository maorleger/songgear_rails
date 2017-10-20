# frozen_string_literal: true

FactoryGirl.define do
  factory :bookmark do
    name { Faker::Music.instrument }
    seconds { Faker::Number.between(1, 120) }
  end
end
