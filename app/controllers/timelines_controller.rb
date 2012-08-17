class TimelinesController < ApplicationController
  def home
    #get the current user
    @user = User.find(current_user.id)
    
    #fetch the users tweets
    if @user.tweeting
      twitter = @user.tweeting.user_timeline(count: '25', include_rts: true, include_entities: true)
    end
    
    #fetch the users facebook feed
    if @user.facebook
      facebook = @user.facebook.get_connections('me', 'feed')
    end
    
    user_contact_id = @user.contact_id
    @contact = Contact.find(user_contact_id)
    @user_facebook_id = @contact.facebook_id
    
    my_id = @user_facebook_id
    
    #set the current local time (server time)
    time = Time.now.localtime
    
    #set the timeline array
    timeline = []
    
    #FACEBOOK
    #add facebook posts to timeline
    if facebook
      facebook.each do |face|         
	
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

	timeline << internal_hash
      end
    end
    
    #TWITTER
    #add tweets to timeline
    if twitter
      twitter.each do |tweet| 
	text = tweet.text
	output = tweet.text

	tweet.user_mentions.each do |um|
	  string = "<a target='_blank' href='http://www.twitter.com/" + um.screen_name + "'>@" + um.screen_name + "</a> "
	  ind_place = text[um.indices[0]..um.indices[1]]
	  output = output.gsub(ind_place.to_s, string.to_s)
	end
	
	tweet.urls.each do |url|
	  string = "<a target='_blank' href='" + url.url + "'>" + url.display_url + "</a> "
	  ind_place = text[url.indices[0]..url.indices[1]]
	  output = output.gsub(ind_place.to_s, string.to_s)
	end
	
	tweet.media.each do |pic|
	  string = "<a target='_blank' href='" + pic.url + "'>" + pic.display_url + "</a> "
	  ind_place = text[pic.indices[0]..pic.indices[1]]
	  output = output.gsub(ind_place.to_s, string.to_s)
	end
	
	tweet.hashtags.each do |ht|
	  string = "<a target='_blank' href='https://twitter.com/search/%23" + ht.text + "'>#" + ht.text + "</a> "
	  ind_place = text[ht.indices[0]..ht.indices[1]]
	  output = output.gsub(ind_place.to_s, string.to_s)
	end  
	
	tw_time = tweet.created_at.localtime
	
	seconds_ago = time.to_i - tw_time.to_i
	internal_hash = Hash.new      
	
	internal_hash['source'] = 'twitter'
	internal_hash['seconds_ago'] = seconds_ago
	internal_hash['parsed_text'] = output
	internal_hash['time'] = tw_time.to_i
	internal_hash['date'] = tw_time.strftime("%d %b")
	internal_hash['date_y'] = tw_time.strftime("%d %b %y")
	internal_hash['id'] = tweet.id
	internal_hash['raw_text'] = tweet.text
	internal_hash['orig'] = tweet
	
	if tweet.retweeted_status
	  internal_hash['retweet_by_name'] = tweet.user.name
	  internal_hash['retweet_by_screen_name'] = tweet.user.screen_name
	  tweet = tweet.retweeted_status
	  retweet_ind = true
	else
	  retweet_ind = false
	end      
	
	internal_hash['name'] = tweet.user.name
	internal_hash['screen_name'] = tweet.user.screen_name
	internal_hash['user_id'] = tweet.user.id
	internal_hash['user_image_url'] = tweet.user.profile_image_url
	internal_hash['retweet_ind'] = retweet_ind
	
	timeline << internal_hash
      end
    end
    
    timeline.sort! { |a, b|  b['time'] <=> a['time'] }
    
    respond_to do |format|
      format.json { render json: timeline }
    end
  end
  
  def contact
  end
end
