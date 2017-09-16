# frozen_string_literal: true

require "rails_helper"

RSpec.describe "songs/show", type: :view do
  let(:musician) { create(:musician) }
  before(:each) do
    @song = assign(:song, Song.create!(
                            name: "Name",
                            youtube_url: "http://youtube.com",
                            musician: musician
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match("http://youtube.com")
    expect(rendered).to match(musician.name)
  end
end
