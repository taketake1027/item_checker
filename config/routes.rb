Rails.application.routes.draw do
  namespace :admin do
    get 'group_users/destroy'
  end
  # 管理者用トップページ
  namespace :admin do
    root to: 'homes#top'
    get 'homes/top', to: 'homes#top'
    
    resources :groups do
      # グループにユーザーを追加するためのルート
      post 'add_user_to_group', on: :member
      # ユーザー削除用のルート設定
      resources :group_users, only: [:destroy], as: 'remove_user'
    end
  end

  # ユーザー用のDevise設定
  devise_for :users

  # 管理者用のDevise設定（ログインページのURLをadmin/sign_inに変更）
  devise_for :admins, path: 'admin', controllers: {
    sessions: 'admin/sessions'
  }

  # ユーザー関連のルート
  resources :users, only: [:show, :edit, :update, :destroy]

  # トップページ（イベント一覧ページ）
  root 'homes#top'

  # アバウトページ
  get '/about', to: 'homes#about'

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

  # グループ一覧ページへのルート設定
  resources :groups, only: [:index, :show] do
    resources :group_users, only: [:create, :destroy]  # グループへの参加・脱退
  end
end
