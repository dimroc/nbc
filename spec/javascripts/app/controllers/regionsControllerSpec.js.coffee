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
      worldRenderer = null
      beforeEach ->
        worldRenderer = new App.WorldRenderer()

      afterEach ->
        worldRenderer.destroy()

      it "should render the region", ->
        spyOn(worldRenderer, "add").andCallThrough()
        spyOn(worldRenderer, "attachToDom").andCallThrough()
        spyOn(worldRenderer, "animate").andCallThrough()
        spyOn(App, "WorldRenderer").andReturn(worldRenderer)

        showAction = regionsController.show.active(id: nyc.slug)

        mostRecentAjaxRequest().response(Factories.nycBlocksResponse())

        expect(worldRenderer.add.callCount).toBe(nyc.blocks().all().length)
        expect(worldRenderer.attachToDom).toHaveBeenCalled()
        expect(worldRenderer.animate).toHaveBeenCalled()
        expect(showAction.$("h1").text()).toContain(nyc.name)

    describe "new", ->
      it "should render the region form", ->
        newAction = regionsController.new.active()
        expect(newAction.$("input[name=name]").length).toBe(1)

    describe "edit", ->
      it "should render the region form", ->
        editAction = regionsController.edit.active(id: nyc.slug)
        expect(editAction.$("input[name=name]").val()).toContain("New York City")

    describe "index", ->
      it "should render a list of regions", ->
        indexAction = regionsController.index.active()
        expect(indexAction.el.text()).toContain("New York City")
