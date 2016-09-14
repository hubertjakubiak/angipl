class RankingsController < ApplicationController
  def index
    @users = User.includes(:stat).order("stats.points DESC")
  end
end
