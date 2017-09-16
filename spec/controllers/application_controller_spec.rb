# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller(ApplicationController) do
    before_action :authenticate
    def index
      render plain: "some value"
    end
  end

  describe "#authenticate" do
    it "redirects when user is not signed in" do
      get :index
      expect(response).to redirect_to(login_path)
    end

    it "does not redirect when the user is signed in" do
      allow(subject).to receive(:current_user).and_return("a mock")
      get :index
      expect(response).not_to redirect_to(login_path)
    end
  end
end
