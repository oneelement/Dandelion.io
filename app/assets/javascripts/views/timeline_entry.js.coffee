class RippleApp.Views.TimelineEntry extends Backbone.View
  templateTwitter: JST['contact_manager/timeline_entry_twitter']
  templateFacebook: JST['contact_manager/timeline_entry_facebook']
  tagName: 'li'
  className: 'timeline-entry'
  
  events:
    'click .like': 'likeObject' 
    'click .unlike': 'unlikeObject'
    'click .comment, .comment-count, .like-count': 'showComments'
    #'keypress #comment-input': 'checkEnter'
    
  initialize: ->
    @model.on('change', @render, this)
    @action_box_open = false

  render: ->    
    if @model.get('source') == 'twitter'
      $(@el).html(@templateTwitter(entry: @model.toJSON()))
      text = @model.get('parsed_text')
      this.$('.timeline-entry-content p').html(text)
      @checkRetweet()
    else if @model.get('source') == 'facebook'
      $(@el).html(@templateFacebook(entry: @model.toJSON()))
      text = @model.get('parsed_text')
      this.$('.timeline-entry-title').html(text)
      @checkForPicture()
    
    @checkSource()    
    @calcTime()    
    @checkLike()    
    @addLikes()
    @addComments()
    
    source = @model.get('source')
    $(this.el).addClass(source)
    
    #this is a hack to run after the DOM has loaded
    #setTimeout(@adjustSource, 0)
    
    return this
    
    
  showComments: ->
    if @action_box_open == false
      this.$('.action-box').css('display', 'block')
      @action_box_open = true
    else
      this.$('.action-box').css('display', 'none')
      @action_box_open = false
    
  addComments: ->
    comments = new RippleApp.Collections.FacebookComments(@model.get('comment_parsed_data'))      
    view = new RippleApp.Views.FacebookComments(
      collection: comments, model: @model
    )
    this.$('.comments-list').prepend(view.render().el)  

    
  addLikes: =>
    if @model.get('like_data')
      likes = @model.get('like_data')
      console.log(likes)
      length = _.size(likes)
      i = 1
      console.log(length)
      _.each(likes, (like) =>
        if i == length
          if length == 1
            text = like.name + ' likes this.'
          else
            text = like.name + ' like this.'
        else
          text = like.name + ', '
        this.$('.action-box-likes').append(text)
        i = i + 1
      )
    else
      this.$('.action-box-header').css('display', 'none')
    
  checkLike: ->
    if @model.get('like_ind') == true
      this.$('.like').html('Unlike')
      this.$('.like').addClass('unlike')
      this.$('.like').removeClass('like')
      
    
  likeObject: =>
    id = @model.get('id')
    call = "like/?id=" + id
    @face = new RippleApp.Collections.Faces([], { call : call })
    @face.fetch(success: (collection) =>
      @getObject()       
    )  
    
  unlikeObject: =>
    id = @model.get('id')
    call = "unlike/?id=" + id
    @face = new RippleApp.Collections.Faces([], { call : call })
    @face.fetch(success: (collection) =>
      @getObject()       
    ) 
      
  getObject: =>
    id = @model.get('id')
    call = "get_object/?id=" + id
    $.get '/facebook_feeds/get_object?id=' + id, (data) =>
      console.log(data)
      @model.set(data)


    
  checkForPicture: ->
    if @model.get('picture')
      html = "<a target='_blank' href='" + @model.get('link') + "'><div class='timeline-entry-picture'></div></a>"
      url = "url('" + @model.get('picture') + "')"
      this.$('.timeline-entry-media').html(html)
      this.$('.timeline-entry-picture').css('background-image', url)
    else
      this.$('.timeline-entry-media').hide()
    
  checkSource: ->
    if @model.get('source') == 'twitter'
      this.$('.social-source').addClass('dicon-twitter')
    else if @model.get('source') == 'facebook'
      this.$('.social-source').addClass('dicon-facebook')
      
  calcTime: ->
    time = @model.get('seconds_ago')
    minutes = time / 60
    hours = minutes / 60
    days = hours / 24
    years = days / 365
    if time < 60
      this.$('.timeline-entry-time').html('just now')
    else if minutes < 60
      output = Math.round(minutes) + 'm'
      this.$('.timeline-entry-time').html(output)
    else if hours < 24
      output = Math.round(hours) + 'h'
      this.$('.timeline-entry-time').html(output)
    else if days < 365
      output = @model.get('date')
      this.$('.timeline-entry-time').html(output)
    else
      output = @model.get('date_y')
      this.$('.timeline-entry-time').html(output)
      
  checkRetweet: ->
    if @model.get('retweet_ind') == true
      html = "<p><span class='dicon-loop'></span>Retweeted by 
              <a target='_blank' href='http://twitter.com/" + 
              @model.get('retweet_by_screen_name') + "'>" + 
              @model.get('retweet_by_name') + 
              "<a/></p>"
      this.$('.timeline-entry-content').append(html)
      

      
  #adjustSource: ->
    #height = this.$('.timeline-entry-wrapper').css('height')
    #this.$('.timeline-entry-source').css('line-height', height)


