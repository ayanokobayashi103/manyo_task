# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(
  name:  "管理者たろう",
  email: 'test@test.com',
  password: 'testarou',
  password_confirmation: 'testarou',
  admin: true
)

5.times do |n|
  Label.create!(
    name: "ラベル#{n + 1}",
  )
end

10.times do |n|
  User.create!(
    name:  "ユーザー#{n + 1}",
    email: "user#{n + 1}@test.com",
    password: 'password',
    password_confirmation: 'password',
  )
end

10.times do |n|
  Task.create!(
    title:  "タスク#{n + 1}",
    content: "タスク#{n + 1}をやる",
    user_id: 1
  )
end
