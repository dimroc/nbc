NewBlockCity::Application.routes.draw do
  devise_for :users

  namespace :api do
    resources :worlds do
      resources :regions
      resources :blocks
    end
  end

  # Explicitly mount Jasminerice above global match rule to prevent trumping of jasmine
  mount Jasminerice::Engine => "/jasmine" if Rails.env.development? || Rails.env.test?
  match '/' => 'home#index'
  match '/boroughs/(*other)' => 'home#index'
  match '/regions/(*other)' => 'home#index'
end
