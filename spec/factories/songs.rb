# frozen_string_literal: true

FactoryGirl.define do
  factory :song do
    title { Faker::Lorem.word }
  end
end
