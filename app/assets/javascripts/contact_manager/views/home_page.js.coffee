class RippleApp.Views.HomePage extends Backbone.View
  template: JST['contact_manager/home_page']
  
  initialize: ->
    @model.on('change', @render, this)
    @contact = @options.contact
    console.log(@contact)
  
  render: ->
    $(@el).html(@template(user: @model.toJSON(), contact: @contact.toJSON()))
    #@getTweets()   
    @getTwitter()
    this
    
  getSocialId: (socialnetwork) ->
    socials = @contact.get('socials')
    #console.log(socials)
    network = socials.filter (social) => 
      social.get("type") == socialnetwork
    #console.log(network)
    social_id = network[0].get('social_id')
    #console.log(social_id)
    #@getTwitter(twitter_id)
    return social_id
    
  getTwitter: ->
    #social_id = @getSocialId('facebook')
    social_id = "chestermano"
    #url = "https://search.twitter.com/search.json?q=" + social_id + "&callback=?"
    url = "https://api.twitter.com/1/statuses/user_timeline.json?count=5&screen_name=" + social_id
    @tweets = new RippleApp.Collections.Tweets()
    #@collection.each(@appendTweet)
    @tweets.fetch(success: (collection) =>
      console.log(collection)
      view = new RippleApp.Views.Twitter(collection: collection)
      $('#twitter-wrapper').append(view.render().el)
      #@getTweets()
      #collection.each(@appendTweet)
    )
    
  getFacebook: =>
    console.log("TBC")
    
    
  #redundant function, dont delete. OC  
  appendTweet: (tweet) ->
    view = new RippleApp.Views.Tweet(model: tweet)
    $('#tweets').append(view.render().el)
  
  #redundant function, dont delete. OC
  getTweets: ->
    view = new RippleApp.Views.Twitter(collection: @tweets)
    $('#twitter-wrapper').append(view.render().el)
    



