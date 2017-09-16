# frozen_string_literal: true

json.extract! musician, :id, :name, :created_at, :updated_at
json.url musician_url(musician, format: :json)
