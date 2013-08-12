OpsCheckServer::Application.routes.draw do
  resources :applications

  resources :app_types

  devise_for :users


  root :to => "home#index"
end
