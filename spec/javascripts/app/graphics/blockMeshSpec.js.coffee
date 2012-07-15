describe "BlockMesh", ->
  it "should respond to animate", ->
    block = Fixtures.nyc_blocks[0]
    expect(new App.BlockMesh(block)).toRespondTo("animate")
