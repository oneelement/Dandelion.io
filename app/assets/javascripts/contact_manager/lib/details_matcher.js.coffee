class RippleApp.Lib.DetailsMatcher
  matchers:
    mobilePhone:
      exprs: [
        /^(\+44|0)7(\d|\s)*$/,
      ]
      rank: 1
    landline:
      exprs: [
        /^(\+|\d)(\d|\s)*$/,
      ]
      rank: 2
    email:
      exprs: [
        /^.+@.*$/,
      ]
      rank: 3
    address:
      exprs: [
        /^.+,.+$/,
      ]
      rank: 4
    notes:
      exprs: [
        /^.+$/,
      ]
      rank: 5

  constructor: (@matchText) ->
    @match()

  match: ->
    matches = []
    text = @matchText
    _.each(@matchers, (matcher, key) ->
      _.each(matcher.exprs, (expr) ->
        if expr.test(text) and not _.include(matches, key)
          matches.push(key)
      )
    )

    @matches = matches

  topMatch: ->
    if @matches.length > 0
      result = @matches[0]
      matchers = @matchers

      _.each(@matches, (key) ->
        if matchers[key].rank < matchers[result].rank
          result = key
      )

      return result
    else
      return null

