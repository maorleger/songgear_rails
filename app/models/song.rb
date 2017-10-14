# frozen_string_literal: true

class Song < ApplicationRecord
  validates :youtube_url, url: true, allow_blank: true
end
