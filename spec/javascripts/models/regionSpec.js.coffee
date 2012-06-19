describe "region", ->
  beforeEach ->
    initializeSpine()

  describe "of new york city", ->
    it "should have the proper name field", ->
      expect(App.Region.first().name).toBe("New York City")
