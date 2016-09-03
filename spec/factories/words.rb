FactoryGirl.define do
  factory :word do
    category = FactoryGirl.create(:category)
    en { Faker::Lorem.word  }
    pl { Faker::Lorem.word  }
    categories {[FactoryGirl.create(:category)]}
    verified { true }
    user_id { 1 }
  end
end