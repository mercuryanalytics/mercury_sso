# frozen_string_literal: true

Rails.application.routes.draw do
  get :login_complete, to: "sessions#create", as: :login_complete
  get :logout, to: "sessions#destroy", as: :logout

  root to: "pages#home"
end
