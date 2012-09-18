class ImportsController < ApplicationController
  
  def import_facebook
    id = current_user.id
    @user = User.find(id)
    if @user.facebook
      @friends = @user.facebook.get_connections("me", "friends", :fields => "name, id, about, education, work, location, website")
      @friends.each do |face|        
        id = face["id"]
        if FacebookFriend.where(:facebook_id => id, :user_id => current_user.id).exists?
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
	    :user_id => current_user.id,
	    :location => location,
	    :url => url
	  )
          friend.save
	  if face["work"]
	    positions = face["work"]
	    i = 1
	    positions.each do |pos|
	      if pos["employer"]["name"]
		company = pos["employer"]["name"]
	      else
		company = nil
	      end
	      if pos["position"]
		title = pos["position"]["name"]
	      else
		title = nil
	      end
	      if i == 1
		current = true
	      else
		current = false
	      end
	      friend.positions.create!(
		:title => title,
		:company => company,
		:current => current
	      )
	      i = i + 1
	    end
	    friend.save
	  end
	  if face["education"]
	    educations = face["education"]
	    educations.each do |edu|
	      if edu["school"]["name"]
		title = edu["school"]["name"]
	      else
		title = nil
	      end
	      if edu["year"]
		year = edu["year"]["name"]
	      else
		year = nil
	      end
	      if edu["type"]
		if edu["type"] == "High School"
		  type = "EducationSchool"
		elsif edu["type"] == "College"
		type = "EducationCollege"
		end
	      else
		type = "Education"
	      end
	      friend.educations.create!(
		:title => title,
		:year => year,
		:_type => type
	      )
	    end
	    friend.save
	  end
        end
      end
      @facefriends = FacebookFriend.where(:user_id => current_user.id).asc(:name)
      #would be nice if this was kept to just the exists clause, OC, check contact.rb clear_delete method
      @facefriends = @facefriends.any_of({ :contact_id.exists => false }, { :contact_id => "" })      
    end
    id = current_user.id
    @import_count = @facefriends.size
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
      positions_fb = Position.where(:facebook_friend_id => friend._id)
      if positions_fb
        positions_fb.each do |pos|
	  contact.positions.create!(
            :title => pos.title,
            :company => pos.company,
	    :current => pos.current
          )
	  if pos.current == true
	    contact.current_position = pos.title
	    contact.current_company = pos.company
	  end
	end
      end
      educations_fb = Education.where(:facebook_friend_id => friend._id)
      if educations_fb
        educations_fb.each do |edu|
	  contact.educations.create!(
            :title => edu.title,
            :year => edu.year,
	    :_type => edu._type
          )
	end
      end
      contact.save
      if friend.location != nil
        contact.addresses.create!(
          :full_address => friend.location,
          :_type => 'AddressPersonal'
        )
      end
      if friend.url != nil
        contact.urls.create!(
          :text => friend.url,
          :_type => 'UrlPersonal'
        )
      end
      friend.contact_id = contact._id
      friend.save
    end

    respond_to do |format|
      format.json { render json: @import_count }
    end

  end
  
  def import_twitter
    id = current_user.id
    @user = User.find(id)
    if @user.tweeting
      @follows = @user.tweeting.friend_ids
      @follows = @follows.ids
    end
    
    size = @follows.size
    
    if size > 99
      if size > 199
	if size > 299
	  if size > 399
	    friend1 = @follows[0..99]
            friend2 = @follows[100..199]
	    friend3 = @follows[200..299]
	    friend4 = @follows[300..399]
	    friend5 = @follows[400..499]
            @friends = @user.tweeting.users(friend1)
            @friends = @friends + @user.tweeting.users(friend2)
	    @friends = @friends + @user.tweeting.users(friend3)
	    @friends = @friends + @user.tweeting.users(friend4)
	    @friends = @friends + @user.tweeting.users(friend5)
	  else
            friend1 = @follows[0..99]
            friend2 = @follows[100..199]
	    friend3 = @follows[200..299]
	    friend4 = @follows[300..399]
            @friends = @user.tweeting.users(friend1)
            @friends = @friends + @user.tweeting.users(friend2)
	    @friends = @friends + @user.tweeting.users(friend3)
	    @friends = @friends + @user.tweeting.users(friend4)
	  end
	else
	  friend1 = @follows[0..99]
          friend2 = @follows[100..199]
	  friend3 = @follows[200..299]
          @friends = @user.tweeting.users(friend1)
          @friends = @friends + @user.tweeting.users(friend2)
	  @friends = @friends + @user.tweeting.users(friend3)
	end
      else
        friend1 = @follows[0..99]
        friend2 = @follows[100..199]
        @friends = @user.tweeting.users(friend1)
        @friends = @friends + @user.tweeting.users(friend2)
      end
    else
      @friends = @user.tweeting.users(@follows)
    end
    
    @friends.each do |friend|
      id = friend.id
      if TwitterFollow.where(:twitter_id => id, :user_id => current_user.id).exists?
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
	  :user_id => current_user.id, 
	  :avatar => avatar, 
	  :handle => handle, 
	  :screen_name => screen_name,
	  :url => url,
	  :location => location
	)
        friend.save
      end
    end
    
    @twitter_friends = TwitterFollow.where(:user_id => current_user.id).asc(:name)
    @twitter_friends = @twitter_friends.any_of({ :contact_id.exists => false }, { :contact_id => "" })   
    
    @import_count = @twitter_friends.size
    
    @twitter_friends.each do |friend|
      id = current_user.id
      contact = Contact.new(
        :name => friend.name, 
        :user_id => id, 
        :twitter_id => friend.screen_name, 
        :twitter_handle => friend.handle,
        :avatar => friend.avatar,
	#:location => friend.location,
        :twitter_picture => friend.avatar	
      )
      contact.save
      if friend.url
        contact.urls.create!(
          :text => friend.url,
          :_type => 'UrlPersonal'
        )
      end
      if friend.location != ""
        contact.addresses.create!(
          :full_address => friend.location,
          :_type => 'AddressPersonal'
        )
      end
      friend.contact_id = contact._id
      friend.save
    end
    #@follows = @follows[0..9]
    
    respond_to do |format|
      format.json { render json: @import_count }
    end
  end
  
  def import_linkedin
    id = current_user.id
    @user = User.find(id)
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
        if LinkedinConnection.where(:linkedin_id => id, :user_id => current_user.id).exists?
        else
          if connection.id != "private"
	    location = connection.location.name
	    name = connection.first_name + " " + connection.last_name
            friend = LinkedinConnection.new(:name => name, :linkedin_id => id, :user_id => current_user.id, :avatar => avatar, :handle => handle, :location => location)
            friend.save
	    if connection.positions.total > 0
	      @positions = connection.positions.all
	      @positions.each do |pos|
		if pos.is_current
		  current = pos.is_current
		else
		  current = nil
		end
		if pos.title
		  title = pos.title
		else
		  title = nil
		end
		if pos.company.name
		  company = pos.company.name
		else
		  company = nil
		end
		friend.positions.create!(
                  :title => title,
                  :company => company,
		  :current => current
                )
	      end
	      friend.save
	    end
          end	  
        end
      end
      @linkedin_friends = LinkedinConnection.where(:user_id => current_user.id).asc(:name)
      #would be nice if this was kept to just the exists clause, OC, check contact.rb clear_delete method
      @linkedin_friends = @linkedin_friends.any_of({ :contact_id.exists => false }, { :contact_id => "" })   
    end
    
    @import_count = @linkedin_friends.size

    @linkedin_friends.each do |friend|
      id = current_user.id
      contact = Contact.new(
        :name => friend.name, 
        :user_id => id, 
        :linkedin_id => friend.linkedin_id, 
        :linkedin_handle => friend.handle,
        :avatar => friend.avatar,
        :linkedin_picture => friend.avatar
      )
      contact.save
      positions_li = Position.where(:linkedin_connection_id => friend._id)
      if positions_li
        positions_li.each do |pos|
	  contact.positions.create!(
            :title => pos.title,
            :company => pos.company,
	    :current => pos.current
          )
	  if pos.current == true
	    contact.current_position = pos.title
	    contact.current_company = pos.company
	  end
	end
	contact.save
      end
      if friend.location != ""
        contact.addresses.create!(
          :full_address => friend.location,
          :_type => 'AddressPersonal'
        )
      end
      friend.contact_id = contact._id
      friend.save
    end

    respond_to do |format|
      format.json { render json: @import_count }
    end
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
