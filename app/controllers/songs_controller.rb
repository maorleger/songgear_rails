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
      params.require(:song).permit(:title, :note, :youtube_url)
    end
end
