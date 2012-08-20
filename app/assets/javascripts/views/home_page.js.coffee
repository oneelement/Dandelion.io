class RippleApp.Views.HomePage extends Backbone.View
  template: JST['contact_manager/home_page']
  id: 'social-wrapper'
  
  events:
    'keypress #social-post': 'postsocial'
    'click .dicon-facebook.post-source': 'selectPostFacebook'
    'click .dicon-twitter.post-source': 'selectPostTwitter'
  
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
    #@getTwitter()
    
    #@getPictureTimeline()
    
    this.$('#social-post-select').html('')
    
    auths = @model.get('authentications')
    twitter = auths.where(provider: "twitter")
    facebook = auths.where(provider: "facebook")
    if facebook.length > 0
      @getTimeline()
      @getPictureTimeline()
    else if twitter.length > 0
      @getTimeline()
      @getPictureTimeline()
      
    if auths
      @getPosting(auths)
      
    return this
    
  getPosting: (auths) ->
    twitter = auths.where(provider: "twitter")
    facebook = auths.where(provider: "facebook")
    if facebook.length > 0
      html = "<span class='dicon-facebook post-source'></span>"
      this.$('#social-post-select').append(html)
      @selectPostFacebook()
    if twitter.length > 0
      html = "<span class='dicon-twitter post-source'></span>"
      this.$('#social-post-select').append(html)
      @selectPostTwitter()
    html = "<span id='social-post-text'>select media</span>"
    this.$('#social-post-select').append(html)
    
  getPictureTimeline: ->
    console.log('Picture Timeline')
    call = "picture_timeline"
    @timelines = new RippleApp.Collections.Timelines([], { call : call })
    @timelines.fetch(success: (collection) =>
      view = new RippleApp.Views.PictureTimeline(collection: collection)
      this.$('#picture-timeline-wrapper').append(view.render().el)  
      this.$('#picture-timeline').bxSlider({displaySlideQty: 3, moveSlideQty: 1})
    )
    
  getTimeline: ->
    call = "home"
    @timelines = new RippleApp.Collections.Timelines([], { call : call })
    @timelines.fetch(success: (collection) =>
      view = new RippleApp.Views.Timeline(collection: collection)
      $('#timeline-wrapper').append(view.render().el)
      $('#social-loading').addClass('disabled')        
    )  
    
  selectPostFacebook: ->
    this.$('.post-source').removeClass('active')
    this.$('.dicon-facebook.post-source').addClass('active')
    html = "<span class='dicon-facebook active'></span>"
    this.$('#social-post-source').html(html)
    this.$('#social-post').attr('placeholder', 'post something...')
    @currentSocial = 'facebook'
    
  selectPostTwitter: ->
    this.$('.post-source').removeClass('active')
    this.$('.dicon-twitter.post-source').addClass('active')
    html = "<span class='dicon-twitter active'></span>"
    this.$('#social-post-source').html(html)
    this.$('#social-post').attr('placeholder', 'tweet something...')
    @currentSocial = 'twitter'
    
  postsocial: (event) ->
    if (event.keyCode == 13) 
      if @currentSocial == 'facebook'
        @postFacebook()
      if @currentSocial == 'twitter'
        @postTwitter()
      
    
  postTwitter: ->
    text = this.$('#social-post').val()
    call = "tweet/?text=" + text
    console.log(text)
    @tweets = new RippleApp.Collections.Tweets([], { call : call })
    @tweets.fetch(success: (collection) =>
      console.log(collection)        
    )      
    this.$('#social-post').val('')      
    
  postFacebook: ->
    text = this.$('#social-post').val()
    call = "wallpost/?text=" + text
    console.log(text)
    @faces = new RippleApp.Collections.Faces([], { call : call })
    @faces.fetch(success: (collection) =>
      console.log(collection)      
    )     
    this.$('#social-post').val('')
    
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