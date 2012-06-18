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
      responseText: '[{"created_at":"2012-06-08T01:55:58Z","id":1,"name":"New York City","updated_at":"2012-06-08T01:55:58Z"}]'
    });
  };

  loadFixture = function(fixture) {
    $("#jasmine_content").html(fixture);
  };
})();
