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
  
  def feed
    social_id = params[:id]
    @user = User.find(current_user.id)
    
    #face = @user.facebook.get_object("me")
    #face = @user.facebook.get_connections("me", "friends")
    face = @user.facebook.get_connections(social_id, 'feed')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: face }
    end
  end
  
  def search
    query = params[:q]
    #query = "Bubba G"
    @user = User.find(current_user.id)
    face = @user.facebook.search(query, {:type => "user"})

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: face }
    end
  end 
  
  def wallpost
    text = params[:text]
    id = 586481549
    @user = User.find(current_user.id)
    #face = @user.facebook.put_wall_post(text
    #face = @user.facebook.put_connections(id, 'feed', :message => text)
    #face = @user.facebook.get_connection('me', 'friends',  "fields" => "name, gender, email, address")
    face = @user.facebook.get_object(id, "fields" => "name, gender, email, address")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: face }
    end
  end
end
