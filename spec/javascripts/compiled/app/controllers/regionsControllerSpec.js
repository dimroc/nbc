(function() {

  describe("regionsController", function() {
    var nyc, regionsController;
    regionsController = null;
    nyc = null;
    beforeEach(function() {
      initializeSpine();
      regionsController = App.instance.regionsController;
      return nyc = Fixtures.nyc;
    });
    it("should have the correct actions", function() {
      expect(regionsController.show).toBeAnAction();
      expect(regionsController.index).toBeAnAction();
      expect(regionsController["new"]).toBeAnAction();
      return expect(regionsController.edit).toBeAnAction();
    });
    return describe("with the action", function() {
      describe("show", function() {
        return it("should render the region", function() {
          var showAction;
          showAction = regionsController.show.active({
            id: nyc.slug
          });
          return expect(showAction.$("p").text()).toIncludeText(nyc.name);
        });
      });
      describe("new", function() {
        return it("should render the region form", function() {
          var newAction;
          newAction = regionsController["new"].active();
          return expect(newAction.$("input[name=name]")).toExist();
        });
      });
      describe("edit", function() {
        return it("should render the region form", function() {
          var editAction;
          editAction = regionsController.edit.active({
            id: nyc.slug
          });
          return expect(editAction.$("input[name=name]").val()).toIncludeText("New York City");
        });
      });
      return describe("index", function() {
        return it("should render a list of regions", function() {
          var indexAction;
          indexAction = regionsController.index.active();
          return expect(indexAction.el.text()).toIncludeText("New York City");
        });
      });
    });
  });

}).call(this);
