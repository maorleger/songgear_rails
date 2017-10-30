# frozen_string_literal: true

json.extract!(
  song,
  :id,
  :title,
  :note,
  :youtube_url,
  :youtube_video_id
)

json.bookmarks song.bookmarks do |bookmark|
  json.id bookmark.id
  json.name bookmark.name
  json.seconds bookmark.seconds
end

json.url song_url(song, format: :json)
