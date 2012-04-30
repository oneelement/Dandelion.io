class FacebookFeedsController < ApplicationController
  def index
    @user = User.find(current_user.id)
    
    #face = @user.facebook.get_object("me")
    #face = @user.facebook.get_connections("me", "friends")
    face = @user.facebook.get_connections('me', 'feed')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: face }
    end
  end
end
