# frozen_string_literal: true

require "rails_helper"

RSpec.describe "songs/new", type: :view do
  before(:each) do
    assign(:song, Song.new(
                    name: "MyString",
                    youtube_url: "http://youtube.com",
                    musician: create(:musician)
    ))
  end

  it "renders new song form" do
    render

    assert_select "form[action=?][method=?]", songs_path, "post" do

      assert_select "input[name=?]", "song[name]"

      assert_select "input[name=?]", "song[youtube_url]"

      assert_select "input[name=?]", "song[musician_id]"
    end
  end
end
