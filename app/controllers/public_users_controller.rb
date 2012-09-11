class PublicUsersController < ApplicationController
  
  def index
    name = params[:name]
    @users = User.excludes(:id => current_user.id)
    if name
      @users = @users.where(:full_name => /#{params[:name]}/i).asc(:name).limit(8)
    end
     
    respond_to do |format|
      format.json { render_for_api :public_user, :json => @users }
    end
  end
  
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.json { render_for_api :public_user, :json => @user }
    end
  end
  
end
