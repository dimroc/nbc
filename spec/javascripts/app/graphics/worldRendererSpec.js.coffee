describe "graphics.WorldRenderer", ->
  describe "#constructor", ->
    it "should create the camera, scene, and renderer", ->
      worldRenderer = new App.WorldRenderer()
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

    describe "#add_blocks", ->
      it "should add to its children", ->
        mesh = new THREE.Mesh()
        worldRenderer.add_blocks(mesh)
        expect(worldRenderer.meshes()).toInclude(mesh)

    describe "#add_outlines", ->
      it "should add to its children", ->
        mesh = new THREE.Mesh()
        worldRenderer.add_outlines(mesh)
        expect(worldRenderer.meshes()).toInclude(mesh)
