(function() {
  var Regions;

  $.extend(Fixtures.Regions, {
    nyc: {
      "created_at": "2012-06-08T01:55:58Z",
      "id": 1,
      "name": "New York City",
      "updated_at": "2012-06-08T01:55:58Z"
    }
  });

  Regions = Fixtures.Regions;

  $.extend(Fixtures.Regions, {
    all: [Regions.nyc]
  });

}).call(this);
