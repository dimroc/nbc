describe("region", function() {
  beforeEach(function() {
    initializeSpine();
  });

  describe("name", function() {
    it("have a name field", function() {
      expect(App.Region.first().name).toBe("New York City");
    });
  });
});
