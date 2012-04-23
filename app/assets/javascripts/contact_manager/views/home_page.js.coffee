class RippleApp.Views.HomePage extends Backbone.View
  template: JST['contact_manager/home_page']
  
  initialize: ->
    @model.on('change', @render, this)
  
  render: ->
    $(@el).html(@template(contact: @model.toJSON()))
    @getTweets()    
    this
    
  getTwitter: =>
    console.log(@model)
    test = @model.get('first_name')
    console.log(test)
    @tweets = new RippleApp.Collections.Tweets([], { query : test })
    #@collection.each(@appendTweet)
    @tweets.fetch(success: (collection) =>
      @getTweets()
    )
    
  getFacebook: =>
    console.log("TBC")
    
    
  #appendTweet: (tweet) ->
    #view = new RippleApp.Views.Tweet(model: tweet)
    #$('#tweets').append(view.render().el)
    
  getTweets: ->
    view = new RippleApp.Views.Twitter(collection: @tweets)
    $('#twitter-wrapper').append(view.render().el)
    



