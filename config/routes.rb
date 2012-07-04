NewBlockCity::Application.routes.draw do
  devise_for :users

  root :to => 'home#index'

  resources :regions do
    resources :blocks, only: [:index]
  end
end
