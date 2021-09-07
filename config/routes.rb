Rails.application.routes.draw do
  namespace :api do
    resources :authors, only: [:create, :index, :show, :update]
    resources :books, only: [:create, :index, :show, :update], param: :uuid
    resources :reviews, only: [:index, :create], path: 'reviews/:reviewable_type/:reviewable_id'
    resource :sessions, only: [:create, :show, :destroy]
    resources :users, only: [:create, :index, :show, :update]
  end
end
