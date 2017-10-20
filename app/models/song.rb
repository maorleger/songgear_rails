# frozen_string_literal: true

class Song < ApplicationRecord
  validates :youtube_url, url: true, allow_blank: true
  validates :title, presence: true
  has_many :bookmarks, dependent: :destroy

  def as_json(options = {})
    super((options || {}).merge(methods: [:youtube_video_id], include: :bookmarks))
  end

  def youtube_video_id
    YoutubeParser.video_id(youtube_url)
  end
end
