FactoryGirl.define do
  factory :user do
    sequence(:name){|n| "#{Faker::Internet.user_name} #{n}" }
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password }
  end
end
