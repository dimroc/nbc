describe("region", function() {
  beforeEach(function() {
    initializeSpine();
  });

  describe("of new york city", function() {
    it("to have the proper name field", function() {
      expect(App.Region.first().name).toBe("New York City");
    });
  });
});
