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

  describe "GET #new" do
    it "sets the song to a new object" do
      get :new
      expect(assigns(:song)).not_to be_nil
      expect(assigns(:song).new_record?).to eq(true)
    end
  end

  describe "POST #create" do
    let(:song) { instance_double("song") }
    describe "when song is valid" do
      it "creates new song" do
        params = { title: "foo", youtube_url: "bar", note: "all your base are belong to us" }
        expect_any_instance_of(SongRepository).to receive(:create).with(params.with_indifferent_access).and_return(song)
        allow(song).to receive(:valid?).and_return(true)

        post :create, params: { song: params.merge!(random_param: "better not see this") }
        expect(response).to redirect_to(song_path(song))
      end
    end

    describe "when validation fails" do
      it "does not create a new song" do
        params = { title: "", youtube_url: "bar", note: "all your base are belong to us" }
        expect_any_instance_of(SongRepository).to receive(:create).with(params.with_indifferent_access).and_return(song)
        allow(song).to receive(:valid?).and_return(false)

        post :create, params: { song: params }
        expect(response).to be_success
      end
    end
  end

  describe "GET #edit" do
    let(:song) { build_stubbed(:song) }

    describe "when the request is valid" do
      it "sets the song correctly" do
        expect_any_instance_of(SongRepository).to receive(:get).with(song.id.to_s).and_return(song)
        get :edit, params: { id: song.id }
        expect(assigns(:song)).to eq(song)
      end
    end

    describe "when the request is invalid" do
      it "returns 404" do
        get :edit, params: { id: 999 }
        expect(assigns(:song)).to be_nil
        expect(response).to have_http_status(404)
      end
    end

  end
end
