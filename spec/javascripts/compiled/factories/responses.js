(function() {

  Factories.nycBlocksResponse = function() {
    var successResponse;
    return successResponse = {
      status: 200,
      responseText: JSON.stringify(Fixtures.nyc_blocks)
    };
  };

  Factories.regionsResponse = function() {
    var successResponse;
    return successResponse = {
      status: 200,
      responseText: JSON.stringify(Fixtures.regions)
    };
  };

}).call(this);
