# frozen_string_literal: true

Rails.application.routes.draw do
  root "docs#index"
  get "docs/:id", to: "docs#show", as: :doc
  get "gallery", to: "gallery#index"
  get "create", to: "create#index"
end
