class RippleApp.Collections.Hashtags extends Backbone.Collection
  model:RippleApp.Models.Hashtag
  url: '/hashtags'
  
  #Will create tag if doesnt exist
  addTagToContact: (name, contact_id)=>
    hashtagResult = new RippleApp.Models.Hashtag()
    if contact_id
      exists = false
      _.each(@models, (hashtag) =>
        if hashtag.get('text') is name
          exists = true
      )
      
      if not exists
        #we create it!
        @add(hashtag = new RippleApp.Models.Hashtag(text: name, contact_ids: [contact_id] ))
        hashtag.save()
        hashtagResult = hashtag
      else
        _.each(@models, (hashtag) =>
          if hashtag.get('text') is name
            contact_ids = hashtag.get('contact_ids')
            contact_ids.push(contact_id)
            hashtag.set('contact_ids', contact_ids)
            hashtag.save()
            hashtagResult = hashtag
        )
      hashtagResult
      
  getIdFromName: (name)=>
    id = ''
    _.each(@models, (hashtag) =>
      if hashtag.get('text') is name    
        id = hashtag.get('_id')
    )
    id
