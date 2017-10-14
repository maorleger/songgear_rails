# frozen_string_literal: true

module YoutubeParserHelper
  FORMATS = [
    %r(https?://youtu\.be/(.+)),
    %r(https?://www\.youtube\.com/watch\?v=(.*?)(&|#|$)),
    %r(https?://www\.youtube\.com/embed/(.*?)(\?|$)),
    %r(https?://www\.youtube\.com/v/(.*?)(#|\?|$)),
    %r(https?://www\.youtube\.com/user/.*?#\w/\w/\w/\w/(.+)\b)
  ]
  def self.video_id(url)
    return nil if url.blank?
    video_url = url.strip
    FORMATS.find { |format| video_url =~ format } && $1
  end
end
