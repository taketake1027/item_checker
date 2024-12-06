class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ユーザー名のバリデーション（名前が空でないこと）
  validates :name, presence: true

  # メールアドレスのバリデーション（空でないこと、形式が正しいこと、一意であること）
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true

  # パスワードのバリデーション（空でないこと、6文字以上であること）
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true
end
