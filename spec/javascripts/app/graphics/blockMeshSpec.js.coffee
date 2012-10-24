describe "graphics.BlockMesh", ->
  block = null
  beforeEach ->
    block = jasmine.createSpy("block")
    block.left = block.bottom = 0
    block.region = jasmine.createSpy("region").andReturn({left: 100, bottom: 100})

  it "should position the mesh relative to the region", ->
    blockMesh = new App.BlockMesh(block)

    expectation = 7000 # WIDTH+GUTTER_LENGTH+100
    expect(blockMesh.position.x).toEqual(expectation)
    expect(blockMesh.position.y).toEqual(expectation)
