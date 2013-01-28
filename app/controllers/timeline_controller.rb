class TimelineController < ApplicationController

  def create
    @users  = MyThreeFavorite::TwitterClient.get(:user, params[:profile_names])
    @tweets = MyThreeFavorite::TwitterClient.get(:user_timeline, params[:profile_names], true)
    render 'show'
  end

  def update
    @tweets = MyThreeFavorite::TwitterClient.get(:user_timeline, params[:profile_names], true)
    render partial: 'timeline'
  end
end
