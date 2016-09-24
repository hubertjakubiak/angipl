class Word < ActiveRecord::Base

  require 'csv'

  validates :en, :presence => {:message => "To pole nie może być puste." }
  validates :pl, :presence => {:message => "To pole nie może być puste." }
  validates :categories, :presence => {:message => "To pole nie może być puste." }
  validates_uniqueness_of :en, :scope => :pl, :message => "Istnieje już takie tłumaczenie tego słówka."
  validates_uniqueness_of :pl, :scope => :en, :message => "Istnieje już takie tłumaczenie tego słówka."
  belongs_to :user
  validates :user_id, :presence => true
  acts_as_votable
  before_validation :strip_whitespace

  has_many :word_categories
  has_many :comments
  has_many :categories, through: :word_categories

  scope :verified , lambda { where(:verified => true)}
  scope :unverified , lambda { where(:verified => false)}
  scope :sorted , lambda { order('created_at DESC') }
  scope :recent , lambda { order('created_at DESC') }
  scope :my_words , -> (id) { where(:user_id => id, :verified => true) }

  self.per_page = 20

  def self.search(search)
    if search
      self.where("lower(words.en) LIKE '#{search.downcase}' OR lower(words.pl)  = '#{search.downcase}' ")
      #self.where("words.en LIKE ? OR words.pl LIKE ?" , "%#{search.downcase}%", "%#{search.downcase}%")
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
