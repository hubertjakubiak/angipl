class Word < ActiveRecord::Base
  validates :en, presence: true
  validates :pl, presence: true
  belongs_to :user
  acts_as_commontable
  acts_as_votable

  def self.search(search)
    if search
      self.where("words.en = '#{search}' OR words.pl  = '#{search}' ")
    else
      self.all
    end
  end
end
