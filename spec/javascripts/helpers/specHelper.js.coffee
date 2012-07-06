# Instantiate test namespaces

jasmine.Fixtures ?= {}
jasmine.Factories ?= {}

window.Fixtures = jasmine.Fixtures
window.Factories = jasmine.Factories

beforeEach ->
  jasmine.Clock.useMock()
  jasmine.Ajax.useMock()

afterEach ->
  teardownSpine()
  $("#jasmine_content").html('')

teardownSpine = ->
  App.Region.destroyAll()
  App.Block.destroyAll()
  delete App.instance

window.initializeSpine = ->
  new App { el: $('#jasmine_content') }
  request = mostRecentAjaxRequest()
  request.response({
    status: 200,
    responseText: JSON.stringify Fixtures.regions
  })

window.loadHtmlFixture = (fixture) ->
  $("#jasmine_content").html(fixture)
