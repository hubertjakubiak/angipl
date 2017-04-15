FactoryGirl.define do
  factory :word do
    sequence(:en){|n| "#{Faker::Lorem.word} #{n}" }
    sequence(:pl){|n| "#{Faker::Lorem.word} #{n}" }
    verified { true }
    user_id { 1 }
    categories { [create(:category)]}
  end
end
