class RippleApp.Views.ContactShow extends Backbone.View
  template: JST['contact_manager/contact_show']
  className: 'contact-show'
  
  events:
    'click #twitter-feed, #facebook-feed': 'toggleTab'
  
  initialize: ->
    @model.on('change', @render, this)
    @user = @options.user

  render: ->
    $(@el).html(@template(contact: @model.toJSON())) 
    #@getTwitter()
    #@getFacebook()
    @getSocials()

    return this
    
  toggleTab: (event) ->
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
    
  getSocials: ->
    auths = @user.get('authentications')
    socials = @model.get('socials')
    console.log(socials)
    twitter = auths.filter (auth) =>
      auth.get('provider') == 'twitter'
    if twitter[0]?
      twitter_social = socials.filter (social) => 
        social.get("type") == 'twitter'
      if twitter_social[0]?
        @getTwitter()
    else
      this.$('#tweets-loading').addClass('disabled')
      this.$('#tweets').append('<li class="tweet">Please authorise Twitter in user profile to view tweets.</li>')
    
    facebook = auths.filter (auth) =>
      auth.get('provider') == 'facebook'
    if facebook[0]?
      #facebook_social = socials.filter (social) => 
        #social.get("type") == 'facebook'
      facebook = @model.get('facebook_id')
      #console.log(facebook)
      if facebook?
        console.log(facebook)
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
      linkedin_social = socials.filter (social) => 
        social.get("type") == 'linkedin'
      if linkedin_social[0]?
        #@getLinkedin()
        return
  
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
    
  getTwitter: ->
    social_id = @getSocialId('twitter')
    #console.log(social_id)
    social_id = "basil"
    #url = "https://search.twitter.com/search.json?q=" + social_id + "&callback=?"
    call = "contacttimeline?id=" + social_id
    @tweets = new RippleApp.Collections.Tweets([], { call : call })
    @tweets.fetch(success: (collection) =>
      #console.log(collection)
      view = new RippleApp.Views.Twitter(collection: collection)
      $('#twitter-wrapper').append(view.render().el)
      $('#tweets-loading').addClass('disabled')
    )
    
  getFacebook: (id) =>
    #social_id = @getSocialId('facebook')
    #social_id = "515112480"
    call = "feed?id=" + id
    @faces = new RippleApp.Collections.Faces([], { call : call })
    @faces.fetch(success: (collection) =>
      view = new RippleApp.Views.Facebook(collection: collection)
      $('#facebook-wrapper').append(view.render().el)
      $('#faces-loading').addClass('disabled')
    )
