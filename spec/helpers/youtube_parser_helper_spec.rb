# frozen_string_literal: true

require "rails_helper"

# Specs in this file have access to a helper object that includes
# the YoutubeParserHelper. For example:
#
# describe YoutubeParserHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe YoutubeParserHelper, type: :helper do
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
        expect(YoutubeParserHelper.video_id(youtube_url)).to eq("RCUkmUXMd_k")
      end
    end
  end
end
