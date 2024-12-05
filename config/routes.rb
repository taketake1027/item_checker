Rails.application.routes.draw do
  root 'home#top'  # トップページ
  get 'about', to: 'home#about'  # アバウトページ
  devise_for :users  # Deviseのルート
  resources :users, only: [:show]
  post 'users/guest_login', to: 'users#guest_login', as: 'guest_login'  # ゲストログイン用ルート
end
