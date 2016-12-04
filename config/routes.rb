Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, controllers: {
    sessions:       'devise_users/sessions',
    confirmations:  'devise_users/confirmations',
    passwords:      'devise_users/passwords',
    registrations:  'devise_users/registrations',
    unlocks:        'devise_users/unlocks'
  }
  get '/users/sign_up_via_invite', to: 'devise_users/invites#sign_up'
  post '/users/sign_up_via_invite/accept', to: 'devise_users/invites#create'

  require 'sidekiq/web'
  authenticate :user, -> (u) { u.root? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  concern :playlist_assignable do
    resource :playlist_assignment, only: %i(update)
  end

  resources :news_items, path: :news
  resources :media_items, except: %i(create) do
    collection do
      post :create_multiple
      delete :destroy_multiple
    end
  end
  resources :device_groups, concerns: :playlist_assignable
  resources :devices, concerns: :playlist_assignable do
    resources :device_log_messages, only: %i(index)
    resources :ssh_tunnels, only: %i(new create)
    resource :software_update, only: %i(new create)
    resources :device_service_uploads, only: %i(index) do
      post 'manual_request', on: :collection
    end
  end
  resources :playlists do
    resources :playlist_items, only: %i(show)
  end
  resources :companies do
    post 'leave', on: :member
    resources :invites, only: %i(create destroy)
  end
  resources :users, only: %i(index show edit update destroy)
  resource :device_binds, only: %i(create new)

  namespace :deviceapi, defaults: { format: :json } do
    resources :status, only: %i(create)
    resource :service_upload, only: %i(create)
  end

  namespace :api, defaults: { format: :json } do
    post 'login', to: 'auth#login'
    post 'refresh_token', to: 'auth#refresh'
    post 'registration', to: 'auth#registration'

    resources :uploads, only: %i(create)

    jsonapi_resources :media_items
    jsonapi_resources :companies
    jsonapi_resources :users
    jsonapi_resources :playlists
  end
end
