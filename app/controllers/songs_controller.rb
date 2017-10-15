# frozen_string_literal: true

class SongsController < ApplicationController
  def index
    @songs = repository.all
  end

  def show
    @song = repository.get(params[:id])
  end

  private

  def repository
    @repository ||= SongRepository.new
  end
end
