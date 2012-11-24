NewBlockCity::Application.routes.draw do
  devise_for :users

  root :to => 'home#index'

  namespace :api do
    resources :worlds do
      resources :regions
      resources :blocks
    end
  end
end
