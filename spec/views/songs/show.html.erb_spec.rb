# frozen_string_literal: true

require "rails_helper"

RSpec.describe "songs/show.html.erb", type: :view do
  let(:song) { build_stubbed(:song) }
  before do
    assign(:song, song)
    render
  end

  it "includes the song id in a data attribute" do
    expect(rendered).to include("data-song-id=#{song.id}")
  end
end
