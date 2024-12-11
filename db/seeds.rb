Admin.find_or_create_by(email: "aa@aa") do |admin|
  admin.password= 'aaaaaa'
  admin.password_confirmation= 'aaaaaa'
  admin.role= 'admin'
end

puts "管理者アカウントを作成しました"
