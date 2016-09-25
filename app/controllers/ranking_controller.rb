class RankingController < ApplicationController

  expose(:users) { RankingDecorator.decorate_collection(User.includes(:stat).order("stats.points DESC"))}
end
