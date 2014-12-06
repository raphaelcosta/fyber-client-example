Rails.application.routes.draw do
  root 'offers#index'

  get 'search', to: 'offers#index', as: :offers
  post 'search', to: 'offers#search', as: :search_offers
end
