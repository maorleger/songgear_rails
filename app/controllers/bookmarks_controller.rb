# frozen_string_literal: true

class BookmarksController < ActionController::API
  def create
    @bookmark = Song.find(params[:song_id]).bookmarks.create!(bookmark_params)
    render json: @bookmark  
  end

  private

  def bookmark_params
    params.permit(:seconds)
  end
end
