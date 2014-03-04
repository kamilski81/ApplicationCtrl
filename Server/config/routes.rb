ApplicationCtrl::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  resources :teams

  match 'versionings/check', to: 'versionings#check', via: :get
  resources :versionings


  resources :apps

  devise_for :users

  root :to => 'home#index'
end
