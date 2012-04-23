class RippleApp.Lib.DetailsMatcher
  matchers:
    "Mobile":
      exprs: [
        /^(\+44|0)7(\d|\s)*$/,
      ]
    "Home Phone":
      exprs: [
        /^(\+|\d)(\d|\s)*$/,
      ]
    "D.O.B":
      exprs: [
        /^\d{1,2}\/\d{1,2}\/\d{2}$/,
        /^\d{1,2}\/\d{1,2}\/\d{4}$/,
      ]
    "Email":
      exprs: [
        /^.+@.*$/,
      ]
    "Address":
      exprs: [
        /^.+,.+$/,
      ]
    "Note":
      exprs: [
        /^.+$/,
      ]

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
      return @matches[0]
    else
      return null

