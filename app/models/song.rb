# frozen_string_literal: true

class Song < ApplicationRecord
  belongs_to :musician
  has_many :bookmarks
  validates :youtube_url, url: true, allow_blank: true

  accepts_nested_attributes_for :bookmarks,
    allow_destroy: true,
    reject_if: :all_blank
end
