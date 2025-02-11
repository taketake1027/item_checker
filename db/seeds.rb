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
  { name: "Team Alpha", introduction: "Team responsible for sales and marketing." },
  { name: "Team Beta", introduction: "Team responsible for product development." },
  { name: "Team Gamma", introduction: "Team responsible for customer support." }
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
    name: "Annual Sales Meeting",
    introduction: "Review of sales performance and strategy planning for the next year.",
    start_date: DateTime.new(2026, 1, 15, 9, 0),
    end_date: DateTime.new(2026, 1, 15, 17, 0),
    location: "Tokyo HQ Conference Room",
    group: groups[0],  # Team Alpha
    user: User.find_by(email: "kenta.kobayashi@example.com")
  },
  {
    name: "Team Building Workshop",
    introduction: "A fun and interactive workshop to improve team dynamics and communication.",
    start_date: DateTime.new(2024, 2, 10, 10, 0),
    end_date: DateTime.new(2024, 2, 10, 16, 0),
    location: "Osaka Branch",
    group: groups[1],  # Team Beta
    user: User.find_by(email: "yuki.matsumoto@example.com")
  },
  {
    name: "Client Feedback Session",
    introduction: "Gathering feedback from clients to improve our product offerings.",
    start_date: DateTime.new(2024, 3, 5, 14, 0),
    end_date: DateTime.new(2024, 3, 5, 18, 0),
    location: "Kyoto Office",
    group: groups[2],  # Team Gamma
    user: User.find_by(email: "hanako.suzuki@example.com")
  },
  {
    name: "Quarterly Financial Review",
    introduction: "Review of company financials for the last quarter.",
    start_date: DateTime.new(2024, 4, 20, 9, 0),
    end_date: DateTime.new(2024, 4, 20, 17, 0),
    location: "Tokyo HQ Conference Room",
    group: groups[0],  # Team Alpha
    user: User.find_by(email: "test@test")
  },
  {
    name: "Marketing Strategy Meeting",
    introduction: "Planning for marketing campaigns for the upcoming season.",
    start_date: DateTime.new(2025, 5, 12, 10, 0),
    end_date: DateTime.new(2025, 5, 12, 15, 0),
    location: "Osaka Branch",
    group: groups[1],  # Team Beta
    user: User.find_by(email: "kenta.kobayashi@example.com")
  },
  {
    name: "Leadership Development Program",
    introduction: "A session designed to develop leadership skills within the team.",
    start_date: DateTime.new(2030, 6, 18, 9, 0),
    end_date: DateTime.new(2030, 6, 18, 17, 0),
    location: "Tokyo HQ Conference Room",
    group: groups[2],  # Team Gamma
    user: User.find_by(email: "misaki.tanaka@example.com")
  },
  {
    name: "Marketing Strategy Overview",
    introduction: "An overview of the upcoming marketing strategies and goals.",
    start_date: DateTime.new(2025, 7, 25, 10, 0),
    end_date: DateTime.new(2025, 7, 25, 15, 0),
    location: "Osaka Branch",
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
    title: "Annual Meeting Highlights",
    content: "今年の年次総会のハイライトをお伝えします。",
    user_email: "misaki.tanaka@example.com",
    event_name: "Annual Sales Meeting"
  },
  {
    title: "Team Building Workshop Recap",
    content: "チームビルディングワークショップの振り返り。",
    user_email: "kenta.kobayashi@example.com",
    event_name: "Team Building Workshop"
  },
  {
    title: "Projector Setup Tips",
    content: "プロジェクターのセットアップ方法について。",
    user_email: "test@test",
    event_name: "Annual Sales Meeting"
  },
  {
    title: "Client Feedback Summary",
    content: "クライアントからのフィードバックの要約。",
    user_email: "hanako.suzuki@example.com",
    event_name: "Client Feedback Session"
  },
  {
    title: "Financial Review Insights",
    content: "四半期の財務レビューの詳細。",
    user_email: "yuki.matsumoto@example.com",
    event_name: "Quarterly Financial Review"
  },
  {
    title: "Marketing Strategy Overview",
    content: "次期マーケティング戦略の概要。",
    user_email: "kenta.kobayashi@example.com",
    event_name: "Marketing Strategy Overview"
  },
  {
    title: "Leadership Development Key Points",
    content: "リーダーシップ開発プログラムの要点。",
    user_email: "misaki.tanaka@example.com",
    event_name: "Leadership Development Program"
  }
]

posts_data.each do |post_data|
  user = User.find_by(email: post_data[:user_email])
  event = Event.find_by(name: post_data[:event_name])
  
  if user && event
    post = event.posts.create!(
      title: post_data[:title],
      content: post_data[:content],
      user: user
    )
    puts "投稿 '#{post.title}' を作成しました"
  else
    puts "イベントまたはユーザーが見つかりません"
  end
end

puts "データの作成が完了しました"


Comment.destroy_all

# 複数のコメントを一度に作成
comments = Comment.create(
  [
    {
      content: "年次総会のハイライト、非常に興味深いです！来年の計画も気になります。",
      user_id: 5,
      post_id: 1,
      event_id: 1
    },
    {
      content: "チームビルディングワークショップの振り返り、次回の改善点を共有してほしいです。",
      user_id: 3,
      post_id: 2,
      event_id: 2
    },
    {
      content: "プロジェクターのセットアップに関して、実際の事例を見てみたいです。",
      user_id: 2,
      post_id: 3,
      event_id: 1
    },
    {
      content: "クライアントからのフィードバック、どのように改善点を取り入れたか気になります。",
      user_id: 3,
      post_id: 4,
      event_id: 3
    },
    {
      content: "財務レビューは詳細で分かりやすかったです。次回の予算案についても知りたいです。",
      user_id: 4,
      post_id: 5,
      event_id: 4
    },
    {
      content: "次期マーケティング戦略について、更なる戦略の具体例が知りたいです。",
      user_id: 2,
      post_id: 6,
      event_id: 5
    },
    {
      content: "リーダーシップ開発プログラム、次のステップで何を学ぶか楽しみです。",
      user_id: 1,
      post_id: 7,
      event_id: 6
    }
  ]
)

# 作成されたコメントを確認
if comments.all?(&:persisted?)
  puts "コメントが正常に作成されました"
else
  comments.each do |comment|
    unless comment.persisted?
      puts "コメント作成失敗: #{comment.errors.full_messages.join(", ")}"
    end
  end
end