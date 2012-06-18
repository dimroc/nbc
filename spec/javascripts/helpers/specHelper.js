(function() {
  beforeEach(function() {
    jasmine.Clock.useMock();
    jasmine.Ajax.useMock();
  });

  afterEach(function() {
    $("#jasmine_content").html('');
  });

  initializeSpine = function () {
    var app = new App({ el: $('#jasmine_content') });
    request = mostRecentAjaxRequest();
    request.response({
      status: 200,
      responseText: jasmine.Fixtures.Regions.nyc
    });
  };

  loadHtmlFixture = function(fixture) {
    $("#jasmine_content").html(fixture);
  };
})();
