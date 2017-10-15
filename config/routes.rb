# frozen_string_literal: true

Rails.application.routes.draw do
  resources :songs, only: [:index, :show, :new, :create]
  namespace :api do
    namespace :v1 do
      resources :songs, only: [:index, :show, :create, :update]
    end
  end

  root to: "songs#index"
end
