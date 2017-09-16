# frozen_string_literal: true

require "rails_helper"


RSpec.describe MusiciansController, type: :controller do

  let(:valid_attributes) {
    {
      name: SecureRandom.hex(8)
    }
  }


  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MusiciansController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      musician = Musician.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      musician = Musician.create! valid_attributes
      get :show, params: { id: musician.to_param }, session: valid_session
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
      musician = Musician.create! valid_attributes
      get :edit, params: { id: musician.to_param }, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Musician" do
        expect {
          post :create, params: { musician: valid_attributes }, session: valid_session
        }.to change(Musician, :count).by(1)
      end

      it "redirects to the created musician" do
        post :create, params: { musician: valid_attributes }, session: valid_session
        expect(response).to redirect_to(Musician.last)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_name) { SecureRandom.hex(10) }
      let(:new_attributes) {
        { name: new_name }
      }

      it "updates the requested musician" do
        musician = Musician.create! valid_attributes
        put :update, params: { id: musician.to_param, musician: new_attributes }, session: valid_session
        musician.reload
        expect(musician.name).to eq(new_name)
      end

      it "redirects to the musician" do
        musician = Musician.create! valid_attributes
        put :update, params: { id: musician.to_param, musician: valid_attributes }, session: valid_session
        expect(response).to redirect_to(musician)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested musician" do
      musician = Musician.create! valid_attributes
      expect {
        delete :destroy, params: { id: musician.to_param }, session: valid_session
      }.to change(Musician, :count).by(-1)
    end

    it "redirects to the musicians list" do
      musician = Musician.create! valid_attributes
      delete :destroy, params: { id: musician.to_param }, session: valid_session
      expect(response).to redirect_to(musicians_url)
    end
  end

end
