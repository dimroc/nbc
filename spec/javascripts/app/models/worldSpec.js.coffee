describe "models.world", ->
  describe "Validations", ->
    it "should validate the presence of attributes", ->
      expect(App.World).toValidatePresenceOf("name")
      expect(App.World).toValidatePresenceOf("slug")

  describe ".findOrFetch", ->
    describe "when not already fetched", ->
      it "should fetch via AJAX", ->
        retrieved_world = null
        App.World.findOrFetch("nyc", (world)-> retrieved_world = world)

        expect(mostRecentAjaxRequest()).not.toBe(null)

        mostRecentAjaxRequest().response(Factories.worldsResponse())
        expect(retrieved_world.name).toEqual("NYC")

    describe "when already fetched", ->
      beforeEach ->
        App.World.refresh(Fixtures.worlds)
        expect(_.isEmpty(ajaxRequests)).toBe(true)

      it "should not retrieve via AJAX", ->
        retrieved_world = null
        App.World.findOrFetch("nyc", (world)-> retrieved_world = world)
        expect(mostRecentAjaxRequest()).toBe(null)
        expect(retrieved_world.name).toEqual("NYC")

  describe "#icon_path", ->
    it "should return the correct icon path", ->
      block = new App.World(name: "Staten Island", slug: "staten island")
      expect(block.icon_path()).toBe("/assets/icons/staten_island.png")

  describe "#currentRegion", ->
    nyc = null
    beforeEach ->
      nyc = new App.World(Fixtures.worlds[0])
      nyc.fetchRegions()
      mostRecentAjaxRequest().response(Factories.nycRegionsResponse())

    it "should retrieve the region with the current block", ->
      # Hardcoded against data in nyc regions fixture
      current_region = _(App.Region.all()).detect((region) -> region.current_block)
      expect(current_region).not.toBeNull()
      expect(nyc.currentRegion()).toEqual(current_region)

  describe "#fetchRegions", ->
    nyc = null
    beforeEach ->
      nyc = new App.World(Fixtures.worlds[0])

    it "should retrieve only the region's regions", ->
      callback = jasmine.createSpy()
      nyc.fetchRegions(callback)

      mostRecentAjaxRequest().response(Factories.nycRegionsResponse())
      expect(callback).toHaveBeenCalledWith(nyc)

      expect(nyc.regions().all().length).toEqual(Fixtures.nyc.length)

      world_region = _(nyc.regions().all()).detect((region) -> region.world_id == nyc.id)
      expect(world_region).not.toBeNull()

    describe "on failure", ->
      it "should log the error", ->
        spyOn(console, "warn").andCallThrough()
        nyc.fetchRegions()
        mostRecentAjaxRequest().response(Factories.errorResponse())
        expect(console.warn).toHaveBeenCalled()

  describe "#allBlocks", ->
    nyc = null
    beforeEach ->
      nyc = new App.World(Fixtures.worlds[0])

    it "should return the blocks from all regions", ->
      nyc.fetchRegions()
      mostRecentAjaxRequest().response(Factories.nycRegionsResponse())

      sum = _.reduce(nyc.regions().all(), (memo, region) ->
        memo += region.blocks().all().length
      , 0)

      expect(nyc.allBlocks().length).toEqual(sum)
