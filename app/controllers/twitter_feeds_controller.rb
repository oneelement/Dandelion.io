class TwitterFeedsController < ApplicationController
  
  
  def index
  end
  
  def home
    @user = User.find(current_user.id)
    tweet = @user.tweeting.home_timeline(:count => '10', :trim_user => 1, :exclude_replies => 1)
    
    list = tweet.map {|u| Hash[ :text => u.text ]} 
    #render json: list
    render :json => list.to_json
  end
  
  
  def hometimeline
    social_id = params[:id]
    @user = User.find(current_user.id)
    #@user = User.find(current_user.id)
    #query = "chestermano"
    tweets = @user.tweeting.user_timeline(:count => '25', :include_rts => true, :include_entities => true)
    #tweets = @user.tweeting.user_search(query)
    
    parsed_tweets = []
    
    tweets.each do |tweet| 
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
      
      
      time = Time.now.localtime
      
      tw_time = tweet.created_at.localtime
      
      seconds_ago = time.to_i - tw_time.to_i
      
      internal_hash = Hash.new      
      
      internal_hash['seconds_ago'] = seconds_ago
      internal_hash['parsed_text'] = output
      internal_hash['time'] = tw_time.to_i
      internal_hash['id'] = tweet.id
      internal_hash['raw_text'] = tweet.text
      
      if tweet.retweeted_status
        tweet = tweet.retweeted_status
      end      
      
      internal_hash['name'] = tweet.user.name
      internal_hash['screen_name'] = tweet.user.screen_name
      internal_hash['user_id'] = tweet.user.id
      internal_hash['user_image_url'] = tweet.user.profile_image_url
      parsed_tweets << internal_hash
    end

    respond_to do |format|
      format.json { render :json => tweets }
    end
  end
  
  def search
    query = params[:q]
    #query = "chestermano"
    @user = User.find(current_user.id)
    search = @user.tweeting.user_search(query)

    respond_to do |format|
      format.json { render :json => search }
    end
  end
  
  def contacttimeline
    social_id = params[:id]
    @user = User.find(current_user.id)
    tweets = @user.tweeting.user_timeline(:screen_name => social_id, :count => '10', :include_entities => true)

    parsed_tweets = []
    
    tweets.each do |tweet| 
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
      
      internal_hash = Hash.new      
      
      internal_hash['parsed_text'] = output
      internal_hash['id'] = tweet.id
      internal_hash['raw_text'] = tweet.text
      internal_hash['name'] = tweet.user.name
      internal_hash['screen_name'] = tweet.user.screen_name
      internal_hash['user_id'] = tweet.user.id
      internal_hash['user_image_url'] = tweet.user.profile_image_url
      parsed_tweets << internal_hash
    end

    respond_to do |format|
      format.json { render :json => parsed_tweets }
    end
    
  end
  
  def tweet
    text = params[:text]
    @user = User.find(current_user.id)
    tweets = @user.tweeting.update(text)

    respond_to do |format|
      format.json { render :json => tweets }
    end
  end
  

end
