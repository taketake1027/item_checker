class User < ApplicationRecord
  has_many :group_users, dependent: :destroy # ここで関連するグループ参加情報を削除
  has_many :groups, through: :group_users

  # グループを介して関連するイベントを取得
  has_many :events, through: :groups
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ユーザー名のバリデーション（名前が空でないこと）
  validates :name, presence: true

  # メールアドレスのバリデーション（空でないこと、形式が正しいこと、一意であること）
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true

  # パスワードのバリデーション（空でないこと、6文字以上であること）
  validates :password, presence: true, length: { minimum: 6 }

  # ユーザー削除時に関連するグループ参加情報も削除
  before_destroy :remove_from_groups

  private

  # ユーザーが削除される前に、関連するグループからそのユーザーを削除
  def remove_from_groups
    self.groups.each do |group|
      group.group_users.find_by(user_id: self.id)&.destroy
    end
  end
end
