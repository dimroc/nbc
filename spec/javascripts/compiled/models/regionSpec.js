(function() {

  describe("region", function() {
    beforeEach(function() {
      return initializeSpine();
    });
    return describe("of new york city", function() {
      return it("should have the proper name field", function() {
        return expect(App.Region.first().name).toBe("New York City");
      });
    });
  });

}).call(this);
