class Comment < ApplicationRecord
  belongs_to :post  
  belongs_to :user  
  belongs_to :event
  validates :content, presence: { message: "コメント内容を入力してください" }  
end
