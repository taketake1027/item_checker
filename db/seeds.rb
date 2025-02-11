# 既存データをクリア
Group.delete_all
GroupUser.delete_all
Event.delete_all
Item.delete_all
puts "既存のデータを削除しました"

# 管理者ユーザーを作成
admin = Admin.find_or_create_by(email: "aa@aa") do |admin|
  admin.password = 'aaaaaa'
  admin.password_confirmation = 'aaaaaa'
  admin.role = 'admin'
end
puts admin.persisted? ? "管理者アカウントを作成しました" : "管理者アカウントの作成に失敗しました"

# 一般ユーザーを作成
users = [
  { name: "Misaki Tanaka", email: "misaki.tanaka@example.com", role: "employee" },
  { name: "Taro Yamada", email: "test@test", role: "employee" },
  { name: "Hanako Suzuki", email: "hanako.suzuki@example.com", role: "staff" },
  { name: "Kenta Kobayashi", email: "kenta.kobayashi@example.com", role: "leader" },
  { name: "Yuki Matsumoto", email: "yuki.matsumoto@example.com", role: "employee" }
]
users.each do |user_data|
  user = User.find_or_create_by(email: user_data[:email]) do |user|
    user.name = user_data[:name]
    user.password = "user123"
    user.password_confirmation = "user123"
    user.role = user_data[:role]
  end
  puts user.persisted? ? "一般ユーザー #{user.name} を作成しました" : "ユーザー #{user_data[:name]} の作成に失敗しました"
end

# グループ情報を作成
group_data = [
  { name: "Team Alpha", introduction: "営業とマーケティングを担当するチーム。" },
  { name: "Team Beta", introduction: "製品開発を担当するチーム。" },
  { name: "Team Gamma", introduction: "顧客サポートを担当するチーム。" }
]

groups = group_data.map do |data|
  Group.find_or_create_by(name: data[:name]) do |group|
    group.introduction = data[:introduction]
    group.creator_id = admin.id if admin
  end
end
groups.each do |group|
  puts group.persisted? ? "グループ '#{group.name}' を作成しました" : "グループ '#{group.name}' の作成に失敗しました"
end

# 各グループにユーザーを追加
user_ids = User.all.ids
Group.all.each do |group|
  User.find(user_ids.sample(2)).each do |user|
    GroupUser.find_or_create_by(group: group, user: user) do |gu|
      gu.position = user.role
      gu.status = "active"
      gu.joined_date = Date.today
    end
  end
end

# イベントデータを作成
event_data = [
  {
    name: "年間売上会議",
    introduction: "売上実績の確認と来年の戦略計画。",
    start_date: DateTime.new(2026, 1, 15, 9, 0),
    end_date: DateTime.new(2026, 1, 15, 17, 0),
    location: "東京本社 会議室",
    group: groups[0],  # Team Alpha
    user: User.find_by(email: "kenta.kobayashi@example.com")
  },
  {
    name: "チームビルディングワークショップ",
    introduction: "チームダイナミクスとコミュニケーションを改善するためのインタラクティブなワークショップ。",
    start_date: DateTime.new(2024, 2, 10, 10, 0),
    end_date: DateTime.new(2024, 2, 10, 16, 0),
    location: "大阪支社",
    group: groups[1],  # Team Beta
    user: User.find_by(email: "yuki.matsumoto@example.com")
  },
  {
    name: "クライアントフィードバックセッション",
    introduction: "製品の改善のためにクライアントからフィードバックを集める。",
    start_date: DateTime.new(2024, 3, 5, 14, 0),
    end_date: DateTime.new(2024, 3, 5, 18, 0),
    location: "京都オフィス",
    group: groups[2],  # Team Gamma
    user: User.find_by(email: "hanako.suzuki@example.com")
  },
  {
    name: "四半期財務レビュー",
    introduction: "過去四半期の会社の財務状況のレビュー。",
    start_date: DateTime.new(2024, 4, 20, 9, 0),
    end_date: DateTime.new(2024, 4, 20, 17, 0),
    location: "東京本社 会議室",
    group: groups[0],  # Team Alpha
    user: User.find_by(email: "test@test")
  },
  {
    name: "マーケティング戦略会議",
    introduction: "次のシーズンのマーケティングキャンペーン計画。",
    start_date: DateTime.new(2025, 5, 12, 10, 0),
    end_date: DateTime.new(2025, 5, 12, 15, 0),
    location: "大阪支社",
    group: groups[1],  # Team Beta
    user: User.find_by(email: "kenta.kobayashi@example.com")
  },
  {
    name: "リーダーシップ開発プログラム",
    introduction: "チーム内でリーダーシップスキルを開発するためのセッション。",
    start_date: DateTime.new(2030, 6, 18, 9, 0),
    end_date: DateTime.new(2030, 6, 18, 17, 0),
    location: "東京本社 会議室",
    group: groups[2],  # Team Gamma
    user: User.find_by(email: "misaki.tanaka@example.com")
  },
  {
    name: "マーケティング戦略概観",
    introduction: "次のマーケティング戦略と目標の概観。",
    start_date: DateTime.new(2025, 7, 25, 10, 0),
    end_date: DateTime.new(2025, 7, 25, 15, 0),
    location: "大阪支社",
    group: groups[1],  # Team Beta
    user: User.find_by(email: "kenta.kobayashi@example.com")
  }
]

event_data.each do |event|
  created_event = Event.find_or_create_by(name: event[:name]) do |e|
    e.introduction = event[:introduction]
    e.start_date = event[:start_date]
    e.end_date = event[:end_date]
    e.location = event[:location]
    e.group = event[:group]
    e.user = event[:user]
  end
  puts created_event.persisted? ? "イベント '#{created_event.name}' を作成しました" : "イベント '#{event[:name]}' の作成に失敗しました: #{created_event.errors.full_messages.join(", ")}"
  
  # イベントに関連するアイテムの作成
  projector = created_event.items.create!(
    name: "プロジェクター",
    introduction: "高解像度プロジェクター。プレゼンに使用。",
    status: "未完了",
    amount: 2, 
    prepared_amount: 0
  )
  mic = created_event.items.create!(
    name: "マイクセット",
    introduction: "会場での音響用マイク。",
    status: "未完了", 
    amount: 5, 
    prepared_amount: 3
  )
  speaker = created_event.items.create!(
    name: "スピーカー",
    introduction: "大型スピーカー。",
    status: "完了", 
    amount: 2, 
    prepared_amount: 2
  )
  
  # アイテムの進捗状況を表示
  puts "アイテム '#{projector.name}' の進捗: #{projector.status}"
  puts "アイテム '#{mic.name}' の進捗: #{mic.status}"
  puts "アイテム '#{speaker.name}' の進捗: #{speaker.status}"
end

# 投稿データの作成
posts_data = [
  {
    title: "年間会議のハイライト",
    content: "今年の年次総会のハイライトをお伝えします。",
    user_email: "misaki.tanaka@example.com",
    event_name: "年間売上会議"
  },
  {
    title: "チームビルディングワークショップの振り返り",
    content: "チームビルディングワークショップの振り返り。",
    user_email: "yuki.matsumoto@example.com",
    event_name: "チームビルディングワークショップ"
  }
]

posts_data.each do |post_data|
  event = Event.find_by(name: post_data[:event_name])
  user = User.find_by(email: post_data[:user_email])
  
  post = Post.find_or_create_by(title: post_data[:title], event: event, user: user) do |p|
    p.content = post_data[:content]
  end
  puts post.persisted? ? "投稿 '#{post.title}' を作成しました" : "投稿 '#{post.title}' の作成に失敗しました"
end

puts "データの作成が完了しました"
