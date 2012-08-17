class RippleApp.Views.HomePage extends Backbone.View
  template: JST['contact_manager/home_page']
  id: 'social-wrapper'
  
  events:
    'keypress #twitter-post': 'postTwitter'
    'keypress #facebook-post': 'postFacebook'
  
  initialize: ->
    @model.on('change', @render, this)
    @contact = @options.contact
    @globalTweets = @options.globalTweets
    @tweets = @options.tweets
    @globalFaces = @options.globalFaces
    @faces = @options.faces
  
  render: ->
    $(@el).html(@template())
    $('#sidebar-home').addClass('active')
    #@getSocials()
    
    auths = @model.get('authentications')
    twitter = auths.where(provider: "twitter")
    facebook = auths.where(provider: "facebook")
    if facebook.length > 0
      @getTimeline()
    else if twitter.length > 0
      @getTimeline()
    
    return this
    
  getTimeline: ->
    call = "home"
    @timelines = new RippleApp.Collections.Timelines([], { call : call })
    @timelines.fetch(success: (collection) =>
      view = new RippleApp.Views.Timeline(collection: collection)
      $('#timeline-wrapper').append(view.render().el)
      $('#social-loading').addClass('disabled')        
    )  
    
  postTwitter: (event) ->
    if (event.keyCode == 13) 
      text = this.$('#twitter-post').val()
      call = "tweet/?text=" + text
      console.log(text)
      @tweets = new RippleApp.Collections.Tweets([], { call : call })
      @tweets.fetch(success: (collection) =>
        console.log(collection)        
      )      
      this.$('#twitter-post').val("")      
    
  postFacebook: (event) ->
    if (event.keyCode == 13) 
      text = this.$('#facebook-post').val()
      call = "wallpost/?text=" + text
      console.log(text)
      @faces = new RippleApp.Collections.Faces([], { call : call })
      @faces.fetch(success: (collection) =>
        console.log(collection)      
      )     
      this.$('#facebook-post').val("")
    
  getSocials: =>
    $('#tweets-loading').addClass('disabled')
    auths = @model.get('authentications')
    #console.log(auths.models)
    twitter = auths.filter (auth) =>      
      auth.get('provider') == 'twitter'
      
    if twitter[0]?
      @getTwitter()
    else
      this.$('#tweets-loading').addClass('disabled')
      this.$('#tweets').append('<li class="tweet">Please authorise Twitter in user profile to view tweets.</li>')
    facebook = auths.filter (auth) =>
      auth.get('provider') == 'facebook'
    if facebook[0]?
      @getFacebook()
    else
      this.$('#faces-loading').addClass('disabled')
      this.$('#faces').append('<li class="face">Please authorise Facebook in user profile to view feed.</li>')
    linkedin = auths.filter (auth) =>
      auth.get('provider') == 'linkedin'
    #if linkedin[0]?        
      #@getLinkedin()
      #return
    
  getSocialId: (socialnetwork) ->
    socials = @contact.get('socials')
    #console.log(socials)
    network = socials.filter (social) => 
      social.get("type") == socialnetwork
    #console.log(network)
    if network
      social_id = network[0].get('social_id')
      return social_id
    
  getTwitter: =>
    #social_id = @getSocialId('facebook')
    #console.log(social_id)
    #social_id = "chestermano"
    #url = "https://search.twitter.com/search.json?q=" + social_id + "&callback=?"
    if @tweets
      collection = @tweets.get('tweets')
      view = new RippleApp.Views.Twitter(collection: collection)
      this.$('#twitter-wrapper').append(view.render().el)
      this.$('#tweets-loading').addClass('disabled')
    else
      call = "hometimeline"
      @tweets = new RippleApp.Collections.Tweets([], { call : call })
      @tweets.fetch(success: (collection) =>
        myTweets = new RippleApp.Models.GlobalTweet()
        myTweets.set('tweets', collection)
        myTweets.set('id', @model.get('_id'))
        @globalTweets.add(myTweets)
        view = new RippleApp.Views.Twitter(collection: collection)
        $('#twitter-wrapper').append(view.render().el)
        $('#tweets-loading').addClass('disabled')
      )
    
  getFacebook: =>
    if @faces
      collection = @faces.get('faces')
      view = new RippleApp.Views.Facebook(collection: collection)
      this.$('#facebook-wrapper').append(view.render().el)
      this.$('#faces-loading').addClass('disabled')
    else
      call = ""
      @faces = new RippleApp.Collections.Faces([], { call : call })
      @faces.fetch(success: (collection) =>
        myFaces = new RippleApp.Models.GlobalFace()
        myFaces.set('faces', collection)
        myFaces.set('id', @model.get('_id'))
        @globalFaces.add(myFaces)
        #console.log(collection)
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
      #console.log(collection)
      view = new RippleApp.Views.Linkedin(collection: collection)
      $('#linkedin-wrapper').append(view.render().el)
    )