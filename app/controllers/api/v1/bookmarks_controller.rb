# frozen_string_literal: true

module Api
  module V1
    class BookmarksController < ApplicationController
      before_action :set_song, only: [:create, :update, :destroy]
      before_action :set_bookmark, only: [:update, :destroy]

      def create
        @bookmark = @song.bookmarks.create!(bookmark_params)
        json_response(@bookmark, :created)
      end

      def update
        @bookmark.update!(bookmark_params)
        json_response(@bookmark)
      end

      def destroy
        @bookmark.destroy
        head :no_content
      end

      private
        def set_song
          @song = Song.find(params[:song_id])
        end

        def set_bookmark
          @bookmark = @song.bookmarks.find(params[:id])
        end

        def bookmark_params
          params.require(:bookmark).permit(:name, :seconds)
        end
    end
  end
end
