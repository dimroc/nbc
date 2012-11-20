describe "controllers.rootController", ->
  rootController = null
  nyc = null

  beforeEach ->
    initializeSpine()
    rootController = App.instance.rootController
    nyc = App.World.findByAttribute("slug", "nyc")

  it "should have the correct actions", ->
    expect(rootController.show).toBeAnAction()
    expect(rootController.index).toBeAnAction()

  describe "with the action", ->
    describe "show", ->
      worldRenderer = null
      beforeEach ->
        worldRenderer = new App.WorldRenderer()

      afterEach ->
        worldRenderer.destroy()

      it "should render the world", ->
        spyOn(worldRenderer, "add_blocks").andCallThrough()
        spyOn(worldRenderer, "attachToDom").andCallThrough()
        spyOn(worldRenderer, "animate").andCallThrough()
        spyOn(App, "WorldRenderer").andReturn(worldRenderer)

        showAction = rootController.show.active(id: nyc.slug)

        mostRecentAjaxRequest().response(Factories.nycRegionsResponse())

        expect(worldRenderer.add_blocks).toHaveBeenCalled()
        expect(worldRenderer.attachToDom).toHaveBeenCalled()
        expect(worldRenderer.animate).toHaveBeenCalled()

    describe "index", ->
      it "should render a list of worlds", ->
        indexAction = rootController.index.active()
        expect(indexAction.el.text()).toContain("NYC")
