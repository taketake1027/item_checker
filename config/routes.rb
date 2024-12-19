Rails.application.routes.draw do
  # 管理者用ルート
  namespace :admin do
    root to: 'homes#top'
    get 'homes/top', to: 'homes#top'
    resources :items

    resources :events do
      resources :comments, only: [:index, :destroy], controller: 'event_comments'
      resources :posts, only: [:index, :destroy] 
  end

    resources :groups do
      post 'add_user_to_group', on: :member
      resources :group_users, only: [:destroy], as: 'remove_user'
    end

    resources :users, only: [:index, :show, :edit, :update, :destroy] do
      member do
        patch 'update_role', to: 'users#update_role'
      end
    end
  end

  # ユーザー用のDevise設定
  devise_for :users

  # 管理者用のDevise設定
  devise_for :admins, path: 'admin', controllers: {
    sessions: 'admin/sessions',
    confirmations: 'admin/confirmations'
  }

  # ユーザー関連のルート
  resources :users, only: [:show, :create, :update, :destroy]

  # イベント関連（アイテム一覧をネスト）
  resources :events do
    resources :items, only: [:index, :show]
    resources :posts, only: [:show, :create, :destroy] do
      post 'create_comment', on: :member
    resources :comments, only: [:create, :destroy]
    end
  end

  # ログイン前は homes#landing、ログイン後は homes#top にリダイレクト
  root to: 'homes#landing'  # ログイン前のトップページ
  get 'homes/top', to: 'homes#top', as: 'homes_top'

  # アバウトページ
  get '/about', to: 'homes#about'

  # マイページ
  get 'mypage', to: 'users#show', as: 'mypage'
  get '/mypage/edit', to: 'users#edit'
  patch '/mypage', to: 'users#update'

  # ゲストログイン
  post 'guest_login', to: 'users#guest_login', as: :guest_login

  # 通知関連
  resources :notices, only: [:index, :show, :edit, :update]

  # グループ関連
  resources :groups, only: [:index, :show] do
    resources :group_users, only: [:create, :destroy]
  end
end
