# frozen_string_literal: true

class SongsController < ApplicationController
  def index
    @songs = repository.all
  end

  def show
    @song = repository.get(params[:id])
  end

  def new
    @song = Song.new
  end

  def create
    new_song = repository.create(song_params)
    redirect_to new_song
  end

  private

    def repository
      @repository ||= SongRepository.new
    end

    def song_params
      song = params[:song]
      { title: song[:title],
        youtube_url: song[:youtube_url],
        note: song[:note]
      }
    end
end
