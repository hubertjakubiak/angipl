FactoryGirl.define do
  factory :word do
    # en { Faker::Lorem.word  }
    # pl { Faker::Lorem.word  }
    sequence(:en){|n| "#{Faker::Lorem.word} #{n}" }
    sequence(:pl){|n| "#{Faker::Lorem.word} #{n}" }
    verified { true }
    user_id { 1 }
    categories { }
  end
end