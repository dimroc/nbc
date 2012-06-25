# Instantiate test namespaces

jasmine.Fixtures ?= {}
window.Fixtures = jasmine.Fixtures

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
    responseText: JSON.stringify Fixtures.regions
  })

window.loadHtmlFixture = (fixture) ->
  $("#jasmine_content").html(fixture)
