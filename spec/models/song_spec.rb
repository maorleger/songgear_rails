# frozen_string_literal: true

require "rails_helper"

RSpec.describe Song, type: :model do
  let(:song) { create(:song) }
  describe "validations" do
    it "validates the youtube url" do
      song.youtube_url = "foo"
      expect(song.valid?).to eq(false)
    end
  end

end
