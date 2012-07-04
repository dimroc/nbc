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
        expect(nyc.slug).toEqual("region-name");
        return expect(nyc.validate()).toBeUndefined();
      });
    });
    describe("Fixtures", function() {
      return describe("new york city", function() {
        beforeEach(function() {
          return nyc = new App.Region(Fixtures.nyc);
        });
        return it("should have the proper name field", function() {
          expect(nyc.name).toBe("New York City");
          expect(nyc.validate()).toBeUndefined();
          return expect(nyc.save()).not.toBeFalsy();
        });
      });
    });
    return describe("Validations", function() {
      return it("should validate the presence of attributes", function() {
        expect(App.Region).toValidatePresenceOf("name");
        return expect(App.Region).toValidatePresenceOf("slug");
      });
    });
  });

}).call(this);
