# frozen_string_literal: true

module Api
  module V1
    class BookmarksController < ApplicationController
      def create
        @song = Song.find(params[:song_id])
        @bookmark = @song.bookmarks.create!(bookmark_params)
        json_response(@bookmark, :created)
      end

      private

        def bookmark_params
          params.require(:bookmark).permit(:name, :seconds)
        end
    end
  end
end
