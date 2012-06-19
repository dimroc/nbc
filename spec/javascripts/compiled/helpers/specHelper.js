(function() {
  var _base, _ref, _ref1;

  if ((_ref = jasmine.Fixtures) == null) {
    jasmine.Fixtures = {};
  }

  if ((_ref1 = (_base = jasmine.Fixtures).Regions) == null) {
    _base.Regions = {};
  }

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
      responseText: jasmine.Fixtures.Regions.nyc
    });
  };

  window.loadHtmlFixture = function(fixture) {
    return $("#jasmine_content").html(fixture);
  };

}).call(this);
