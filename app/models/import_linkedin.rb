class ImportLinkedin
  
  def self.import(user_id)  
    @id = user_id
    @user = User.find(@id)
    
    @import_count = 0
    
    if @user.linkedin
      @connections = @user.linkedin.connections(:fields => [:id, :first_name, :last_name, :headline, :picture_url, :public_profile_url, :positions, :educations, :location])
      @connections = @connections.all
      @connections.each do |connection|        
        id = connection.id
        handle = connection.public_profile_url
        if connection.picture_url != nil
          avatar = connection.picture_url
        else
          avatar = nil
        end
        if LinkedinConnection.where(:linkedin_id => id, :user_id => @id).exists?
        else
          if connection.id != "private"
	    location = connection.location.name
	    name = connection.first_name + " " + connection.last_name
            friend = LinkedinConnection.new(:name => name, :linkedin_id => id, :user_id => @id, :avatar => avatar, :handle => handle, :location => location)
            friend.save
	    Import.create_linkedin_positions(friend, connection.positions)	    

	    if Contact.where(:name => name, :user_id => @id).exists?
	      @contact_dual = Contact.where(:name => name, :user_id => @id).first
	      if @contact_dual.linkedin_id?
		if @contact_dual.linkedin_id != id
		  #if the linkedin id is different then it is a different person otherwise it is a duplicate
		  @contact_dual = Contact.new(
		    :name => name, 
		    :user_id => @id, 
		    :linkedin_id => id, 
		    :linkedin_handle => handle,
		    :avatar => avatar,
		    :linkedin_picture => avatar
		  )
		  @contact_dual.save
		  @import_count = @import_count + 1
		  Import.create_location(@contact_dual, location)
		  Import.create_linkedin_positions(@contact_dual, connection.positions)
		  friend.contact_id = @contact_dual._id
                 friend.save
		end
	      else
		#if they dont have a linkedin ID then we enhance the data here.
		@contact_dual.linkedin_id = id
	        @contact_dual.linkedin_handle = handle
	        if @contact_dual.avatar.blank?
	          @contact_dual.avatar = avatar
	        end
	        @contact_dual.linkedin_picture = avatar
	        @contact_dual.save
		Import.create_location(@contact_dual, location)
		Import.create_linkedin_positions(@contact_dual, connection.positions)
	      end
	    else
	      #Add Contact
	      @contact_dual = Contact.new(
		:name => name, 
		:user_id => @id, 
		:linkedin_id => id, 
		:linkedin_handle => handle,
		:avatar => avatar,
		:linkedin_picture => avatar
	      )
	      @contact_dual.save
	      @import_count = @import_count + 1
	      Import.create_location(@contact_dual, location)
	      Import.create_linkedin_positions(@contact_dual, connection.positions)
	      friend.contact_id = @contact_dual._id
              friend.save
	    end
	    

          end
	end
      end
      @linkedin_friends = LinkedinConnection.where(:user_id => @id).asc(:name)
      #would be nice if this was kept to just the exists clause, OC, check contact.rb clear_delete method
      @linkedin_friends = @linkedin_friends.any_of({ :contact_id.exists => false }, { :contact_id => "" })   
    end

    return @import_count      
  end  

end