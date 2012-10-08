class ImportTwitter
  
 
  def self.import(user_id)
    @id = user_id
    @user = User.find(@id)

    
    if @user.tweeting
      @follows = @user.tweeting.friend_ids
      @follows = @follows.ids
    end
    
    size = @follows.size
    
    @friends = get_friends(size, @follows, @user)
    
    @import_count = 0
    
    @friends.each do |friend|
      id = friend.id
      if TwitterFollow.where(:twitter_id => id, :user_id => @id).exists?
      else
        name = friend.name
	avatar = friend.profile_image_url
	handle = "http://www.twitter.com/" + friend.screen_name
	screen_name = friend.screen_name
	if friend.url
	  url = friend.url
	else 
	  url = nil
	end
	if friend.location
	  location = friend.location
	else 
	  location = nil
	end
	location = friend.location
        friend = TwitterFollow.new(
	  :name => name, 
	  :twitter_id => id, 
	  :user_id => @id, 
	  :avatar => avatar, 
	  :handle => handle, 
	  :screen_name => screen_name,
	  :url => url,
	  :location => location
	)
        friend.save
	
	if Contact.where(:name => name, :user_id => @id).exists?
	  @contact_dual = Contact.where(:name => name, :user_id => @id).first
	  if @contact_dual.twitter_id?
	    if @contact_dual.twitter_id != screen_name
	      #if the twitter id is different then it is a different person otherwise it is a duplicate
	      @contact_dual = Contact.new(
		:name => name, 
		:user_id => @id, 
		:twitter_id => screen_name, 
		:twitter_handle => handle,
		:avatar => avatar,
		:twitter_picture => avatar
	      )
	      @contact_dual.save
	      @import_count = @import_count + 1
	      Import.create_location(@contact_dual, location)
	      Import.create_url(@contact_dual, url)
	      friend.contact_id = @contact_dual._id
	      friend.save
	    end
	  else
	    #if they dont have a twitter ID then we enhance the data here.
	    @contact_dual.twitter_id = screen_name
	    @contact_dual.twitter_handle = handle
	    if @contact_dual.avatar.blank?
	      @contact_dual.avatar = avatar
	    end
	    @contact_dual.twitter_picture = avatar
	    @contact_dual.save
	    Import.create_location(@contact_dual, location)
	    Import.create_url(@contact_dual, url)
	  end
	else
	  #Add Contact
	  @contact_dual = Contact.new(
	    :name => name, 
	    :user_id => @id, 
	    :twitter_id => screen_name, 
	    :twitter_handle => handle,
	    :avatar => avatar,
	    :twitter_picture => avatar
	  )
	  @contact_dual.save
	  @import_count = @import_count + 1
	  Import.create_location(@contact_dual, location)
	  Import.create_url(@contact_dual, url)
	  friend.contact_id = @contact_dual._id
	  friend.save
	end
	
      end
    end
    
    #@twitter_friends = TwitterFollow.where(:user_id => @id).asc(:name)
    #@twitter_friends = @twitter_friends.any_of({ :contact_id.exists => false }, { :contact_id => "" })   
    
    return @import_count
  end
  
  def self.get_friends(size, follows, user)    
    if size > 99
      if size > 199
	if size > 299
	  if size > 399
	    friend1 = follows[0..99]
            friend2 = follows[100..199]
	    friend3 = follows[200..299]
	    friend4 = follows[300..399]
	    friend5 = follows[400..499]
            friends = user.tweeting.users(friend1)
            friends = friends + user.tweeting.users(friend2)
	    friends = friends + user.tweeting.users(friend3)
	    friends = friends + user.tweeting.users(friend4)
	    friends = friends + user.tweeting.users(friend5)
	  else
            friend1 = follows[0..99]
            friend2 = follows[100..199]
	    friend3 = follows[200..299]
	    friend4 = follows[300..399]
            friends = user.tweeting.users(friend1)
            friends = friends + user.tweeting.users(friend2)
	    friends = friends + user.tweeting.users(friend3)
	    friends = friends + user.tweeting.users(friend4)
	  end
	else
	  friend1 = follows[0..99]
          friend2 = follows[100..199]
	  friend3 = follows[200..299]
          friends = user.tweeting.users(friend1)
          friends = friends + user.tweeting.users(friend2)
	  friends = friends + user.tweeting.users(friend3)
	end
      else
        friend1 = follows[0..99]
        friend2 = follows[100..199]
        friends = user.tweeting.users(friend1)
        friends = friends + user.tweeting.users(friend2)
      end
    else
      friends = user.tweeting.users(follows)
    end
    
    return friends
  end
  
end