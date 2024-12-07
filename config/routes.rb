Rails.application.routes.draw do
  devise_for :users
  devise_for :admins

  # ユーザー関連のルート
  resources :users, only: [:show, :edit, :update, :destroy]
  
  root 'homes#top'  # トップページ（イベント一覧ページ）
  get '/about', to: 'homes#about'  # アバウトページ

  # ユーザー関連
  get 'mypage', to: 'users#show', as: 'mypage'  # マイページ
  get '/mypage/edit', to: 'users#edit'  # ユーザー登録情報編集画面
  patch '/mypage', to: 'users#update'  # ユーザー登録情報更新

  # ログイン・会員登録関連
  # ゲストログイン専用ルート
  post 'guest_login', to: 'users#guest_login', as: :guest_login

  # イベント関連
  resources :events, only: [:show] do
    # イベントに対する投稿・コメント関連
    resources :posts, only: [:create, :destroy]
    resources :comments, only: [:create, :destroy]
  end

  # アイテム関連
  resources :items, only: [:index, :show]

  # 通知関連
  get '/notices', to: 'notices#index'  # 通知一覧ページ（ユーザー専用）

  # グループ参加関連
  resources :groups, only: [:show] do
    resources :group_users, only: [:create, :destroy]
  end
end
