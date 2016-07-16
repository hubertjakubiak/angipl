class Word < ActiveRecord::Base
  validates :en, :presence => {:message => "To pole nie może być puste." }
  validates :pl, :presence => {:message => "To pole nie może być puste." }
  validates_uniqueness_of :en, :scope => :pl, :message => "Istnieje już takie tłumaczenie tego słówka."
  validates_uniqueness_of :pl, :scope => :en, :message => "Istnieje już takie tłumaczenie tego słówka."
  belongs_to :user
  acts_as_commontable
  acts_as_votable

  scope :verified , lambda { where(:verified => true)}
  scope :sorted , lambda { order('created_at DESC') }

  self.per_page = 50

  def self.search(search)
    if search
      #self.where("words.en = '#{search}' OR words.pl  = '#{search}' ")
      self.where("words.en LIKE ? OR words.pl LIKE ?" , "%#{search}%", "%#{search}%")
    end
  end
end
