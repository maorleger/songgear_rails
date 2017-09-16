# frozen_string_literal: true

FactoryGirl.define do
  factory :musician do
    name { Faker::RockBand.name }
  end
end
