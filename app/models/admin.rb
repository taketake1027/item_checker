class Admin < ApplicationRecord
  # devise のみ使用する
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
