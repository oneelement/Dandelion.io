class FacebookFeedsController < ApplicationController
  def index
    @user = User.find(current_user.id)
    
    #face = @user.facebook.get_object("me")
    #face = @user.facebook.get_connections("me", "friends")
    face = @user.facebook.get_connections('me', 'feed')

    respond_to do |format|
      format.json { render json: face }
    end
  end
  
  def feed
    social_id = params[:id]
    @user = User.find(current_user.id)
    
    #face = @user.facebook.get_object("me")
    #face = @user.facebook.get_connections("me", "friends")
    face = @user.facebook.get_connections(social_id, 'feed')

    respond_to do |format|
      format.json { render json: face }
    end
  end
  
  def search
    query = params[:q]
    #query = "Bubba G"
    @user = User.find(current_user.id)
    face = @user.facebook.search(query, {:type => "user"})

    respond_to do |format|
      format.json { render json: face }
    end
  end 
  
  def wallpost
    text = params[:text]
    id = params[:id]
    @user = User.find(current_user.id)
    #face = @user.facebook.put_wall_post(text
    face = @user.facebook.put_connections(id, 'feed', :message => text)
    #face = @user.facebook.get_connection('me', 'friends',  "fields" => "name, gender, email, address")
    #face = @user.facebook.get_object(id, "fields" => "name, gender, email, address")

    respond_to do |format|
      format.json { render json: face }
    end
  end
  
  def get_object
    id = params[:id]
    @user = User.find(current_user.id)
    face = @user.facebook.get_object(id)
    
    user_contact_id = @user.contact_id
    @contact = Contact.find(user_contact_id)
    @user_facebook_id = @contact.facebook_id
    
    my_id = @user_facebook_id
    
    time = Time.now.localtime 
      
    face_time = face['created_time']
    
    parsed_time = Time.parse(face_time)
    
    seconds_ago = time.to_i - parsed_time.to_i
    
    if face['type'] == 'status'
      output = face['message']
    elsif face['type'] == 'photo'
      output = face['story']
    elsif face['type'] == 'link'
      output = ''
    else
      output = ''
    end
    
    if face['story']
      output = face['story']
    elsif face['message']
      output = face['message']
    elsif face['description']
      output = face['description']
    end
    
    like_ind = false
    
    if face['likes']
      like_count = face['likes']['count']
      like_data = face['likes']['data']
      like_data.each do |like|
	if like['id'] == @user_facebook_id
	  like_ind = true
	end
      end
    else
      like_count = "0"
    end
    
    if face['comments']
      comment_count = face['comments']['count']
      comment_data = face['comments']['data']
      comments = []
      if comment_data
	comment_data.each do |comment|
	  comment_hash = Hash.new
	  comment_raw_time = comment['created_time']      
	  parsed_comment_time = Time.parse(comment_raw_time)
	  seconds = time.to_i - parsed_comment_time.to_i
	  minutes = seconds / 60
	  hours = minutes / 60
	  days = hours / 24
	  years = days / 365    
	  if seconds < 60
	    comment_time = "Just now"
	  elsif minutes < 60
	    if minutes.round.to_s == "1"
	      comment_time = minutes.round.to_s + " minute ago"
	    else
	      comment_time = minutes.round.to_s + " minutes ago"
	    end
	  elsif hours < 24
	    if hours.round.to_s == "1"
	      comment_time = hours.round.to_s + " hour ago"
	    else
	      comment_time = hours.round.to_s + " hours ago"
	    end
	  elsif days < 365
	    if days.round.to_s == "1"
	      comment_time = days.round.to_s + " day ago"
	    else
	      comment_time = days.round.to_s + " days ago"
	    end
	  else
	    comment_time = "Over a year ago"
	  end
	  comment_hash['seconds'] = seconds
	  comment_hash['time'] = comment_time
	  comment_hash['id'] = comment['id']  
	  comment_hash['message'] = comment['message']  
	  comment_hash['user'] = comment['from']['name']  
	  comment_hash['user_id'] = comment['from']['id'] 
	  comments << comment_hash
	end
	comments.sort! { |a, b|  b['seconds'] <=> a['seconds'] }
      end
    else
      comment_count = "0"
    end

    my_image_url = "http://graph.facebook.com/" + my_id + "/picture?type=square"
    user_image_url = "http://graph.facebook.com/" + face['from']['id'] + "/picture?type=square"
    
    internal_hash = Hash.new      
    
    internal_hash['source'] = 'facebook'
    internal_hash['seconds_ago'] = seconds_ago
    internal_hash['time'] = parsed_time.to_i
    internal_hash['date'] = parsed_time.strftime("%d %b")
    internal_hash['date_y'] = parsed_time.strftime("%d %b %y")
    internal_hash['id'] = face['id']
    internal_hash['user_id'] = face['from']['id']
    internal_hash['my_id'] = my_id
    internal_hash['my_image_url'] = my_image_url
    internal_hash['parsed_text'] = output
    internal_hash['picture'] = face['picture']
    internal_hash['link'] = face['link']
    internal_hash['type'] = face['type']
    internal_hash['user_image_url'] = user_image_url
    internal_hash['actions'] = face['actions']
    internal_hash['like_count'] = like_count
    internal_hash['like_data'] = like_data
    internal_hash['like_ind'] = like_ind
    internal_hash['comment_count'] = comment_count
    internal_hash['comment_parsed_data'] = comments
    internal_hash['raw'] = face
    respond_to do |format|
      format.json { render json: internal_hash }
    end
  end
  
  def like
    id = params[:id]
    @user = User.find(current_user.id)
    face = @user.facebook.put_like(id)

    respond_to do |format|
      format.json { render json: face }
    end
  end
  
  def unlike
    id = params[:id]
    @user = User.find(current_user.id)
    face = @user.facebook.delete_like(id)

    respond_to do |format|
      format.json { render json: face }
    end
  end
  
  def comment
    text = params[:text]
    id = params[:id]
    @user = User.find(current_user.id)
    face = @user.facebook.put_comment(id, text)

    respond_to do |format|
      format.json { render json: face }
    end
  end
end
