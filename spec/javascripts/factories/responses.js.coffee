Factories.nycBlocksResponse = ->
  successResponse =
    status: 200,
    responseText: JSON.stringify Fixtures.nyc_blocks
