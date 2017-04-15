category = Category.create!(name: "Sport")
user = User.create!(email: "test@test.pl", name: "admin", password: "password")

100.times do |n|
  Word.create!(en: "#{Faker::Lorem.word} #{n}",
               pl: "#{Faker::Lorem.word} #{n}",
               user: user,
               verified: true,
               categories: [category])
end
