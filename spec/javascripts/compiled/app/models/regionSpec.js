(function() {

  describe("region", function() {
    describe("Factories", function() {
      var factored_region;
      factored_region = null;
      beforeEach(function() {
        return factored_region = Factories.region({
          name: "Region Name"
        });
      });
      return it("should create a valid region", function() {
        expect(factored_region.name).toEqual("Region Name");
        expect(factored_region.slug).toEqual("region-name");
        return expect(factored_region.validate()).toBeUndefined();
      });
    });
    describe("Fixtures", function() {
      return describe("new york city", function() {
        var nyc;
        nyc = null;
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
    describe("Validations", function() {
      return it("should validate the presence of attributes", function() {
        expect(App.Region).toValidatePresenceOf("name");
        return expect(App.Region).toValidatePresenceOf("slug");
      });
    });
    return describe("#fetchBlocks", function() {
      var nyc;
      nyc = null;
      beforeEach(function() {
        return nyc = new App.Region(Fixtures.nyc);
      });
      it("should retrieve only the region's blocks", function() {
        var callback, regioned_blocks;
        callback = jasmine.createSpy();
        nyc.fetchBlocks(callback);
        mostRecentAjaxRequest().response(Factories.nycBlocksResponse());
        expect(callback).toHaveBeenCalledWith(nyc);
        regioned_blocks = nyc.blocks().select(function(block) {
          return block.region_id === nyc.id;
        });
        expect(regioned_blocks.length).toEqual(Fixtures.nyc_blocks.length);
        return expect(regioned_blocks.length).toEqual(nyc.blocks().all().length);
      });
      return describe("on failure", function() {
        return it("should log the error", function() {
          var errorResponse;
          spyOn(Spine.Log, "log").andCallThrough();
          errorResponse = {
            status: 400,
            responseText: "Error Schmerror"
          };
          nyc.fetchBlocks();
          mostRecentAjaxRequest().response(errorResponse);
          return expect(Spine.Log.log).toHaveBeenCalled();
        });
      });
    });
  });

}).call(this);
