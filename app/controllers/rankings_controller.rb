class RankingsController < ApplicationController
  def index
    @users = RankingDecorator.decorate_collection(User.includes(:stat).order("stats.points DESC"))
  end
end
