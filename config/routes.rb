Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  root 'home#index'

  resources :journeys

  post 'journeys/search', to: 'journeys#search'
end
