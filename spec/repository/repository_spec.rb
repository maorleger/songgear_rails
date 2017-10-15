# frozen_string_literal: true

require "rails_helper"

RSpec.describe Repository do
  class TestRepository < Repository
    def initialize
      super(Song)
    end
  end

  let (:subject) { TestRepository.new }

  describe "#all" do
    it "returns all songs in the database" do
      song_one = create(:song)
      song_two = create(:song)

      actual = subject.all

      expect(actual).to eq([song_one, song_two])
    end
  end

  describe "#get" do
    it "returns the song by id" do
      create(:song)
      song_two = create(:song)

      actual = subject.get(song_two.id)

      expect(actual).to eq(song_two)
    end
  end
end
