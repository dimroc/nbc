(function() {

  describe("region", function() {
    var nyc;
    nyc = null;
    describe("Factories", function() {
      beforeEach(function() {
        return nyc = Factories.region({
          name: "Region Name"
        });
      });
      return it("should create a valid region", function() {
        expect(nyc.name).toEqual("Region Name");
        return expect(nyc.slug).toEqual("region-name");
      });
    });
    return describe("of new york city", function() {
      beforeEach(function() {
        return nyc = Fixtures.nyc;
      });
      return it("should have the proper name field", function() {
        return expect(nyc.name).toBe("New York City");
      });
    });
  });

}).call(this);
