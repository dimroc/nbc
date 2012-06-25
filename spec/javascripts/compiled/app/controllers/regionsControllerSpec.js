(function() {

  describe("regionsController", function() {
    var nyc, regionsController;
    regionsController = null;
    nyc = null;
    beforeEach(function() {
      initializeSpine();
      regionsController = new App.RegionsController();
      return nyc = Fixtures.nyc;
    });
    return describe("with spine initialized", function() {
      return describe("show", function() {
        return it("should render the region", function() {
          var $output, output;
          output = regionsController.show.change(nyc.slug);
          $output = $(output);
          return expect($output.find("p").text()).toContain(nyc.name);
        });
      });
    });
  });

}).call(this);
