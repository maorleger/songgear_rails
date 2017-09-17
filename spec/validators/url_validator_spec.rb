# frozen_string_literal: true

require "rails_helper"

RSpec.describe "UrlValidator" do
  let(:klass) do
    Class.new do
      include ActiveModel::Validations
      validates :url, url: true
      attr_accessor :url
    end
  end

  subject { klass.new }

  describe "valid URLs" do
    [
      "http://www.google.com",
      "https://www.youtube.com/x1843904",
      "https://you.be/watch?v=32323",
    ].each do |url|
      it "should be valid for #{url}" do
        subject.url = url
        expect(subject).to be_valid
      end
    end
  end

  describe "for invalid URLs" do
    [
      "foobar",
      "foo.bar",
      "",
    ].each do |url|
      it "should not be valid for #{url}" do
        subject.url = url
        expect(subject).not_to be_valid
      end
    end
  end
end
