(function() {

  Factories.nycBlocksResponse = function() {
    var successResponse;
    return successResponse = {
      status: 200,
      responseText: JSON.stringify(Fixtures.nyc_blocks)
    };
  };

}).call(this);
