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
      it "should render the region", ->
        graphicsSpy = jasmine.createSpyObj("graphics", ["addCube", "attachToDom", "animate"])
        regionsController.show.graphics = graphicsSpy # stub out graphics

        showAction = regionsController.show.active(id: nyc.slug)

        mostRecentAjaxRequest().response(Factories.nycBlocksResponse())

        expect(graphicsSpy.addCube.callCount).toBe(nyc.blocks().all().length)
        expect(graphicsSpy.attachToDom).toHaveBeenCalled()
        expect(graphicsSpy.animate).toHaveBeenCalled()
        expect(showAction.$("p").text()).toContain(nyc.name)

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
