class NotificationsController < ApplicationController
  
  #load_and_authorize_resource
  
  def index
    #@notifications = Notification.where(:user_id => current_user.id)
    @notifications = Notification.all
    
    respond_to do |format|
      format.json { render_for_api :notification, :json => @notifications }
    end
  end
  
  def create
    @notification = Notification.new(params[:notification])
    @notification.update_attributes(
      sent_id: current_user.id, 
      sent_name: current_user.full_name, 
      sent_avatar: current_user.avatar
    )
    respond_to do |format|
      if @notification.save
        format.json { render json: @notification, status: :created, location: @notification }
      else
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @notification = Notification.find(params[:id])

    respond_to do |format|
      if @notification.update_attributes(params[:notification])
        format.json { render json: @notification }
      else
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end
    end
  end
end
