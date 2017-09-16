# frozen_string_literal: true

require "rails_helper"

RSpec.describe "musicians/show", type: :view do
  before(:each) do
    @musician = assign(:musician, Musician.create!(
                                    name: "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
