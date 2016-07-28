class Word < ActiveRecord::Base

  require 'csv'

  validates :en, :presence => {:message => "To pole nie może być puste." }
  validates :pl, :presence => {:message => "To pole nie może być puste." }
  validates_uniqueness_of :en, :scope => :pl, :message => "Istnieje już takie tłumaczenie tego słówka."
  validates_uniqueness_of :pl, :scope => :en, :message => "Istnieje już takie tłumaczenie tego słówka."
  belongs_to :user
  acts_as_commontable
  acts_as_votable
  before_validation :strip_whitespace

  has_many :word_categories
  has_many :categories, through: :word_categories

  scope :verified , lambda { where(:verified => true)}
  scope :notverified , lambda { where(:verified => false)}
  scope :sorted , lambda { order('created_at DESC') }

  self.per_page = 20

  def self.search(search)
    if search
      self.where("words.en = '#{search}' OR words.pl  = '#{search}' ")
      #self.where("words.en LIKE ? OR words.pl LIKE ?" , "%#{search}%", "%#{search}%")
    end
  end

  def strip_whitespace
    self.en = self.en.strip unless self.en.nil?
    self.pl = self.pl.strip unless self.pl.nil?
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Word.create row.to_hash
    end
  end
end
