describe "models.block", ->
  describe "Validations", ->
    it "should validate presence of attributes", ->
      expect(App.Block).toValidatePresenceOf("bottom")
      expect(App.Block).toValidatePresenceOf("left")
      expect(App.Block).toValidatePresenceOf("point")

  describe "with an instance", ->
    nyc = block = null
    beforeEach ->
      nyc = Factories.nycWorld()
      block = nyc.allBlocks().first()

    describe "#color_key", ->
      it "should return the region slug", ->
        expect(block.color_key()).toEqual(block.region().slug)

    describe "#world_position", ->
      describe "with region offset", ->
        beforeEach ->
          region = jasmine.createSpy("region")
          region.left = 7
          region.bottom = 9
          spyOn(block, 'region').andReturn(region)

        it "should return the correct world position", ->
          left = (block.left + 7) * (App.Block.WIDTH + App.Block.GUTTER_LENGTH)
          bottom = (block.left + 9) * (App.Block.HEIGHT + App.Block.GUTTER_LENGTH)
          expect(block.world_position()).toEqual(new THREE.Vector3(left,bottom,0))
