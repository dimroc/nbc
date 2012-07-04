describe "region", ->
  nyc = null

  describe "Factories", ->
    beforeEach ->
      nyc = Factories.region({name: "Region Name"})

    it "should create a valid region", ->
      expect(nyc.name).toEqual("Region Name")
      expect(nyc.slug).toEqual("region-name")
      expect(nyc.validate()).toBeUndefined()

  describe "Fixtures", ->
    describe "new york city", ->
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
