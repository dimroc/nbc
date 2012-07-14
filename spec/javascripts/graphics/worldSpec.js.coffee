describe "World", ->
  describe "#constructor", ->
    it "should create the camera, scene, and renderer", ->
      world = new Graphics.World()
      expect(world.scene).toBeDefined()
      expect(world.renderer).toBeDefined()
      expect(world.camera).toBeDefined()
      world.destroy()

  describe "when constructed", ->
    world = null
    beforeEach ->
      world = new Graphics.World()

    afterEach ->
      world.destroy()

    describe "#attachToDom", ->
      it "should append a canvas element", ->
        dom = $("<div></div>")
        world.attachToDom(dom)
        expect(dom).toContain("canvas")

    describe "#add", ->
      it "should add to its children", ->
        mesh = new THREE.Mesh()
        world.add(mesh)
        expect(world.scene.children).toInclude(mesh)

    describe "#animate", ->
      it "should animate its children", ->
        blockMesh = Graphics.createBlockMesh(Fixtures.nyc_blocks[0])
        spyOn(blockMesh, "animate").andCallThrough()
        world.add(blockMesh)
        world.animate()
        expect(blockMesh.animate).toHaveBeenCalled()
