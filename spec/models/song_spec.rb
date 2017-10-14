# frozen_string_literal: true

require "rails_helper"

RSpec.describe Song, type: :model do
  let(:song) { build_stubbed(:song) }

  describe "validations" do
    it "can validate a bad youtube url" do
      song.youtube_url = "foo"
      expect(song.valid?).to eq(false)
    end

    it "can validate a good youtube url" do
      song.youtube_url = "https://youtube.com"
      expect(song.valid?).to eq(true)
    end

    it "allows blank" do
      song.youtube_url = ""
      expect(song.valid?).to eq(true)
    end
  end
end
