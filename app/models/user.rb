class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :words
  has_many :comments
  has_one :stat
  has_one :setting
  validates_uniqueness_of :name
  validates :name, presence: { message: "To pole nie może być puste." }

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>", :small => "20x20>" }, :default_url => "/images/:style/default_image.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  after_create :create_stat_for_user_if_not_exists
  after_create :create_setting_for_user_if_not_exists

  def points
    stat.points
  end

  def rank
    Stat.where("stats.points > ?", points).count + 1
  end

  def create_stat_for_user_if_not_exists
      Stat.where(:user_id => self.id).first_or_create
  end

  def create_setting_for_user_if_not_exists
      Setting.where(:user_id => self.id).first_or_create
  end

end
