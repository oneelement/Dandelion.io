class RippleApp.Views.SocialFeeds extends Backbone.View
  template: JST['contact_manager/social_feeds']
  socialNone: JST['contact_manager/social_none']
  id: 'social-wrapper'
  
  events:
    'keypress #social-post': 'postsocial'
    'click .dicon-facebook.post-source': 'selectPostFacebook'
    'click .dicon-twitter.post-source': 'selectPostTwitter'
    'focus #social-post': 'focusPost'
  
  initialize: ->
    @model.on('change', @reRender, this)
    @user = @options.user
    @globalTimeline = RippleApp.contactsRouter.globalTimeline
    @globalPictures = RippleApp.contactsRouter.globalPictures
    #@timeline = @options.timeline
    #@pictures = @options.pictures
    @timeline = @globalTimeline.get(@model.get('_id'))
    @pictures = @globalPictures.get(@model.get('_id'))
    @source = @options.source
  
  render: ->
    $(@el).html(@template())
    
    @getSocialFeed()   
    
    console.log(@timeline)
        
    #console.log('render social feeds')
      
    return this
    
  reRender: ->
    facebook_changed = @model.hasChanged('facebook_id')
    twitter_changed = @model.hasChanged('twitter_id')
    if facebook_changed == true || twitter_changed == true
      $(@el).html(@template())
      @getSocialFeed() 
    
  getSocialFeed: ->
    this.$('#social-post-select').html('')
    auths = @user.get('authentications')
    if auths.length > 0
      twitter = auths.where(provider: "twitter")
      facebook = auths.where(provider: "facebook")
      if @source == 'home'
        if facebook.length > 0 || twitter.length > 0
           #calling timeline
           call = "home"
           @callTimeline(call)
           call = "picture_timeline"
           @getPictureTimeline(call)
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
      if @source == 'contact' || @source == 'group'
        if @model.get('facebook_id') || @model.get('twitter_id')
          #calling timeline
          id = @model.get('_id')
          call = "home?id=" + id
          @callTimeline(call)
          call = "picture_timeline?id=" + id
          @getPictureTimeline(call)
          #calling posts
          if @model.get('facebook_id')
            html = "<span class='dicon-facebook post-source'></span>"
            this.$('#social-post-select').append(html)
            @selectPostFacebook()  
          if @model.get('twitter_id')
            html = "<span class='dicon-twitter post-source'></span>"
            this.$('#social-post-select').append(html)
            @selectPostTwitter()
          html = "<span id='social-post-text'>select media</span>"
          this.$('#social-post-select').append(html)
        else
          message = "No social networks are connected, please connect them to view feeds."
          $(this.el).html(@socialNone(message: message))          
    else
      message = "Your profile is not connected to any social networks, please go to the settings menu and connect them."
      $(this.el).html(@socialNone(message: message))
   

    
  getPictureTimeline: (call) ->
    if @pictures
      collection = @pictures.get('picture_timeline')
      view = new RippleApp.Views.PictureTimeline(collection: collection)
      this.$('#picture-timeline-wrapper').html(view.render().el) 
      next = "<span class='dicon-arrow-right-4'></span>"
      prev = "<span class='dicon-arrow-left-4'></span>"
      this.$('#picture-timeline').jcarousel({itemFallbackDimension: 200, buttonNextHTML: next, buttonPrevHTML: prev})
    else
      @timelines = new RippleApp.Collections.Timelines([], { call : call })
      @timelines.fetch(success: (collection) =>
        picture_timeline = new RippleApp.Models.GlobalPicture()
        picture_timeline.set('picture_timeline', collection)
        picture_timeline.set('id', @model.get('_id'))
        @globalPictures.add(picture_timeline)
        view = new RippleApp.Views.PictureTimeline(collection: collection)
        this.$('#picture-timeline-wrapper').html(view.render().el)  
        #this.$('#picture-timeline').bxSlider({displaySlideQty: 3, moveSlideQty: 1})
        next = "<span class='dicon-arrow-right-4'></span>"
        prev = "<span class='dicon-arrow-left-4'></span>"
        this.$('#picture-timeline').jcarousel({itemFallbackDimension: 200, buttonNextHTML: next, buttonPrevHTML: prev})
      )
    
  callTimeline: (call) =>
    if @timeline
      collection = @timeline.get('timeline')
      this.$('#timeline-wrapper').html('')
      view = new RippleApp.Views.Timeline(collection: collection)
      this.$('#timeline-wrapper').append(view.render().el)
      this.$('#social-loading').addClass('disabled')  
    else
      @timelines = new RippleApp.Collections.Timelines([], { call : call })
      @timelines.fetch(success: (collection) =>
        timeline = new RippleApp.Models.GlobalTimeline()
        timeline.set('timeline', collection)
        timeline.set('id', @model.get('_id'))
        @globalTimeline.add(timeline)
        $('#timeline-wrapper').html('')
        view = new RippleApp.Views.Timeline(collection: collection)
        $('#timeline-wrapper').append(view.render().el)
        $('#social-loading').addClass('disabled')        
      ) 
    
  selectPostFacebook: ->
    this.$('.post-source').removeClass('active')
    this.$('.dicon-facebook.post-source').addClass('active')
    html = "<span class='dicon-facebook active'></span>"
    this.$('#social-post-source').html(html)
    this.$('#social-post').attr('value', '')
    if @source == 'home'
      this.$('#social-post').attr('placeholder', 'post something...')
    else
      name = @model.get('name')
      last = name.substr(-1)
      if last == 's'
        placeholder = "post something on " + name + "' wall..."
      else
        placeholder = "post something on " + name + "'s wall..."
      this.$('#social-post').attr('placeholder', placeholder)
    @currentSocial = 'facebook'
    
  selectPostTwitter: ->
    this.$('.post-source').removeClass('active')
    this.$('.dicon-twitter.post-source').addClass('active')
    html = "<span class='dicon-twitter active'></span>"
    this.$('#social-post-source').html(html)
    this.$('#social-post').attr('value', '')
    this.$('#social-post').attr('placeholder', 'tweet something...')    
    @currentSocial = 'twitter'
    
  focusPost: ->
    if @source == 'contact' || @source == 'group'
      if @currentSocial == 'twitter'
        screen_name = "@" + @model.get('twitter_id') + " "
        this.$('#social-post').attr('value', screen_name)
    
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
    id = @model.get('facebook_id')
    text = this.$('#social-post').val()
    call = "wallpost/?text=" + text + "&id=" + id
    console.log(text)
    @faces = new RippleApp.Collections.Faces([], { call : call })
    @faces.fetch(success: (collection) =>
      console.log(collection)      
    )     
    this.$('#social-post').val('')
    
    
##############################################################
#Everythng below is currently obsolete
##############################################################
    
  getSocials: =>
    $('#tweets-loading').addClass('disabled')
    auths = @user.get('authentications')
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
    socials = @model.get('socials')
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