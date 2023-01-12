Rails.application.routes.draw do
  resources :items do
    member do
      patch :vote
      put :refeed
    end
  end
  
  devise_for :users
  root to: 'items#index'
end
