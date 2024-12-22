class User < ApplicationRecord
  has_many :group_users, dependent: :destroy # ここで関連するグループ参加情報を削除
  has_many :groups, through: :group_users
  has_many :posts
  # グループを介して関連するイベントを取得
  has_many :events, through: :groups
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ユーザー名のバリデーション（名前が空でないこと）
  validates :name, presence: true

  # メールアドレスのバリデーション（空でないこと、形式が正しいこと、一意であること）
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  # ユーザー削除時に関連するグループ参加情報も削除
  before_destroy :remove_from_groups

  enum role: { employee: 0, staff: 1, leader: 2 }
  
  def guest?
    self.role == 'guest'  # roleがguestの場合をゲストと判断
  end
   # Devise の設定（ユーザー認証）
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  private

  # ユーザーが削除される前に、関連するグループからそのユーザーを削除
  def remove_from_groups
    self.groups.each do |group|
      group.group_users.find_by(user_id: self.id)&.destroy
    end
  end
end
