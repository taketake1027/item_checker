Rails.application.routes.draw do
  # Deviseのルート設定（1回にまとめる）
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  
  # サインアウトルートのカスタマイズ（必要ならdevise_scopeを使用）
  devise_scope :user do
    delete '/users/sign_out', to: 'devise/sessions#destroy'  # GETからDELETEに変更
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  # アプリケーションのルート
  root 'home#top'  # トップページ
  get 'about', to: 'home#about'  # アバウトページ

  # ユーザー関連ルート
  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  post 'users/guest_login', to: 'users#guest_login', as: 'guest_login'  # ゲストログイン用ルート

  # イベント関連ルート
  resources :events, only: [:index, :show] do
    member do
      post 'join'
    end
  end
end
