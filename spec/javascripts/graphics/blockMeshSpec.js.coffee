describe "BlockMesh", ->
  it "should respond to animate", ->
    block = Fixtures.nyc_blocks[0]
    expect(Graphics.createBlockMesh(block)).toRespondTo("animate")
