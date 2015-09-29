Rails.application.routes.draw do

  root 'events#index'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :events, only: [:index]
      resources :discussions, only: [] do
        get "attendees", to: "discussions#attendees"
      end
      resources :discussions_users, only: [:create, :destroy]
      resources :users, only: [] do
        member do
          get "discussions", to: "users#discussions"
        end
      end
    end
  end

  devise_for :users, controllers: { registrations: 'users/registrations' }

  match 'auth/failure', to: redirect('/'), via: [:get, :post]

  devise_scope :user do
    get '/auth/:provider/callback', to: 'sessions#create', as: :create
  end

  namespace :admin, only: [:index, :show] do
    resources :users do
      put 'enable' => :enable
      put 'disable' => :disable
    end
    resources :events do
      member do
        put 'enable' => :enable
        put 'disable' => :disable
      end
      resources :discussions, only: [] do
        member do
          put 'enable' => :enable
          put 'disable' => :disable
        end
      end
    end
  end

  resources :discussions_users, only: [:create, :destroy]

  resources :events do
    collection do
      get 'search' => :search
    end
    resources :discussions
  end

end
