OpsCheckServer::Application.routes.draw do
  resources :versionings

  resources :apps

  resources :app_types

  devise_for :users


  root :to => "home#index"
end
