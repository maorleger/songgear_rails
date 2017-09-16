# frozen_string_literal: true

require "rails_helper"

RSpec.describe MusiciansController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "/musicians").to route_to("musicians#index")
    end

    it "routes to #new" do
      expect(get: "/musicians/new").to route_to("musicians#new")
    end

    it "routes to #show" do
      expect(get: "/musicians/1").to route_to("musicians#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/musicians/1/edit").to route_to("musicians#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/musicians").to route_to("musicians#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/musicians/1").to route_to("musicians#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/musicians/1").to route_to("musicians#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/musicians/1").to route_to("musicians#destroy", id: "1")
    end

  end
end
