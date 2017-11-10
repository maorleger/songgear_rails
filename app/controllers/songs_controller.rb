# frozen_string_literal: true

class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update]

  def index
    @songs = repository.all
  end

  def show; end

  def new
    @song = Song.new
  end

  def create
    @song = repository.create(song_params)
    if @song.valid?
      redirect_to song_path(@song)
    else
      render :new
    end
  end

  def edit; end

  def update
    @song = repository.update(@song, song_params)
    if @song.valid?
      redirect_to song_path(@song)
    else
      render :edit
    end
  end

  private

    def set_song
      @song = repository.get(params[:id])
    end

    def repository
      @repository ||= SongRepository.new
    end

    def song_params
      params.require(:song).permit(:title, :note, :youtube_url)
    end
end
