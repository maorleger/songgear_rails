# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Songs API", type: :request do
  NUM_BOOKMARKS = 3
  NUM_SONGS = 10

  let(:youtube_video_id) { SecureRandom.hex(8) }
  let(:youtube_url) { "https://www.youtube.com/watch?v=#{youtube_video_id}" }
  let!(:songs) {
    create_list(
      :song_with_bookmarks,
      NUM_SONGS,
      youtube_url: youtube_url,
      bookmarks_count: NUM_BOOKMARKS
    )
  }
  let(:song) { songs.first }
  let(:song_id) { song.id }

  describe "GET /api/v1/songs" do
    before { get "/api/v1/songs" }

    it "returns songs" do
      expect(json).not_to be_empty
      expect(json.size).to eq(NUM_SONGS)
    end

    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /api/v1/songs/:id" do
    before { get "/api/v1/songs/#{song_id}" }

    context "when the record exists" do
      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

      it "returns the song" do
        expect(json).not_to be_empty
        expect(json["id"]).to eq(song_id)
        expect(json["youtubeVideoId"]).to eq(youtube_video_id)
      end

      describe "bookmarks" do
        it "returns all the bookmarks of the song" do
          expect(json["bookmarks"].size).to eq(NUM_BOOKMARKS)
        end

        it "returns the bookmarks in order" do
          expected_order = song.bookmarks.pluck(:id)
          expect(json["bookmarks"].map { |b| b["id"] }).to eq(expected_order)
        end
      end

    end

    describe "when the record does not exist" do
      let (:song_id) { Song.last.id + 100 }

      it "returns status code 404" do
        expect(response).to have_http_status(404)
      end

      it "returns a not found message" do
        expect(response.body).to match(/Couldn't find Song/)
      end
    end

    describe "POST /api/v1/songs" do
      let(:title) { "Foobar" }
      let(:note) { "My note" }
      let(:valid_attributes) {
        {
          note: note,
          title: title,
        }
      }

      context "when the request is valid" do
        before do
          post "/api/v1/songs", params: { song: valid_attributes }
        end

        it "creates a song" do
          expect(json["title"]).to eq(title)
        end

        it "returns status code 201" do
          expect(response).to have_http_status(201)
        end
      end

      context "when the request is invalid" do
        let(:invalid_attributes) {
          valid_attributes.merge(title: nil)
        }

        before do
          post "/api/v1/songs", params: { song: invalid_attributes }
        end

        it "returns status code 422" do
          expect(response).to have_http_status(422)
        end
      end
    end

    describe "PUT /api/v1/songs/:id" do
      let(:new_title) { "Barfoo" }
      let(:new_note) { "Updated" }
      let(:valid_attributes) {
        {
          note: new_note,
          title: new_title,
        }
      }

      context "when the record exists" do
        before do
          put "/api/v1/songs/#{song_id}", params: { song: valid_attributes }
        end

        it "updates the record" do
          song = Song.find(song_id)
          expect(song.note).to eq(new_note)
          expect(song.title).to eq(new_title)
        end
      end
    end
  end
end
