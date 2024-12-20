# app/models/event.rb
class Event < ApplicationRecord
  belongs_to :user
  belongs_to :group
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :items
  has_many :users, through: :group_participations

  def add_users(user_ids)
    self.users = User.where(id: user_ids)
  end
  
  def role_for_user(user)
    # ここでは `group_participations` などのカラム追加をしない前提で
    # 役割の取得を行いたい場合に適切な方法を考慮します。
    # 例えば、group_participationsの存在を仮定して、役割を判定するか、その他の条件でチェック
    "未設定" # 仮に未設定として返す、もしroleの管理方法があれば適宜修正
  end
end
