beforeEach ->
  @addMatchers({
    toIncludeText: (expectedText) ->
      if Helpers.getTypeName(@actual) == "String"
        text = @actual
      else
        text = @actual.text()
      _.str.include(text, expectedText)

    toBeAnAction: () ->
      Helpers.getTypeName(@actual.isActive) == "Function"
      Helpers.getTypeName(@actual.render) == "Function"
      Helpers.getTypeName(@actual.activate) == "Function"
      Helpers.getTypeName(@actual.deactivate) == "Function"
  })
