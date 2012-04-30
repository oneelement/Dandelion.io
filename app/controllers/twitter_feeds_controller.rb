class TwitterFeedsController < ApplicationController
  def index
    @user = User.find(current_user.id)
    
    tweets = @user.tweeting.user_timeline(count: '10', trim_user: 1, exclude_replies: 1)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: tweets }
    end
  end
  
  def home
    @user = User.find(current_user.id)
    tweet = @user.tweeting.home_timeline(count: '10', trim_user: 1, exclude_replies: 1)
    
    list = tweet.map {|u| Hash[ text: u.text ]} 
    #render json: list
    render :json => list.to_json
  end
  
  def timeline
    @user = User.find(current_user.id)
    tweets = @user.tweeting.user_timeline(count: '10', exclude_replies: 1)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: tweets }
    end
  end
end
