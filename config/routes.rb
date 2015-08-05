Rails.application.routes.draw do

  root 'events#index'

  put 'discussions/:id/rsvp', to: 'discussions#add_rsvp', as: :add_rsvp
  delete 'discussions/:id/rsvp', to: 'discussions#delete_rsvp', as: :delete_rsvp

  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :admin, only: [:index, :show] do
    resources :users do
      put 'enable', to: 'users#enable', as: :enable
      put 'disable', to: 'users#disable', as: :disable
    end
    resources :events do
      put 'enable', to: 'events#enable', as: :enable
      put 'disable', to: 'events#disable', as: :disable
      resources :discussions, only: [] do
        member do
          put 'enable', to: 'discussions#enable', as: :enable
          put 'disable', to: 'discussions#disable', as: :disable
        end
      end
    end
  end

  resources :events do
    resources :discussions
  end

end
