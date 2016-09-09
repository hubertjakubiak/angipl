FactoryGirl.define do
  factory :word do
    en { Faker::Lorem.word  }
    pl { Faker::Lorem.word  }
    verified { true }
    user_id { 1 }
    categories { }
  end
end