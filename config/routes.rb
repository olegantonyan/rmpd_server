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
    resource :playlist_assignment, only: %i[update]
  end

  resources :media_items, except: %i[show edit destroy] do
    post 'upload', on: :collection
    delete 'destroy_multiple', on: :collection
  end
  resources :device_groups, concerns: :playlist_assignable
  resources :devices, concerns: :playlist_assignable, except: %i[destroy new create] do
    resources :device_log_messages, only: %i[index]
    resources :software_updates, only: %i[create index]
  end
  resources :playlists, except: %i[show]
  resources :companies do
    post 'leave', on: :member
    resources :invites, only: %i[create destroy]
  end
  resources :users, only: %i[index show edit update destroy]
  resource :device_binds, only: %i[create new]

  namespace :deviceapi, defaults: { format: :json } do
    resources :status, only: %i[create]
  end
end
