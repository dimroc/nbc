NewBlockCity::Application.routes.draw do
  devise_for :users

  root :to => 'home#index'

  resources :worlds do
    resources :regions
  end
end
