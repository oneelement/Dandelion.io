class ImportFacebook
  
  def self.import(user_id)
    @id = user_id
    @user = User.find(@id)
    
    @import_count = 0
    
    if @user.facebook
      @friends = @user.facebook.get_connections("me", "friends", :fields => "name, id, about, education, work, location, website")
      @friends.each do |face|        
        id = face["id"]
        if FacebookFriend.where(:facebook_id => id, :user_id => @id).exists?
        else
          name = face["name"]
	  if face["website"]
	    url = face["website"]
	  else	    
	    url = nil
	  end
	  if face["location"]
	    location = face["location"]["name"]
	  else
	    location = nil
	  end
          friend = FacebookFriend.new(
	    :name => name, 
	    :facebook_id => id, 
	    :user_id => @id,
	    :location => location,
	    :url => url
	  )
          friend.save
	  #maybe we should only de-dedupe on facebook_id for facebook?
	  if Contact.where(:name => name, :user_id => @id).exists?
	    avatar = 'https://graph.facebook.com/' + id + '/picture?size=square'
            handle = 'https://www.facebook.com/' + id
	    @contact_dual = Contact.where(:name => name, :user_id => @id).first
	    if @contact_dual.facebook_id?
	      if @contact_dual.facebook_id == id
	      else
		@contact_dual = Contact.new(
		  :name => friend.name, 
		  :user_id => @id, 
		  :facebook_id => id, 
		  :facebook_handle => handle,
		  :avatar => avatar,
		  :facebook_picture => avatar
		)
		@contact_dual.save
		@import_count = @import_count + 1
		Import.create_url(@contact_dual, url)
		Import.create_location(@contact_dual, location)
		Import.create_facebook_educations(@contact_dual, face["education"])		
		Import.create_facebook_positions(@contact_dual, face["work"])
		
               friend.contact_id = @contact_dual._id
               friend.save
		
	      end
	    else
	      @contact_dual.facebook_id = id
	      @contact_dual.facebook_handle = handle
	      if @contact_dual.avatar.blank?
	        @contact_dual.avatar = avatar
	      end
	      @contact_dual.facebook_picture = avatar
	      @contact_dual.save
              Import.create_url(@contact_dual, url)
	      Import.create_location(@contact_dual, location)
	      Import.create_facebook_educations(@contact_dual, face["education"])		
	      Import.create_facebook_positions(@contact_dual, face["work"])
	    end
	  else
	    avatar = 'https://graph.facebook.com/' + id + '/picture?size=square'
	    handle = 'https://www.facebook.com/' + id
	    @contact_dual = Contact.new(
	      :name => friend.name, 
	      :user_id => @id, 
	      :facebook_id => id, 
	      :facebook_handle => handle,
	      :avatar => avatar,
	      :facebook_picture => avatar
	    )
	    @contact_dual.save
	    @import_count = @import_count + 1
	    Import.create_url(@contact_dual, url)	    
	    Import.create_location(@contact_dual, location)	    
	    Import.create_facebook_educations(@contact_dual, face["education"])	    
	    Import.create_facebook_positions(@contact_dual, face["work"])
	    
	    friend.contact_id = @contact_dual._id
            friend.save
	  end
	
	end
      end
      @facefriends = FacebookFriend.where(:user_id => @id).asc(:name)
      #would be nice if this was kept to just the exists clause, OC, check contact.rb clear_delete method
      @facefriends = @facefriends.any_of({ :contact_id.exists => false }, { :contact_id => "" })      
    end #@user.facebook
    
    return @import_count  
  end #self.import
  
end