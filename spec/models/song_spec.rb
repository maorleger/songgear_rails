# frozen_string_literal: true

require "rails_helper"

RSpec.describe Song, type: :model do
  subject do
    build_stubbed(:song)
  end

  it { should have_many(:bookmarks) }

  describe "validations" do
    describe "youtube_url" do
      it "can validate a bad youtube url" do
        subject.youtube_url = "foo"
        expect(subject.valid?).to eq(false)
        expect(subject.errors.details).to eq(
          youtube_url: [{ error: "is not a valid URL" }]
        )
      end

      it "can validate a good youtube url" do
        subject.youtube_url = "https://youtube.com"
        expect(subject.valid?).to eq(true)
      end

      it "allows blank" do
        subject.youtube_url = ""
        expect(subject.valid?).to eq(true)
      end
    end

    describe "title" do
      it "is required" do
        subject.title = nil
        expect(subject.valid?).to eq(false)
        expect(subject.errors.details).to eq(
          title: [{ error: :blank }]
        )
      end
    end
  end

  describe "#youtube_video_id" do
    it "uses the youtube helper parser" do
      expected_video_id = "9h44jOQG4Q"
      subject.youtube_url = "https://www.youtube.com/watch?v=#{expected_video_id}"
      expect(subject.youtube_video_id).to eq(expected_video_id)
    end

    it "can handle nil" do
      expect(subject.youtube_video_id).to be_nil
    end
  end

  describe "#as_json" do
    it "includes youtube_video_id" do
      expected_video_id = "9h44jOQG4Q"
      subject.youtube_url = "https://www.youtube.com/watch?v=#{expected_video_id}"
      expect(JSON.load(subject.to_json)).to include("youtube_video_id" => expected_video_id)
    end
  end
end
