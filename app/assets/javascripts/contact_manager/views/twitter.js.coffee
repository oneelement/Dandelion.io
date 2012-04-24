class RippleApp.Views.Twitter extends Backbone.View
  template: JST['contact_manager/twitter']
  tagName: 'ul'
  #id: 'tweets'
    
  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)
    @collection.on('destroy', @render, this)

  render: ->    
    $(@el).html(@template())
    console.log(@collection)
    @collection.each(@appendTweet) 
    this    
        
  getTweets: ->
    @collection.each(@appendTweet)
  
  appendTweet: (tweet) =>
    console.log(tweet)
    view = new RippleApp.Views.Tweet(model: tweet)
    $('#tweets').append(view.render().el)
    # i dont get why this isn't rendering within this element but does in the id within homepage. ask DA
    
    
    
  #redundant function, dont delete. OC  
  outputAuth: (auth) ->    
    console.log("1")
    console.log(auth)
    test = auth._id
    
  #redundant function, dont delete. OC  
  searchTwitter: =>
    console.log("search twitter")
    #event.preventDefault() 
    #$("#tweets li").fadeOut()
    auths = new RippleApp.Collections.Authentications()
    auths.fetch(success: (collection) =>
      console.log(auths)
      face = auths.first()
      console.log(face)
      token = face.get('token')
      console.log(token)
      test = this.model.get('first_name')
      console.log(test)
      handle = 'chestermano'
      console.log(this.model.get('_id'))
      url = "http://twitter.com/status/user_timeline/" + test + ".json?count=5&callback=?"
      $.getJSON url, (data) -> 
        #$("#tweets li").fadeOut()
        $.each data, (i, post) ->
          txt = post.text
          #console.log(post.text)
          #console.log(post.user.name)
          console.log(post)
          tweet = new RippleApp.Models.Tweet(post)
          view = new RippleApp.Views.Tweet(model: tweet)
          $('#tweets').append(view.render().el)
          #@outTweet(tweet)
          #console.log(tweet)
    )  


