# frozen_string_literal: true

class Bookmark < ApplicationRecord
  belongs_to :song
  validates :seconds, numericality: { greater_than_or_equal_to: 0 }
end
