# frozen_string_literal: true

json.extract! song, :name, :youtube_url, :musician_id, :created_at, :updated_at
json.musician do
  json.name @song.musician.name
  json.id @song.musician.id
end
json.url song_url(song, format: :json)
