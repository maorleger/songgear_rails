# frozen_string_literal: true

Rails.application.routes.draw do
  resources :songs
  namespace :api do
    namespace :v1 do
      resources :songs, only: [:index, :show, :create, :update] do
        resources :bookmarks, only: [:create, :update, :destroy]
      end
    end
  end

  root to: "songs#index"
end
