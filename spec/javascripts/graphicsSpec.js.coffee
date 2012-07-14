describe "Graphics", ->
  describe "#constructor", ->
    it "should create the camera, scene, and renderer", ->
      graphic = new Graphics()
      expect(graphic.scene).toBeDefined()
      expect(graphic.renderer).toBeDefined()
      expect(graphic.camera).toBeDefined()
      graphic.destroy()

  describe "when constructed", ->
    graphic = null
    beforeEach ->
      graphic = new Graphics()

    afterEach ->
      graphic.destroy()

    describe "#attachToDom", ->
      it "should append a canvas element", ->
        dom = $("<div></div>")
        graphic.attachToDom(dom)
        expect(dom).toContain("canvas")

    describe "#addCube", ->
      # TODO: The cube creation should be pulled out into a higher level
      # object/mesh factory and this should become a more generic add.

    describe "#animate", ->
      # TODO: Should invoke the the animate method of animation that's a child of this
      # world. See below.

    describe "#render", ->
      # TODO: The animation logic should be refactored into each individual object
      # ie: the Object3D (wrapper around mesh) should have animation logic.
        # spy on THREE and tquery
