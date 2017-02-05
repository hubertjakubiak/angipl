# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create!(name: 'Sport')
User.create!(email: 'test@test.pl', name: 'test', password: '123456')

100.times do 
  Word.create!(en: Faker::Lorem.word, pl: Faker::Lorem.word, user_id: 1, verified: true, category_ids: [1])
end
