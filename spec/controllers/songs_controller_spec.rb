# frozen_string_literal: true

require "rails_helper"

RSpec.describe SongsController, type: :controller do

  let(:musician) { create(:musician) }
  let(:valid_attributes) {
    {
      name: SecureRandom.hex(8),
      musician_id: musician.id
    }
  }

  let(:invalid_attributes) {
    {
      musician_id: nil
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SongsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      Song.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      song = Song.create! valid_attributes
      get :show, params: { id: song.to_param }, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      song = Song.create! valid_attributes
      get :edit, params: { id: song.to_param }, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Song" do
        expect {
          post :create, params: { song: valid_attributes }, session: valid_session
        }.to change(Song, :count).by(1)
      end

      it "redirects to the created song" do
        post :create, params: { song: valid_attributes }, session: valid_session
        expect(response).to redirect_to(Song.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { song: invalid_attributes }, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_musician) { create(:musician) }
      let(:new_name) { SecureRandom.hex(22) }
      let(:new_attributes) {
        {
          name: new_name,
          musician_id: new_musician.id,
        }
      }

      it "updates the requested song" do
        song = Song.create! valid_attributes
        put :update, params: { id: song.to_param, song: new_attributes }, session: valid_session
        song.reload
        expect(song.name).to eq(new_name)
        expect(song.musician_id).to eq(new_musician.id)
      end

      it "redirects to the song" do
        song = Song.create! valid_attributes
        put :update, params: { id: song.to_param, song: valid_attributes }, session: valid_session
        expect(response).to redirect_to(song)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        song = Song.create! valid_attributes
        put :update, params: { id: song.to_param, song: invalid_attributes }, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested song" do
      song = Song.create! valid_attributes
      expect {
        delete :destroy, params: { id: song.to_param }, session: valid_session
      }.to change(Song, :count).by(-1)
    end

    it "redirects to the songs list" do
      song = Song.create! valid_attributes
      delete :destroy, params: { id: song.to_param }, session: valid_session
      expect(response).to redirect_to(songs_url)
    end
  end

end
