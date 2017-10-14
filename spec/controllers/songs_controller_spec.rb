# frozen_string_literal: true

require "rails_helper"

RSpec.describe SongsController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      song = create(:song)
      get :show, params: { id: song.to_param }
      expect(response).to have_http_status(:success)
      expect(assigns(:song)).to eq(song)
    end
  end
end
