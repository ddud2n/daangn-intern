require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  get "/user/:username" => "userpage#page"
	
  resources :alarms
  resources :keywords
  resources :posts
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
