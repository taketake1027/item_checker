# app/controllers/items_controller.rb
class ItemsController < ApplicationController
  before_action :authenticate_user!  # ユーザーがログインしていることを確認

  def index
    # アイテム一覧を取得（必要に応じて条件を追加）
    @items = Item.all
  end
end
