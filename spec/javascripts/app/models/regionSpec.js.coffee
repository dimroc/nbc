describe "region", ->
  describe "Factories", ->
    factored_region = null
    beforeEach ->
      factored_region = Factories.region({name: "Region Name"})

    it "should create a valid region", ->
      expect(factored_region.name).toEqual("Region Name")
      expect(factored_region.slug).toEqual("region-name")
      expect(factored_region.validate()).toBeUndefined()

  describe "Fixtures", ->
    describe "new york city", ->
      nyc = null
      beforeEach ->
        nyc = new App.Region(Fixtures.nyc)

      it "should have the proper name field", ->
        expect(nyc.name).toBe("New York City")
        expect(nyc.validate()).toBeUndefined()
        expect(nyc.save()).not.toBeFalsy()

  describe "Validations", ->
    it "should validate the presence of attributes", ->
      expect(App.Region).toValidatePresenceOf("name")
      expect(App.Region).toValidatePresenceOf("slug")

  describe "#fetchBlocks", ->
    nyc = null
    beforeEach ->
      nyc = new App.Region(Fixtures.nyc)

    it "should retrieve only the region's blocks", ->
      callback = jasmine.createSpy()
      nyc.fetchBlocks(callback)

      mostRecentAjaxRequest().response(Factories.nycBlocksResponse())
      expect(callback).toHaveBeenCalledWith(nyc)

      regioned_blocks = nyc.blocks().select (block) -> block.region_id == nyc.id
      expect(regioned_blocks.length).toEqual(Fixtures.nyc_blocks.length)
      expect(regioned_blocks.length).toEqual(nyc.blocks().all().length)

    describe "on failure", ->
      it "should log the error", ->
        spyOn(Spine.Log, "log").andCallThrough()
        errorResponse =
          status: 400,
          responseText: "Error Schmerror"

        nyc.fetchBlocks()
        mostRecentAjaxRequest().response(errorResponse)
        expect(Spine.Log.log).toHaveBeenCalled()
