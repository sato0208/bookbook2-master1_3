Rails.application.routes.draw do
  # get 'users/show'
  devise_for :users #, controllers: {
  # 	sessions:      'users/sessions',
  #   passwords:     'users/passwords',
  #   registrations: 'users/registrations'
  #   }


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'homes#top'

  get 'homes/about' => 'homes#about'
  get 'homes/top' => 'homes#top'
  get 'search' => 'users#search'

# 自動的にルーティングを設定してくれる
  resources :messages, :only => [:create]
  resources :rooms, :only => [:create, :show, :index]
  resources :relationships, only: [:create, :destroy]
  resources :books, only: [:create, :index, :show, :new, :edit, :destroy, :update] do
    resource :favorites, only:[:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:show, :edit, :update, :index] do
    member do
      get :follower, :following
    end
  end
end