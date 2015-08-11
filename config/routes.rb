Rails.application.routes.draw do

  root 'events#index'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  devise_scope :user do
    get '/auth/:provider/callback', to: 'sessions#create', as: :create
  end

  namespace :admin, only: [:index, :show] do
    resources :users do
      put 'enable', to: 'users#enable', as: :enable
      put 'disable', to: 'users#disable', as: :disable
    end
    resources :events do
      member do
        put 'enable', to: 'events#enable', as: :enable
        put 'disable', to: 'events#disable', as: :disable
      end
      resources :discussions, only: [] do
        member do
          put 'enable', to: 'discussions#enable', as: :enable
          put 'disable', to: 'discussions#disable', as: :disable
        end
      end
    end
  end

  resources :discussions_users, only: [:create, :destroy]

  resources :events do
    resources :discussions
  end

end
