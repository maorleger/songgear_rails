# frozen_string_literal: true

Rails.application.routes.draw do
  resources :songs
  resources :musicians
  resources :home, only: [:show]

  # TODO: write integration tests for these routes
  get "login", to: redirect("/auth/google_oauth2"), as: "login"
  get "logout", to: "sessions#destroy", as: "logout"

  get "auth/:provider/callback", to: "sessions#create"
  get "auth/failure", to: redirect("/")

  get "me", to: "me#show"

  root to: "home#show"
end
