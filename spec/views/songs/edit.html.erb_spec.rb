# frozen_string_literal: true

require "rails_helper"

RSpec.describe "songs/edit", type: :view do
  let(:musician) { create(:musician) }
  before(:each) do
    @song = assign(:song, Song.create!(
                            name: "MyString",
                            youtube_url: "http://youtube.com",
                            musician: musician
    ))
  end

  it "renders the edit song form" do
    render

    assert_select "form[action=?][method=?]", song_path(@song), "post" do

      assert_select "input[name=?]", "song[name]"

      assert_select "input[name=?]", "song[youtube_url]"

      assert_select "input[name=?]", "song[musician_id]"
    end
  end
end
