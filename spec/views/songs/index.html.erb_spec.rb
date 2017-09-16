# frozen_string_literal: true

require "rails_helper"

RSpec.describe "songs/index", type: :view do
  let(:musician) { create(:musician) }
  before(:each) do
    assign(:songs, [
      Song.create!(
        name: "Name",
        youtube_url: "http://youtube.com",
        musician: musician
      ),
      Song.create!(
        name: "Name",
        youtube_url: "http://youtube.com",
        musician: musician
      )
    ])
  end

  it "renders a list of songs" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "http://youtube.com".to_s, count: 2
    assert_select "tr>td", text: musician.to_s, count: 2
  end
end
