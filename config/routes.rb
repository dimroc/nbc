NewBlockCity::Application.routes.draw do
  devise_for :users

  namespace :api do
    resources :worlds do
      resources :regions
    end

    resources :blocks
    resources :videos
  end

  namespace :admin do
    resources :panda_videos
  end

  # Explicitly mount Jasminerice above global match rule to prevent trumping of jasmine
  mount Jasminerice::Engine => "/jasmine" if Rails.env.development? || Rails.env.test?
  match '/' => 'spine#index'
  match '/boroughs/(*other)' => 'spine#index'
  match '/regions/(*other)' => 'spine#index'
end
