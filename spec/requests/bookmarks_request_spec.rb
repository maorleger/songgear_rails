# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Bookmarks API", type: :request do
  describe "POST /api/v1/songs/:song_id/bookmarks" do
    let!(:song) { create(:song) }
    let(:name) { "Foobar" }
    let(:seconds) { 65 }
    let(:valid_attributes) {
      {
        name: name,
        seconds: seconds,
        song: song,
      }
    }
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
end
