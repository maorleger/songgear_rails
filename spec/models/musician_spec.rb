# frozen_string_literal: true

require "rails_helper"

RSpec.describe Musician, type: :model do
  let(:musician) { create(:musician) }
  describe "#to_s" do
    it "returns the musician's name" do
      expect(musician.to_s).to eq(musician.name)
    end
  end
end
