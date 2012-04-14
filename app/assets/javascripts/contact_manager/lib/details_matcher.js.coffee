class RippleApp.Lib.DetailsMatcher
  matchers:
    mobilePhone:
      expr: /^(\+44|0)7\d*$/
      rank: 1
    landline:
      expr: /^\d*$/
      rank: 2
    email:
      expr: /^.*@.*$/
      rank: 3
    address:
      expr: /^.*,.*$/
      rank: 4

  constructor: (@matchText) ->
    @match()

  match: ->
    matches = []
    text = @matchText
    _.each(@matchers, (matcher, key) ->
      if matcher.expr.test(text)
        matches.push(key)
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

