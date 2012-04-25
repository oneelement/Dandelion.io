class TwitterFeedsController < ApplicationController
  def index
    @tasks = Task.all
    
    @user = User.find(current_user.id)
    
    tweets = @user.tweeting.home_timeline

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: tweets }
    end
  end
end
