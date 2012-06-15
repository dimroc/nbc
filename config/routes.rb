NewBlockCity::Application.routes.draw do
  devise_for :users

  root :to => 'home#index'
  resources :regions
end
