# frozen_string_literal: true

require "rails_helper"

RSpec.describe SongsController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns all of the songs from the repository" do
      expected = [1, 2, 3]
      allow_any_instance_of(SongRepository).to receive(:all).and_return(expected)

      get :index

      expect(assigns(:songs)).to eq(expected)
    end
  end

  describe "GET #show" do
    let (:song_id) { "1337" }

    it "returns http success" do
      expected = { foo: "bar" }
      allow_any_instance_of(SongRepository).to receive(:get).with(song_id).and_return(expected)

      get :show, params: { id: song_id }

      expect(response).to have_http_status(:success)
      expect(assigns(:song)).to eq(expected)
    end
  end

  describe "POST #create" do
    it "creates new song" do
      params = { title: "foo", youtube_url: "bar", note: "all your base are belong to us" }
      expect_any_instance_of(SongRepository).to receive(:create).with(params.with_indifferent_access).and_return("/")

      post :create, params: { song: params.merge!(random_param: "better not see this") }
    end
  end
end
