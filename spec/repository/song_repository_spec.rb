# frozen_string_literal: true

require "rails_helper"

RSpec.describe SongRepository do

  let (:subject) { SongRepository.new }

  it "extends generic repository" do
    expect(SongRepository).to be < Repository
  end

end
