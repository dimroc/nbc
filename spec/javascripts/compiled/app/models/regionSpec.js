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
    describe(".findOrFetch", function() {
      describe("when not already fetched", function() {
        return it("should fetch via AJAX", function() {
          var retrieved_region;
          retrieved_region = null;
          App.Region.findOrFetch("new-york-city", function(region) {
            return retrieved_region = region;
          });
          expect(mostRecentAjaxRequest()).not.toBe(null);
          mostRecentAjaxRequest().response(Factories.regionsResponse());
          return expect(retrieved_region.name).toEqual("New York City");
        });
      });
      return describe("when already fetched", function() {
        beforeEach(function() {
          App.Region.refresh(Fixtures.regions);
          return expect(_.isEmpty(ajaxRequests)).toBe(true);
        });
        return it("should not retrieve via AJAX", function() {
          var retrieved_region;
          retrieved_region = null;
          App.Region.findOrFetch("new-york-city", function(region) {
            return retrieved_region = region;
          });
          expect(mostRecentAjaxRequest()).toBe(null);
          return expect(retrieved_region.name).toEqual("New York City");
        });
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
          spyOn(console, "warn").andCallThrough();
          errorResponse = {
            status: 400,
            responseText: "Error Schmerror"
          };
          nyc.fetchBlocks();
          mostRecentAjaxRequest().response(errorResponse);
          return expect(console.warn).toHaveBeenCalled();
        });
      });
    });
  });

}).call(this);
