# frozen_string_literal: true

require "rails_helper"

RSpec.describe "musicians/edit", type: :view do
  before(:each) do
    @musician = assign(:musician, Musician.create!(
                                    name: "MyString"
    ))
  end

  it "renders the edit musician form" do
    render

    assert_select "form[action=?][method=?]", musician_path(@musician), "post" do

      assert_select "input[name=?]", "musician[name]"
    end
  end
end
