(function() {
  var teardownSpine, _ref, _ref1;

  if ((_ref = jasmine.Fixtures) == null) {
    jasmine.Fixtures = {};
  }

  if ((_ref1 = jasmine.Factories) == null) {
    jasmine.Factories = {};
  }

  window.Fixtures = jasmine.Fixtures;

  window.Factories = jasmine.Factories;

  beforeEach(function() {
    jasmine.Clock.useMock();
    return jasmine.Ajax.useMock();
  });

  afterEach(function() {
    teardownSpine();
    return $("#jasmine_content").html('');
  });

  teardownSpine = function() {
    App.Region.destroyAll();
    App.Block.destroyAll();
    return delete App.instance;
  };

  window.initializeSpine = function() {
    var request;
    new App({
      el: $('#jasmine_content')
    });
    request = mostRecentAjaxRequest();
    return request.response({
      status: 200,
      responseText: JSON.stringify(Fixtures.regions)
    });
  };

  window.loadHtmlFixture = function(fixture) {
    return $("#jasmine_content").html(fixture);
  };

}).call(this);
