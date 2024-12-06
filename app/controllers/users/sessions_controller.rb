class Users::SessionsController < Devise::SessionsController
  def create
    # Deviseのデフォルト認証メソッドを使用
    self.resource = warden.authenticate(auth_options)
    
    # 認証成功時
    if resource
      super
    else
      # 認証失敗時、カスタムエラーを追加
      self.resource = User.new
      resource.errors.add(:base, I18n.t('devise.sessions.invalid'))
      render :new
    end
  end
end
