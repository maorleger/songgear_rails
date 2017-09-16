# frozen_string_literal: true

json.extract! song, :id, :name, :youtube_url, :musician_id, :created_at, :updated_at
json.url song_url(song, format: :json)
