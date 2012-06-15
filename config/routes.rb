NewBlockCity::Application.routes.draw do
  devise_for :users

  resources :regions
end
