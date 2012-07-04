describe "region", ->
  nyc = null

  describe "Factories", ->
    beforeEach ->
      nyc = Factories.region({name: "Region Name"})

    it "should create a valid region", ->
      expect(nyc.name).toEqual("Region Name")
      expect(nyc.slug).toEqual("region-name")

  describe "of new york city", ->
    beforeEach ->
      nyc = Fixtures.nyc

    it "should have the proper name field", ->
      expect(nyc.name).toBe("New York City")
