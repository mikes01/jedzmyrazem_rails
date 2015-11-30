Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  root 'home#index'

  post 'journeys', to: 'journeys#create'
  get 'journeys', to: 'journeys#search'
end
