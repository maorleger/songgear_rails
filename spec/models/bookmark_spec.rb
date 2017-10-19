# frozen_string_literal: true

require "rails_helper"

RSpec.describe Bookmark, type: :model do
  it { is_expected.to belong_to(:song) }
  it do
    is_expected.to validate_numericality_of(:seconds)
      .is_greater_than(0)
  end
end
