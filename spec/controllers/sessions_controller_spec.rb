# frozen_string_literal: true

require "rails_helper"

RSpec.describe SessionsController, type: :controller do
  before do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google]
  end

  describe "GET #create" do
    it "should create a user" do
      expect {
        do_request
      }.to change { User.count }.by(1)
    end

    it "sets the user" do
      expect(session[:user_id]).to be_nil

      do_request

      expect(session[:user_id]).to eq(User.last.id)
    end

    it "redirects to the me controller" do
      do_request
      expect(response).to redirect_to(me_path)
    end
  end

  describe "GET #destroy" do
    before do
      do_request
    end

    it "should clear the session" do
      expect(session[:user_id]).not_to be_nil

      get :destroy

      expect(session[:user_id]).to be_nil
    end

    it "should redirect to the root path" do
      get :destroy

      expect(response).to redirect_to(root_path)
    end
  end
end

def do_request
  get :create, params: { provider: "google_oauth2" }
end
