class Word < ActiveRecord::Base

  searchkick

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

  scope :verified , -> { where(:verified => true)}
  scope :unverified , -> { where(:verified => false)}
  scope :sorted , -> { order('created_at DESC') }
  scope :recent , -> { order('created_at DESC') }
  scope :my_words , -> (id) { where(:user_id => id, :verified => true) }

  # after_initialize :set_defaults

  self.per_page = 20

  def strip_whitespace
    self.en = self.en.strip unless self.en.nil?
    self.pl = self.pl.strip unless self.pl.nil?
  end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Word.create row.to_hash
    end
  end

  def self.is_answer_correct?(en:, pl:)
    en = en.strip.downcase
    pl = pl.strip.downcase
    Word.where(en: pl, pl: pl).size >= 1 ? true : false
  end
  
  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end

  def self.export

  end

  # def set_defaults
  #   self.user.name   = "Umberto"
  # end
end
