# Instantiate test namespaces

jasmine.Fixtures ?= {}
jasmine.Fixtures.Regions ?= {}

beforeEach ->
  jasmine.Clock.useMock();
  jasmine.Ajax.useMock();

afterEach ->
  $("#jasmine_content").html('');

window.initializeSpine = ->
  new App { el: $('#jasmine_content') }
  request = mostRecentAjaxRequest()
  request.response({
    status: 200,
    responseText: jasmine.Fixtures.Regions.nyc
  })

window.loadHtmlFixture = (fixture) ->
  $("#jasmine_content").html(fixture)
