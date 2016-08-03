class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :word

  validates :content, :presence => {:message => "To pole nie może być puste." }
end
