Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions' 
  }
  
  root 'top#index'
  get  'about',   to: 'top#about'
  
  resources :rooms, param: :token do
    get 'setting', to: 'room_setting#index'
  end

  resources :restaurants do
    resources :reports, controller: 'restaurants/reports'
  end

  resources :member_requests, only: [:new, :create, :destroy] do
    member do
      post :allow
      post :deny
    end
    collection do
      post :check
    end
  end
  resources :notifications, only: [:index, :create, :destroy] do
    member do
      post :checked
    end
  end

end
