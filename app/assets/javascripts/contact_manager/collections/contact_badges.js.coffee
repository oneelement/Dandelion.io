class RippleApp.Collections.ContactBadges extends Backbone.Collection
  model: RippleApp.Models.ContactBadge
  
  initialize: (options = {})-> 
    @maxSize = options.maxSize ? 0
  
  getTop5: =>
    return _.last(@.models, 5)
    
  add: (model, options = {}) =>       
    if @maxSize > 0
      overlookedUser = _.first(@models)
      Backbone.Collection.prototype.add.call(@, model)
      if @length > @maxSize
        @.remove(overlookedUser)
    else
      Backbone.Collection.prototype.add.call(@, model)