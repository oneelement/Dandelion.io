class PublicUsersController < ApplicationController
  
  def index
    @users = User.excludes(:id => current_user.id)
     
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
