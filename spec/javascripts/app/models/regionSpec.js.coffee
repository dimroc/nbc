describe "region", ->
  describe "Validations", ->
    it "should validate the presence of attributes", ->
      expect(App.Region).toValidatePresenceOf("name")
      expect(App.Region).toValidatePresenceOf("slug")

  describe ".findOrFetch", ->
    describe "when not already fetched", ->
      it "should fetch via AJAX", ->
        retrieved_region = null
        App.Region.findOrFetch("new-york-city", (region)-> retrieved_region = region)

        expect(mostRecentAjaxRequest()).not.toBe(null)

        mostRecentAjaxRequest().response(Factories.regionsResponse())
        expect(retrieved_region.name).toEqual("New York City")

    describe "when already fetched", ->
      beforeEach ->
        App.Region.refresh(Fixtures.regions)
        expect(_.isEmpty(ajaxRequests)).toBe(true)

      it "should not retrieve via AJAX", ->
        retrieved_region = null
        App.Region.findOrFetch("new-york-city", (region)-> retrieved_region = region)
        expect(mostRecentAjaxRequest()).toBe(null)
        expect(retrieved_region.name).toEqual("New York City")

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
        spyOn(console, "warn").andCallThrough()
        errorResponse =
          status: 400,
          responseText: "Error Schmerror"

        nyc.fetchBlocks()
        mostRecentAjaxRequest().response(errorResponse)
        expect(console.warn).toHaveBeenCalled()
