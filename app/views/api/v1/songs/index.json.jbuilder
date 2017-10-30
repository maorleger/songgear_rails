# frozen_string_literal: true

json.array! @songs, partial: "api/v1/songs/song", as: :song
