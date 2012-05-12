class RippleApp.Models.User extends Backbone.RelationalModel
  idAttribute: '_id'
  urlRoot: -> '/user'

  fetchCurrent: (args) ->
    _.defaults(args, data: {})
    _.defaults(args.data, {current: true})
    @fetch(args)