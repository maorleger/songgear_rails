# frozen_string_literal: true

require "rails_helper"
require "ostruct"
require "pry"

RSpec.describe User, type: :model do
  let!(:auth_hash) { OmniAuth.config.mock_auth[:google] }

  describe ".find_or_create_from_auth_hash" do
    describe "when the user does not exist" do
      it "creates the user if none exists" do
        expect {
          User.find_or_create_from_auth_hash(auth_hash)
        }.to change { User.count }.by(1)
      end

      it "correctly initializes the user" do
        created_user = User.find_or_create_from_auth_hash(auth_hash)
        expect(created_user.provider).to eq(auth_hash.provider)
        expect(created_user.uid).to eq(auth_hash.uid)
        expect(created_user.first_name).to eq(auth_hash.info.first_name)
        expect(created_user.last_name).to eq(auth_hash.info.last_name)
        expect(created_user.email).to eq(auth_hash.info.email)
        expect(created_user.picture).to eq(auth_hash.info.image)
      end
    end

    describe "when the user already exists" do
      let!(:existing_user) { User.find_or_create_from_auth_hash(auth_hash) }

      it "returns the existing user" do
        expect(User.find_or_create_from_auth_hash(auth_hash).id).to eq(existing_user.id)
      end

      it "does not create another user" do
        expect {
          User.find_or_create_from_auth_hash(auth_hash)
        }.not_to change { User.count }
      end
    end
  end
end
