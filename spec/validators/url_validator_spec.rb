# frozen_string_literal: true

require "rails_helper"

RSpec.describe "UrlValidator" do

  describe "#valid_url?" do
    describe "valid URLs" do
      [
        "http://www.google.com",
        "https://www.youtube.com/x1843904",
        "https://you.be/watch?v=32323",
      ].each do |url|
        it "returns true for #{url}" do
          expect(UrlValidator.valid_url?(url)).to eq(true)
        end
      end
    end

    describe "for invalid URLs" do
      [
        "foobar",
        "foo.bar",
        "",
      ].each do |url|
        it "returns false #{url}" do
          expect(UrlValidator.valid_url?(url)).to eq(false)
        end
      end
    end
  end
end
