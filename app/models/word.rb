class Word < ActiveRecord::Base
  validates :en, presence: true
  validates :pl, presence: true
  belongs_to :user
end
