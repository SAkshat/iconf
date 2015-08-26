Rails.application.routes.draw do

  root 'events#index'

  devise_for :users, controllers: { registrations: 'users/registrations' }

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
