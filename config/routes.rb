Rails.application.routes.draw do
  get 'items/index'
  # 管理者用トップページ
  namespace :admin do
    root to: 'homes#top'
    get 'homes/top', to: 'homes#top'
    resources :items
    resources :events
    resources :groups do
      post 'add_user_to_group', on: :member
      resources :group_users, only: [:destroy], as: 'remove_user'
    end
  end

  # ユーザー用のDevise設定
  devise_for :users

  # 管理者用のDevise設定
  devise_for :admins, path: 'admin', controllers: {
    sessions: 'admin/sessions',
    confirmations: 'admin/confirmations'  # 修正後: Admin::ConfirmationsControllerを使用
  }

  # ユーザー関連のルート
  resources :users, only: [:show, :edit, :update, :destroy]
  resources :events, only: [:index, :show]
  resources :items, only: [:index]
  # トップページ
  root 'homes#top'

  # アバウトページ
  get '/about', to: 'homes#about'

  # マイページ
  get 'mypage', to: 'users#show', as: 'mypage'
  get '/mypage/edit', to: 'users#edit'
  patch '/mypage', to: 'users#update'

  # ゲストログイン
  post 'guest_login', to: 'users#guest_login', as: :guest_login

  # イベント関連
  resources :events do
    resources :posts do
      resources :comments, only: [:create, :destroy]
    end
  end

  # アイテム関連
  resources :items, only: [:index, :show, :edit, :update]

  # 通知関連
  resources :notices, only: [:index, :show, :edit, :update]

  # グループ関連
  resources :groups, only: [:index, :show] do
    resources :group_users, only: [:create, :destroy]
  end
end
