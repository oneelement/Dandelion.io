class RippleApp.Views.HomePage extends Backbone.View
  template: JST['contact_manager/home_page']
  
  initialize: ->
    @model.on('change', @render, this)
    @model.on('reset', @render, this)
    #@collection.on('change', @render, this)
    #@collection.on('reset', @render, this)
    
  #events:
    #"submit": "searchTwitter"
  
  render: ->
    this.model.authentications = new RippleApp.Collections.Authentications(this.model.get('authentications'))
    $(@el).html(@template(user: @model))
    #@collection.each(@appendTweet)
    @searchTwitter()
    this
    
  appendTweet: (tweet) ->
    view = new RippleApp.Views.Tweet(model: tweet)
    $('#tweets').append(view.render().el)
    
  outputAuth: (auth) ->    
    console.log("1")
    console.log(auth)
    test = auth._id

    
  searchTwitter: =>
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
      #url = "http://search.twitter.com/search.json?" + "q=aston"
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



