# frozen_string_literal: true

module Api
  module V1
    class SongsController < ApiController
      before_action :set_song, only: [:show, :update]

      def index
        @songs = Song.all
      end

      def show; end

      def create
        @song = Song.create!(song_params)
        json_response(@song, :created)
      end

      def update
        @song.update(song_params)
        head :no_content
      end

      private

        def set_song
          @song = Song.find(params[:id])
        end

        def song_params
          params.require(:song).permit(:title, :note, :youtube_url)
        end
    end
  end
end
