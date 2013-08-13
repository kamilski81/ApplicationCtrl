OpsCheckServer::Application.routes.draw do

  match 'versionings/check', to: 'versionings#check', via: :get

  resources :versionings

  resources :apps

  resources :app_types

  devise_for :users

  root :to => "home#index"
end
