class ImportsController < ApplicationController
  
  def import_facebook
    id = current_user.id
    @user = User.find(id)
    if @user.facebook
      @friends = @user.facebook.get_connections("me", "friends")
      @friends.each do |face|        
        id = face["id"]
        if FacebookFriend.where(:facebook_id => id, :user_id => current_user.id).exists?
        else
          name = face["name"]
          friend = FacebookFriend.new(:name => name, :facebook_id => id, :user_id => current_user.id)
          friend.save
        end
      end
      @facefriends = FacebookFriend.where(:user_id => current_user.id).asc(:name)
      #would be nice if this was kept to just the exists clause, OC, check contact.rb clear_delete method
      @facefriends = @facefriends.any_of({ :contact_id.exists => false }, { :contact_id => "" })      
    end
    id = current_user.id
    #@friends = FacebookFriend.where(:user_id => id)
    #@friends = @friends.any_of({ :contact_id.exists => false }, { :contact_id => "" })
    @facefriends.each do |friend|
      avatar = 'https://graph.facebook.com/' + friend.facebook_id + '/picture?size=square'
      handle = 'https://www.facebook.com/' + friend.facebook_id
      contact = Contact.new(
        :name => friend.name, 
        :user_id => id, 
        :facebook_id => friend.facebook_id, 
        :facebook_handle => handle,
        :avatar => avatar,
        :facebook_picture => avatar
      )
      contact.save
      friend.contact_id = contact._id
      friend.save
    end

    respond_to do |format|
      format.json { render json: @facefriends }
    end

  end
  
  def import_twitter
  end
  
  def import_linkedin
  end
  
  def create
    if params[:faces]
      faces = params[:faces]
      id = current_user.id
      faces.each do |face|
        name = face[1]['name']
        check = face[1]['check']
	face_id = face[1]['face_id']
	avatar = 'https://graph.facebook.com/' + face_id + '/picture?size=square'
        if check  
          contact = Contact.new(:name => name, :user_id => id, :facebook_id => face_id, :avatar => avatar)
          contact.save
	  friend = FacebookFriend.where(:facebook_id => face_id, :user_id => id).first
	  friend.contact_id = contact._id
	  friend.save
        end   
	#contact = Contact.new(:name => name, :user_id => id)
	#contact.save
	#print face[0]["name"]
	#print "testing"
	#print face('name')
      end
    end
    
    if params[:connections]
      connections = params[:connections]
      id = current_user.id
      @user = User.find(id)
      connections.each do |connection|
	check = connection[1]['check']
	name = connection[1]['name']
	connection_id = connection[1]['connection_id']	
	if check
	  person = @user.linkedin.profile(:id => connection_id, :fields => [:picture_url, :public_profile_url])
	  if person.picture_url != nil
	    picture = person.picture_url
	  else
	    picture = ""
	  end
	  contact = Contact.new(:name => name, :user_id => id, :linkedin_id => person.public_profile_url, :avatar => picture)
          contact.save
	  connection = LinkedinConnection.where(:linkedin_id => connection_id, :user_id => id).first
	  connection.contact_id = contact._id
	  connection.save
	end
      end
    end
    redirect_to(user_path(:id => current_user.id))
    #redirect_to current_user
  end
  
end
