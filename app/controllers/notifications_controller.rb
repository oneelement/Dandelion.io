class NotificationsController < ApplicationController
  
  load_and_authorize_resource
  
  def index
    @notifications = Notification.where(:user_id => current_user.id)
    #@notifications = Notification.all
    
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
    if params[:ripple_id]
      contact = Contact.find(params[:ripple_id])
      user_id = contact.user_id
      @notification.update_attributes(
        user_id: user_id
      )
    end
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
  
  def complete_ripple
    id = params[:id]
    if id      
      @notification = Notification.find(params[:id])
      if @notification.user_id == current_user.id
        @user = User.find(current_user.id)
        @contact = Contact.find(@user.contact_id)

        if @notification.ripple_id
          sent_contact = Contact.find(@notification.sent_contact_id)
          sent_contact.update_attribute(:linked_contact_id, @contact._id)
          sent_contact.update_attribute(:is_ripple, true)
          sent_contact.save
        else
          #adds new contact as none exists if initiated from user search
          contact = Contact.new(
            :name => @contact.name, 
            :user_id => @notification.sent_id,
            :linked_contact_id => @contact._id,
            :is_ripple => true,
            :facebook_id => @contact.facebook_id,
            :linkedin_id => @contact.linkedin_id,
            :twitter_id => @contact.twitter_id,
            :facebook_picture => @contact.facebook_picture,
            :twitter_picture => @contact.twitter_picture,
            :linkedin_picture => @contact.linkedin_picture      
          )
          contact.save
        end
    


        #Adds user ids to the current users contact who have access to thier contact details
        @contact.push(:linked_user_ids, @notification.sent_id)
        a = @contact.linked_user_ids.uniq
        @contact.update_attribute(:linked_user_ids, a)
        @contact.save
 
        #Adds contact ids to the target user to list which contacts they have access to
        @target_user = User.find(@notification.sent_id)
        @target_user.push(:linked_contact_ids, @user.contact_id)
        b = @target_user.linked_contact_ids.uniq
        @target_user.update_attribute(:linked_contact_ids, b)
        @target_user.save	
      end
    end

    respond_to do |format|
      format.json { head :ok }
    end
    
  end
  
end
