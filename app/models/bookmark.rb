# frozen_string_literal: true

class Bookmark < ApplicationRecord
  belongs_to :song
  validates :seconds, numericality: { greater_than: 0 }
end
