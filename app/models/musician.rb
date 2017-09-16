# frozen_string_literal: true

class Musician < ApplicationRecord
  has_many :songs

  def to_s
    name
  end
end
