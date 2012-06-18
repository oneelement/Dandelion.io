class LinkedinFeedsController < ApplicationController
  def index
    @user = User.find(current_user.id)
    #query = "Oliver Chesterman"
    linkedin = @user.linkedin.profile(:fields => [:headline, :first_name, :last_name, :summary, :educations, :positions])
    #linkedin = @user.linkedin.connections
    #linkedin = @user.linkedin.profile(:id => 'TQyNgqI-D4', :fields => [:picture_url])
    #linkedin = @user.linkedin.search(query)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: linkedin }
    end
  end
  
  def search
    query = params[:q]
    #query = "Bubba G"
    @user = User.find(current_user.id)
    fields = [{:people => [:id, :first_name, :last_name, :public_profile_url, :picture_url]}]
    search = @user.linkedin.search(:keywords => query, :fields => fields)
    #search = @user.linkedin.profile(:fields => [:headline, :first_name, :last_name, :summary, :educations, :positions])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: search.people.all }
    end
  end
  
  def profile
    id = params[:id]
    @user = User.find(current_user.id)
    profile = @user.linkedin.profile(:id => id, :fields => [:headline, :first_name, :last_name, :public_profile_url, :picture_url, :summary, :educations, :positions])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: profile }
    end
  end
end
