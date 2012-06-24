(function() {
  var _ref;

  if ((_ref = jasmine.Fixtures) == null) {
    jasmine.Fixtures = {};
  }

  window.Fixtures = jasmine.Fixtures;

  beforeEach(function() {
    jasmine.Clock.useMock();
    return jasmine.Ajax.useMock();
  });

  afterEach(function() {
    return $("#jasmine_content").html('');
  });

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
