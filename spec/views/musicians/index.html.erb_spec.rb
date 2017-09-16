# frozen_string_literal: true

require "rails_helper"

RSpec.describe "musicians/index", type: :view do
  before(:each) do
    assign(:musicians, [
      Musician.create!(
        name: "Name"
      ),
      Musician.create!(
        name: "Name"
      )
    ])
  end

  it "renders a list of musicians" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
  end
end
