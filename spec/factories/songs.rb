# frozen_string_literal: true

FactoryGirl.define do
  factory :song do
    title { Faker::Lorem.word }

    factory :song_with_bookmarks do
      transient do
        bookmarks_count 2
      end
    end

    after(:create) do |song, evaluator|
      create_list(:bookmark, evaluator.bookmarks_count, song: song)
    end
  end
end
