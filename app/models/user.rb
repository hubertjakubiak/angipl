class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :words
  has_many :comments
  has_one :stat
  validates_uniqueness_of :name
  validates :name, presence: { message: "nie może być pusta." }

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>", :small => "20x20>" }, :default_url => "/images/:style/default_image.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def points
    stat.points
  end

  def rank
    Stat.where("stats.points > ?", points).count + 1
  end

end
