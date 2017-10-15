# frozen_string_literal: true

require "rails_helper"

RSpec.describe YoutubeParser do
  describe ".video_id" do
    [
      "http://www.youtube.com/embed/RCUkmUXMd_k?rel=0",
      "http://www.youtube.com/user/ForceD3strategy#p/a/u/0/RCUkmUXMd_k",
      "http://www.youtube.com/v/RCUkmUXMd_k",
      "http://www.youtube.com/v/RCUkmUXMd_k?version=3&amp;hl=en_US&amp;rel=0",
      "http://www.youtube.com/watch?v=RCUkmUXMd_k",
      "http://www.youtube.com/watch?v=RCUkmUXMd_k#t=0m10s",
      "http://www.youtube.com/watch?v=RCUkmUXMd_k&feature=related",
      "http://youtu.be/RCUkmUXMd_k",
    ].each do |youtube_url|
      it "correctly parses #{youtube_url}" do
        expect(YoutubeParser.video_id(youtube_url)).to eq("RCUkmUXMd_k")
      end

    end

    it "can handle nil" do
      expect(YoutubeParser.video_id(nil)).to be_nil
    end
  end
end
