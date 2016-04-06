Rails.application.routes.draw do
  root 'home#index'

  devise_for :users

  concern :playlist_assignable do
    resource :playlist_assignment, only: [:update]
  end

  resources :news_items, path: :news, only: [:index, :show]
  resources :media_items, except: [:edit, :update, :create] do
    collection do
      post :create_multiple
      delete :destroy_multiple
    end
  end
  resources :device_groups, concerns: :playlist_assignable
  resources :devices, concerns: :playlist_assignable do
    resources :device_log_messages, only: [:index]
    resources :ssh_tunnels, only: [:new, :create]
  end
  resources :playlists

  namespace :deviceapi, defaults: {format: :json} do
    resources :status, only: [:create]
  end
end
