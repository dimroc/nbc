describe "world", ->
  describe "Validations", ->
    it "should validate the presence of attributes", ->
      expect(App.World).toValidatePresenceOf("name")
      expect(App.World).toValidatePresenceOf("slug")

  describe ".findOrFetch", ->
    describe "when not already fetched", ->
      it "should fetch via AJAX", ->
        retrieved_world = null
        App.World.findOrFetch("new-york-city", (world)-> retrieved_world = world)

        expect(mostRecentAjaxRequest()).not.toBe(null)

        mostRecentAjaxRequest().response(Factories.worldsResponse())
        expect(retrieved_world.name).toEqual("New York City")

    describe "when already fetched", ->
      beforeEach ->
        App.World.refresh(Fixtures.worlds)
        expect(_.isEmpty(ajaxRequests)).toBe(true)

      it "should not retrieve via AJAX", ->
        retrieved_world = null
        App.World.findOrFetch("new-york-city", (world)-> retrieved_world = world)
        expect(mostRecentAjaxRequest()).toBe(null)
        expect(retrieved_world.name).toEqual("New York City")

  describe "#fetchRegions", ->
    nyc = null
    beforeEach ->
      nyc = new App.World(Fixtures.worlds[0])

    it "should retrieve only the region's regions", ->
      callback = jasmine.createSpy()
      nyc.fetchRegions(callback)

      mostRecentAjaxRequest().response(Factories.nycRegionsResponse())
      expect(callback).toHaveBeenCalledWith(nyc)

      world_regions = nyc.regions().select (region) -> region.world_id == nyc.id
      expect(world_regions.length).toEqual(Fixtures.nyc.length)
      expect(world_regions.length).toEqual(nyc.regions().all().length)

    describe "on failure", ->
      it "should log the error", ->
        spyOn(console, "warn").andCallThrough()
        nyc.fetchRegions()
        mostRecentAjaxRequest().response(Factories.errorResponse())
        expect(console.warn).toHaveBeenCalled()
