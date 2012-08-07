describe "graphics.BlockMesh", ->
  it "should respond to animate", ->
    block = Fixtures.nyc[0].blocks[0]
    expect(new App.BlockMesh(block)).toRespondTo("animate")
