class Admin::SessionsController < Devise::SessionsController
  # 管理者用ログイン画面にカスタマイズしたい場合は、このクラスに処理を追加します
  def new
    super
  end
end
