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

  describe "#create" do
    describe "when the object is valid" do
      it "creates the object and returns it" do
        actual = subject.create(title: "foo", note: "hello")

        expect(actual.title).to eq("foo")
        expect(actual.note).to eq("hello")
        expect(actual.valid?).to eq(true)
        expect(actual.persisted?).to eq(true)
      end
    end

    describe "when the object is invalid" do
      it "returns nil and does not save the object" do
        actual = subject.create(title: nil)

        expect(actual.valid?).to eq(false)
        expect(actual.persisted?).to eq(false)
      end
    end
  end

  describe "#update" do
    let(:song) { create(:song) }
    describe "when the object is valid" do
      it "updates the object and returns it" do
        actual = subject.update(song, title: "foo", note: "hello")

        expect(actual.title).to eq("foo")
        expect(actual.note).to eq("hello")
        expect(actual.valid?).to eq(true)
      end
    end

    describe "when the object is invalid" do
      it "returns nil and does not save the object" do
        actual = subject.update(song, title: nil)

        expect(actual.valid?).to eq(false)
      end
    end
  end
end
