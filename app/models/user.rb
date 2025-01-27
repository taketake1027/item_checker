class User < ApplicationRecord
  has_many :group_users, dependent: :destroy 
  has_many :groups, through: :group_users
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy 
  has_many :events, through: :groups
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  
  before_destroy :remove_from_groups

  enum role: { employee: 0, staff: 1, leader: 2 }
  paginates_per 2 # 1ページあたり5件表示（イベント）
  paginates_per 2 # 1ページあたり5件表示（投稿）
  def guest?
    self.role == 'guest'  
  end
  
  private

  def remove_from_groups
    self.groups.each do |group|
      group.group_users.find_by(user_id: self.id)&.destroy
    end
  end
end
