class RippleApp.Models.User extends Backbone.RelationalModel
  relations: [
    {
      type: 'Backbone.HasMany'
      key: 'authentications'
      relatedModel: 'RippleApp.Models.UserAuthenticationDetail'
      includeInJSON: true
      createModels: true
    }
  ]
  idAttribute: '_id'
  urlRoot: -> '/user/'

  fetchCurrent: (args) ->
    _.defaults(args, data: {})
    _.defaults(args.data, {current: true})
    @fetch(args)