OpsCheckServer::Application.routes.draw do

  match 'versionings/check', to: 'versionings#check', via: :get

  resources :versionings

  resources :apps

  devise_for :users

  root :to => "home#index"
end
