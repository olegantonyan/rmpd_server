Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: {
    sessions:       'devise_users/sessions',
    confirmations:  'devise_users/confirmations',
    passwords:      'devise_users/passwords',
    registrations:  'devise_users/registrations',
    unlocks:        'devise_users/unlocks'
  }

  require 'sidekiq/web'
  authenticate :user, -> (u) { u.root? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  concern :playlist_assignable do
    resource :playlist_assignment, only: %i(update)
  end

  resources :news_items, path: :news
  resources :media_items, except: %i(edit update create) do
    collection do
      post :create_multiple
      delete :destroy_multiple
    end
  end
  resources :device_groups, concerns: :playlist_assignable
  resources :devices, concerns: :playlist_assignable do
    resources :device_log_messages, only: %i(index)
    resources :ssh_tunnels, only: %i(new create)
  end
  resources :playlists do
    resources :playlist_items, only: %i(show)
  end
  resources :companies
  resources :users, only: %i(index show edit update destroy)

  namespace :deviceapi, defaults: { format: :json } do
    resources :status, only: %i(create)
  end
end
