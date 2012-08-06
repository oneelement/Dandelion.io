class RippleApp.Views.ContactShow extends Backbone.View
  template: JST['contact_manager/contact_show']
  className: 'contact-show'
  
  events:
    'click #twitter-feed, #facebook-feed, #linkedin-feed': 'toggleTab'
    'keypress #twitter-post': 'postTwitter'
    'keypress #facebook-post': 'postFacebook'
  
  initialize: ->
    @model.on('change', @render, this)
    @user = @options.user
    @globalTweets = @options.globalTweets
    @globalFaces = @options.globalFaces
    
  render: ->
    $(@el).html(@template(contact: @model.toJSON()))
    @livetweets = @globalTweets.get(@model.get('twitter_id'))
    @livefaces = @globalFaces.get(@model.get('facebook_id'))
    @getSocials()      

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
    
  postFacebook: (event) =>
    if (event.keyCode == 13) 
      facebook = @model.get('facebook_id')
      text = this.$('#facebook-post').val()
      call = "wallpost/?text=" + text + "&id=" + facebook
      console.log(text)
      @faces = new RippleApp.Collections.Faces([], { call : call })
      @faces.fetch(success: (collection) =>
        console.log(collection)      
      )     
      this.$('#facebook-post').val("")
    
  toggleTab: (event) ->
    target = event.target
    targetId = event.target.id
    this.$('li').removeClass('active')
    $(target, @el).addClass('active')
    if targetId == "facebook-feed"
      this.$('#facebook-wrapper').removeClass('disabled')
      this.$('#twitter-wrapper').addClass('disabled')
      this.$('#linkedin-wrapper').addClass('disabled')
    if targetId == "twitter-feed"
      this.$('#twitter-wrapper').removeClass('disabled')
      this.$('#facebook-wrapper').addClass('disabled')
      this.$('#linkedin-wrapper').addClass('disabled')
    if targetId == "linkedin-feed"
      this.$('#linkedin-wrapper').removeClass('disabled')
      this.$('#facebook-wrapper').addClass('disabled')
      this.$('#twitter-wrapper').addClass('disabled')

    
  getSocials: ->
    auths = @user.get('authentications')
    socials = @model.get('socials')
    
    twitter = auths.filter (auth) =>
      auth.get('provider') == 'twitter'
    if twitter[0]?
      #twitter_social = socials.filter (social) => 
        #social.get("type") == 'twitter'
      twitter = @model.get('twitter_id')
      if twitter?
        @getTwitter(twitter)
      else
        this.$('#tweets-loading').addClass('disabled')
        this.$('#tweets').append('<li class="face">Please connect contact to Twitter.</li>')
    else
      this.$('#tweets-loading').addClass('disabled')
      this.$('#tweets').append('<li class="tweet">Please authorise Twitter in user profile to view tweets.</li>')
    
    facebook = auths.filter (auth) =>
      auth.get('provider') == 'facebook'
    if facebook[0]?
      #facebook_social = socials.filter (social) => 
        #social.get("type") == 'facebook'
      facebook = @model.get('facebook_id')
      if facebook?
        @getFacebook(facebook)
      else
        this.$('#faces-loading').addClass('disabled')
        this.$('#faces').append('<li class="face">Please connect contact to Facebook.</li>')
    else
      this.$('#faces-loading').addClass('disabled')
      this.$('#faces').append('<li class="face">Please authorise Facebook in user profile to view feed.</li>')
    
    linkedin = auths.filter (auth) =>
      auth.get('provider') == 'linkedin'
    if linkedin[0]?        
      #linkedin_social = socials.filter (social) => 
        #social.get("type") == 'linkedin'
      linkedin = @model.get('linkedin_id')
      if linkedin?
        @getLinkedin(linkedin)

  
  #this function will become redundant if social id is passed from getSocials, however will not refactor 
  #for now as the way this is done may change. OC
  getSocialId: (socialnetwork) ->
    socials = @model.get('socials')
    #console.log(socials)
    network = socials.filter (social) => 
      social.get("type") == socialnetwork
    #console.log(network)
    if network
      social_id = network[0].get('social_id')
      return social_id
    
  getTwitter: (id) =>
    #social_id = @getSocialId('twitter')
    #console.log(social_id)
    #social_id = "basil"
    #url = "https://search.twitter.com/search.json?q=" + social_id + "&callback=?"
    if @livetweets
      collection = @livetweets.get('tweets')
      view = new RippleApp.Views.Twitter(collection: collection)
      this.$('#twitter-wrapper').append(view.render().el)
      this.$('#tweets-loading').addClass('disabled')
    else
      call = "contacttimeline?id=" + id
      @tweets_collection = new RippleApp.Collections.Tweets([], { call : call })
      @tweets_collection.fetch(success: (collection) =>
        myTweets = new RippleApp.Models.GlobalTweet()
        myTweets.set('tweets', collection)
        myTweets.set('id', id)
        @globalTweets.add(myTweets)
        view = new RippleApp.Views.Twitter(collection: collection)
        $('#twitter-wrapper').append(view.render().el)
        $('#tweets-loading').addClass('disabled')
      )
    
  getFacebook: (id) =>
    #social_id = @getSocialId('facebook')
    #social_id = "515112480"
    if @livefaces
      collection = @livefaces.get('faces')
      view = new RippleApp.Views.Facebook(collection: collection)
      this.$('#facebook-wrapper').append(view.render().el)
      this.$('#faces-loading').addClass('disabled')
    else
      call = "feed?id=" + id
      @faces_collection = new RippleApp.Collections.Faces([], { call : call })
      @faces_collection.fetch(success: (collection) =>
        myFaces = new RippleApp.Models.GlobalFace()
        myFaces.set('faces', collection)
        myFaces.set('id', id)
        @globalFaces.add(myFaces)
        view = new RippleApp.Views.Facebook(collection: collection)
        $('#facebook-wrapper').append(view.render().el)
        $('#faces-loading').addClass('disabled')
      )
      
  getLinkedin: (id) ->
    console.log(id)
    id = 'TQyNgqI-D4'
    call = "profile?id=" + id
    @linkedin_collection = new RippleApp.Collections.Linkedins([], { call : call })
    @linkedin_collection.fetch(success: (collection) =>
      console.log(collection)
      profile = collection.at(0)
      console.log(profile)
      view = new RippleApp.Views.Linkedin(model: profile)
      $('#linkedin-wrapper').append(view.render().el)
      $('#social-loading').addClass('disabled')
    )
      
