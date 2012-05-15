class ImportsController < ApplicationController
  def index
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
    redirect_to(user_path(:id => current_user.id))
    #redirect_to current_user
  end
  
  def facebook
  end
end
