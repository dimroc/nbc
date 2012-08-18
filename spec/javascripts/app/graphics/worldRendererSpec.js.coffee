describe "graphics.WorldRenderer", ->
  describe "#constructor", ->
    it "should create the camera, scene, and renderer", ->
      worldRenderer = new App.WorldRenderer()
      expect(worldRenderer.scene).toBeDefined()
      expect(worldRenderer.renderer).toBeDefined()
      expect(worldRenderer.camera).toBeDefined()
      worldRenderer.destroy()

  describe "when constructed", ->
    worldRenderer = null
    beforeEach ->
      worldRenderer = new App.WorldRenderer()

    afterEach ->
      worldRenderer.destroy()

    describe "#attachToDom", ->
      it "should append a canvas element", ->
        dom = $("<div></div>")
        worldRenderer.attachToDom(dom)
        expect(dom).toContain("canvas")

    describe "#add", ->
      it "should add to its children", ->
        mesh = new THREE.Mesh()
        worldRenderer.add(mesh)
        expect(worldRenderer.scene.children).toInclude(mesh)

    describe "#animate", ->
      it "should animate its children", ->
        blockMesh = new App.BlockMesh(Fixtures.nyc[0].blocks[0])
        spyOn(blockMesh, "animate").andCallThrough()
        worldRenderer.add(blockMesh)
        worldRenderer.animate()
        expect(blockMesh.animate).toHaveBeenCalled()
