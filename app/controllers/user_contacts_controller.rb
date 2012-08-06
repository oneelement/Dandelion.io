class UserContactsController < ApplicationController
  
  def index
    @contacts = Contact.where(:is_user => true)
    
    @user = User.find(current_user.id)
    
    a = @user.linked_contact_ids
    
    @contacts = @contacts.find(a)
    
    respond_to do |format|
      format.json { render_for_api :user_contact, :json => @contacts }
    end
  end
  
  def show
    id = params[:id]
    @contacts = Contact.where(:is_user => true)
    
    if id
      @contact = @contacts.find(id)
      @user_id = current_user._id      
      @user = @user_id.to_s
    
      if @contact.linked_user_ids.include?(@user)
        @contact = @contact
      else
        @contact = nil
      end
    else
      @contact = nil
    end
    
    respond_to do |format|
      format.json { render_for_api :user_contact, :json => @contact }
    end
  end
end
