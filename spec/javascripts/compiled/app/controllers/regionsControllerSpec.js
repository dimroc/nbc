(function() {

  describe("regionsController", function() {
    var nyc, regionsController;
    regionsController = null;
    nyc = null;
    beforeEach(function() {
      initializeSpine();
      regionsController = App.instance.regionsController;
      return nyc = App.Region.findByAttribute("slug", "new-york-city");
    });
    it("should have the correct actions", function() {
      expect(regionsController.show).toBeAnAction();
      expect(regionsController.index).toBeAnAction();
      expect(regionsController["new"]).toBeAnAction();
      return expect(regionsController.edit).toBeAnAction();
    });
    return describe("with the action", function() {
      describe("show", function() {
        var world;
        world = null;
        beforeEach(function() {
          return world = Graphics.createWorld();
        });
        afterEach(function() {
          return world.destroy();
        });
        return it("should render the region", function() {
          var showAction;
          spyOn(world, "add").andCallThrough();
          spyOn(world, "attachToDom").andCallThrough();
          spyOn(world, "animate").andCallThrough();
          spyOn(Graphics, "createWorld").andReturn(world);
          showAction = regionsController.show.active({
            id: nyc.slug
          });
          mostRecentAjaxRequest().response(Factories.nycBlocksResponse());
          expect(world.add.callCount).toBe(nyc.blocks().all().length);
          expect(world.attachToDom).toHaveBeenCalled();
          expect(world.animate).toHaveBeenCalled();
          return expect(showAction.$("h1").text()).toContain(nyc.name);
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
          return expect(editAction.$("input[name=name]").val()).toContain("New York City");
        });
      });
      return describe("index", function() {
        return it("should render a list of regions", function() {
          var indexAction;
          indexAction = regionsController.index.active();
          return expect(indexAction.el.text()).toContain("New York City");
        });
      });
    });
  });

}).call(this);
