Rails.application.routes.draw do
  namespace :api do
    resources :authors, only: [:create, :index, :show, :update]
    resources :books, only: [:create, :index, :show, :update], param: :uuid
    resources :users, only: [:create, :index, :show, :update]
  end
end
