ApplicationCtrl::Application.routes.draw do

  resources :teams

  match 'versionings/check', to: 'versionings#check', via: :get
  resources :versionings


  resources :apps

  devise_for :users

  root :to => 'home#index'
end
