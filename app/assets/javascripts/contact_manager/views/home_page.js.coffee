class RippleApp.Views.HomePage extends Backbone.View
  template: JST['contact_manager/home_page']
  
  events:
    'click #twitter-feed, #facebook-feed': 'toggleTab'
    'keypress #twitter-post': 'postTwitter'
    'keypress #facebook-post': 'postFacebook'
  
  initialize: ->
    @model.on('change', @render, this)
    @contact = @options.contact
    console.log(@contact)
  
  render: ->
    $(@el).html(@template(user: @model.toJSON(), contact: @contact.toJSON()))
    #@getTweets()  
    #@getSocials()
    
    return this
    
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
    
  toggleTab: (event) ->
    console.log(event.target.id)
    target = event.target
    targetId = event.target.id
    this.$('li').removeClass('active')
    $(target, @el).addClass('active')
    if targetId == "facebook-feed"
      this.$('#twitter-wrapper').addClass('disabled')
      this.$('#facebook-wrapper').removeClass('disabled')
    if targetId == "twitter-feed"
      this.$('#facebook-wrapper').addClass('disabled')
      this.$('#twitter-wrapper').removeClass('disabled')
    
  getSocials: =>
    $('#tweets-loading').addClass('disabled')
    auths = @model.get('authentications')
    console.log(auths.models)
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
    if linkedin[0]?        
      @getLinkedin()
      return
    
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
    call = "hometimeline"
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
    #call = "search/?q=" + social_id
    call = ""
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
    



