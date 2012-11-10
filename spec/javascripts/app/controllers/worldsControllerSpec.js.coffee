describe "controllers.worldsController", ->
  worldsController = null
  nyc = null

  beforeEach ->
    initializeSpine()
    worldsController = App.instance.worldsController
    nyc = App.World.findByAttribute("slug", "nyc")

  it "should have the correct actions", ->
    expect(worldsController.show).toBeAnAction()
    expect(worldsController.index).toBeAnAction()
    expect(worldsController.new).toBeAnAction()
    expect(worldsController.edit).toBeAnAction()

  describe "with the action", ->
    describe "show", ->
      worldRenderer = null
      beforeEach ->
        worldRenderer = new App.WorldRenderer()

      afterEach ->
        worldRenderer.destroy()

      it "should render the world", ->
        spyOn(worldRenderer, "add").andCallThrough()
        spyOn(worldRenderer, "attachToDom").andCallThrough()
        spyOn(worldRenderer, "animate").andCallThrough()
        spyOn(App, "WorldRenderer").andReturn(worldRenderer)

        showAction = worldsController.show.active(id: nyc.slug)

        mostRecentAjaxRequest().response(Factories.nycRegionsResponse())

        expect(worldRenderer.add).toHaveBeenCalled()
        expect(worldRenderer.attachToDom).toHaveBeenCalled()
        expect(worldRenderer.animate).toHaveBeenCalled()

    describe "new", ->
      it "should render the world form", ->
        newAction = worldsController.new.active()
        expect(newAction.$("input[name=name]").length).toBe(1)

    describe "edit", ->
      it "should render the world form", ->
        editAction = worldsController.edit.active(id: nyc.slug)
        expect(editAction.$("input[name=name]").val()).toContain("NYC")

    describe "index", ->
      it "should render a list of worlds", ->
        indexAction = worldsController.index.active()
        expect(indexAction.el.text()).toContain("NYC")
