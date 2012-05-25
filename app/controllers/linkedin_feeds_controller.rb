class LinkedinFeedsController < ApplicationController
  def index
    @user = User.find(current_user.id)
    
    #linkedin = @user.linkedin.profile(:fields => [:headline, :first_name, :last_name, :summary, :educations, :positions])
    #linkedin = @user.linkedin.connections
    #linkedin = @user.linkedin.profile(:id => 'TQyNgqI-D4', :fields => [:picture_url])
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: linkedin }
    end
  end
end
