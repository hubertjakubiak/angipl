class Stat < ActiveRecord::Base
  belongs_to :user

  scope :user_words, lambda { |user_id| find_by_user_id(user_id) }

end
