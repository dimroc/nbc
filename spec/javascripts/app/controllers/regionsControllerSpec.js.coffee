describe "regionsController", ->
  regionsController = null
  nyc = null

  beforeEach ->
    initializeSpine()
    regionsController = App.instance.regionsController
    nyc = App.Region.findByAttribute("slug", "new-york-city")

  it "should have the correct actions", ->
    expect(regionsController.show).toBeAnAction()
    expect(regionsController.index).toBeAnAction()
    expect(regionsController.new).toBeAnAction()
    expect(regionsController.edit).toBeAnAction()

  describe "with the action", ->
    describe "show", ->
      world = null
      beforeEach ->
        world = new App.World()

      afterEach ->
        world.destroy()

      it "should render the region", ->
        spyOn(world, "add").andCallThrough()
        spyOn(world, "attachToDom").andCallThrough()
        spyOn(world, "animate").andCallThrough()
        spyOn(App, "World").andReturn(world)

        showAction = regionsController.show.active(id: nyc.slug)

        mostRecentAjaxRequest().response(Factories.nycBlocksResponse())

        expect(world.add.callCount).toBe(nyc.blocks().all().length)
        expect(world.attachToDom).toHaveBeenCalled()
        expect(world.animate).toHaveBeenCalled()
        expect(showAction.$("h1").text()).toContain(nyc.name)

    describe "new", ->
      it "should render the region form", ->
        newAction = regionsController.new.active()
        expect(newAction.$("input[name=name]")).toExist()

    describe "edit", ->
      it "should render the region form", ->
        editAction = regionsController.edit.active(id: nyc.slug)
        expect(editAction.$("input[name=name]").val()).toContain("New York City")

    describe "index", ->
      it "should render a list of regions", ->
        indexAction = regionsController.index.active()
        expect(indexAction.el.text()).toContain("New York City")
