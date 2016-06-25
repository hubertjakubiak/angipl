class Word < ActiveRecord::Base
  validates :en, presence: true
  validates :pl, presence: true
  belongs_to :user

  def self.search(search)
    if search
      self.where("words.en = '#{search}' OR words.pl  = '#{search}' ")
    else
      self.all
    end
  end
end
