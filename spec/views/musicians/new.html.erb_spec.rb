# frozen_string_literal: true

require "rails_helper"

RSpec.describe "musicians/new", type: :view do
  before(:each) do
    assign(:musician, Musician.new(
                        name: "MyString"
    ))
  end

  it "renders new musician form" do
    render

    assert_select "form[action=?][method=?]", musicians_path, "post" do

      assert_select "input[name=?]", "musician[name]"
    end
  end
end
