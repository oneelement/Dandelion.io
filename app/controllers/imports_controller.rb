class ImportsController < ApplicationController

  
  
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
	  avatar = @user.linkedin.profile(:id => connection_id, :fields => [:picture_url])
	  if avatar.picture_url != nil
	    picture = avatar.picture_url
	  else
	    picture = "http://placehold.it/80x80"
	  end
	  contact = Contact.new(:name => name, :user_id => id, :linkedin_id => connection_id, :avatar => picture)
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
