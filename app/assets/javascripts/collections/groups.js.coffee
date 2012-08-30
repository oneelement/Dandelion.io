class RippleApp.Collections.Groups extends Backbone.Collection
  model: RippleApp.Models.Group
  url: '/groups'
  
  #Will create tag if doesnt exist
  addGroupToSubject: (name, subject_id, model) =>
    groupResult = new RippleApp.Models.Group()
    
    name = name.substr(1)
    
    if subject_id
      exists = false
      _.each(@models, (group) =>
        if group.get('name') is name
          exists = true
      )
      
      #contacts = RippleApp.contactsRouter.contacts
      @subject = model
      #contact.fetch()
      
      modelType = @subject.getModelName()
      
      console.log(@subject)
      
      if not exists
        #we create it!
        if modelType == 'contact'
          group = new RippleApp.Models.Group(name: name, contact_ids: [subject_id])
        else if modelType == 'group'
          group = new RippleApp.Models.Group(name: name, group_ids: [subject_id])        
        group.save(null, success: (model, response) =>
          id = model.get('_id')
          @add(model)
          subject_group_ids = @subject.get('group_ids')
          subject_group_ids.push(id)
          #this seems to set the model as well, not sure why but errored when I tried to set manually
          @subject.save()
        )
      else
        _.each(@models, (group) =>
          if group.get('name') is name
            if modelType == 'contact'
              subject_ids = group.get('contact_ids')
              subject_ids.push(subject_id)
              group.set('contact_ids', subject_ids)
            else if modelType == 'group'
              subject_ids = group.get('group_ids')
              subject_ids.push(subject_id)
              group.set('group_ids', subject_ids)
            group.save()
            id = group.get('_id')
            subject_group_ids = @subject.get('group_ids')
            subject_group_ids.push(id)
            @subject.save()
        )

  getIdFromName: (name) =>
    id = ''
    _.each(@models, (group) =>
      if group.get('name') is name    
        id = group.get('_id')
    )
    id
    


