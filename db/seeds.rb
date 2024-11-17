# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


# メインのサンプルユーザーを1人作成する
User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

# 追加のユーザーをまとめて生成する
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

# ユーザー情報の作成
user = User.find_or_create_by(id: 1)

# 1年分のスコアデータを生成
(1..365).each do |day|
  DailyRecord.create!(
    user: user,
    date: Date.today - day,
    sleep:     rand(1..5),
    meal:      rand(1..5),
    mental:    rand(1..5),
    training:  rand(1..5),
    condition: rand(1..5)
  )
end

# ユーザー情報の作成
user = User.find_or_create_by(id: 2)

# 1ヶ月分のスコアデータを生成
(1..10).each do |day|
  DailyRecord.create!(
    user: user,
    date: Date.today - day,
    sleep:     rand(1..5),
    meal:      rand(1..5),
    mental:    rand(1..5),
    training:  rand(1..5),
    condition: rand(1..5)
  )
end