class RippleApp.Views.FacebookComments extends Backbone.View
  template: JST['contact_manager/facebook_comments']
  id: 'comments-wrapper'
  
  events:
    'keypress #comment-input': 'checkEnter'
    'click .view-comments': 'viewExtraComments'
    
  initialize: ->
    @collection.on('reset', @render, this)
    @collection.on('add', @render, this)
    @collection.on('destroy', @render, this)

  render: ->    
    $(@el).html(@template(entry: @model.toJSON()))
    
    
    length = @collection.length

    
    if @model.get('comment_count')
      size = @model.get('comment_count')
      diff = size - length
      if diff > 0
        @outputExtraComments(size)
    
    @collection.each(@appendComment)
    
    return this  
    
  outputExtraComments: (size) ->
    html = "<li class='comment-item'><span class='dicon-comment'></span><a class='view-comments'>View all " + size + " comments</a></li>"
    this.$('.extra-comments').prepend(html)
    
  viewExtraComments: ->
    this.$('.extra-comments').css('display', 'none')
    @getObject()
    
   
  appendComment: (model) =>
    view = new RippleApp.Views.FacebookComment(model: model)
    this.$('.all-comments').append(view.render().el)
    
  checkEnter: (event) ->
    if (event.keyCode == 13) 
      event.preventDefault()
      id = @model.get('id')
      text = this.$('#comment-input').val()
      #@getObject()
      $.get '/facebook_feeds/comment?id=' + id + '&text=' + text, (data) =>
        #console.log(data)
        @getObject()
        
  getObject: =>
    id = @model.get('id')
    call = "get_object/?id=" + id
    $.get '/facebook_feeds/get_object?id=' + id, (data) =>
      #console.log(data)
      @collection = new RippleApp.Collections.FacebookComments(data.comment_parsed_data)
      @render()
    
  test: ->
      comments = @model.get('comment_parsed_data')
      #prob should move this into a view OC
      _.each(comments, (comment) =>
        output = "<li class='comment-item'>
                    <div class='comment-picture'>
                      <img src='http://graph.facebook.com/" + comment.user_id + "/picture?type=square'></img>
                    </div>
                    <div class='comment-item-content'>
                      <div class='comment-item-text'>
                        <a target='_blank' href='http://www.facebook.com/" + comment.user_id + "'>
                          <span class='item-name'>" + comment.user + "</span>
                        </a>
                        <span class='item-message'>" + comment.message + "</span>                        
                      </div>
                      <div class='comment-item-time'>
                        <span>" + comment.time + "</span>
                      </div>
                    </div>
                  </li>"
        this.$('.comments-list').prepend(output)
      )
  


