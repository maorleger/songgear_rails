# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bookmarks API", type: :request do
  let(:song) { create(:song) }
  let(:name) { "Foobar" }
  let(:seconds) { 65 }
  let(:valid_attributes) {
    {
      name: name,
      seconds: seconds,
      song: song,
    }
  }
  describe "POST /api/v1/songs/:song_id/bookmarks" do
    context "when the request is valid" do
      before do
        post "/api/v1/songs/#{song.id}/bookmarks", params: { bookmark: valid_attributes }
      end

      it "creates a bookmark" do
        expect(json["name"]).to eq(name)
        expect(json["song_id"]).to eq(song.id)
      end

      it "returns status code 201" do
        expect(response).to have_http_status(201)
      end
    end

    context "when the request is invalid" do
      let(:invalid_attributes) {
        valid_attributes.merge(seconds: -1)
      }
      before do
        post "/api/v1/songs/#{song.id}/bookmarks", params: { bookmark: invalid_attributes }
      end

      it "returns 422" do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "PUT /api/v1/songs/:song_id/bookmarks/:bookmark_id" do
    let(:bookmark) { create(:bookmark, song: song) }

    def do_request(opts = {})
      arguments = {
        song_id: song.id,
        bookmark_id: bookmark.id,
        attributes: valid_attributes,
      }.merge(opts)

      put "/api/v1/songs/#{arguments[:song_id]}/bookmarks/#{arguments[:bookmark_id]}", params: { bookmark: arguments[:attributes] }
    end

    context "when the request is valid" do
      before do
        do_request
      end

      it "returns status code 200" do
        expect(response).to have_http_status(200)
      end

      it "updates the bookmark" do
        expect(json["name"]).to eq(name)
        expect(json["seconds"]).to eq(seconds)
      end
    end

    context "when the request is invalid" do
      context "because the song id is invalid" do
        it "returns 404" do
          do_request(song_id: 999)
          expect(response).to have_http_status(404)
        end
      end

      context "because the bookmark id doesnt exist" do
        it "returns 404" do
          do_request(bookmark_id: 999)
          expect(response).to have_http_status(404)
        end
      end

      context "because the bookmark belongs to a different song" do
        let(:other_bookmark) { create(:bookmark) }
        it "returns 404" do
          do_request(bookmark_id: other_bookmark.id)
          expect(response).to have_http_status(404)
        end
      end

      context "because the params are invalid" do
        let(:invalid_attributes) {
          valid_attributes.merge(seconds: -1)
        }

        it "returns 422" do
          do_request(attributes: invalid_attributes)
          expect(response).to have_http_status(422)
        end
      end
    end
  end
end
