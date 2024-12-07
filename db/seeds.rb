# db/seeds.rb

# 管理者ユーザーを作成（メールアドレスとパスワードは適宜変更してください）
Admin.create!(
  email: 'admin@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)

puts '管理者ユーザーが作成されました。'