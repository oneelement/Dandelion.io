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
    @getFacebook()
    @getLinkedin()
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
    call = "/show"
    @tweets = new RippleApp.Collections.Tweets([], { call : call })
    #@collection.each(@appendTweet)
    @tweets.fetch(success: (collection) =>
      console.log(collection)
      view = new RippleApp.Views.Twitter(collection: collection)
      $('#twitter-wrapper').append(view.render().el)
      $('#tweets-loading').addClass('disabled')
      #@getTweets()
      #collection.each(@appendTweet)
    )
    
  getFacebook: =>
    #social_id = @getSocialId('facebook')
    social_id = "chestermano"
    call = "/show"
    @faces = new RippleApp.Collections.Faces([], { call : call })
    @faces.fetch(success: (collection) =>
      console.log(collection)
      view = new RippleApp.Views.Facebook(collection: collection)
      $('#facebook-wrapper').append(view.render().el)
      $('#faces-loading').addClass('disabled')
    )
    
  getLinkedin: =>
    #social_id = @getSocialId('facebook')
    social_id = "chestermano"
    call = "/show"
    @linkedins = new RippleApp.Collections.Linkedins([], { call : call })
    @linkedins.fetch(success: (collection) =>
      console.log(collection)
      view = new RippleApp.Views.Linkedin(collection: collection)
      $('#linkedin-wrapper').append(view.render().el)
    )
    
    
  #redundant function, dont delete. OC  
  appendTweet: (tweet) ->
    view = new RippleApp.Views.Tweet(model: tweet)
    $('#tweets').append(view.render().el)
  
  #redundant function, dont delete. OC
  getTweets: ->
    view = new RippleApp.Views.Twitter(collection: @tweets)
    $('#twitter-wrapper').append(view.render().el)
    



