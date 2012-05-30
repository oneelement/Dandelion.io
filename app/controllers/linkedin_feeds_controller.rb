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
    search = @user.linkedin.search(query)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: search }
    end
  end
end
