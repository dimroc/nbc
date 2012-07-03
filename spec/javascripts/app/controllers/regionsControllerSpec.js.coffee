describe "regionsController", ->
  regionsController = null
  nyc = null

  beforeEach ->
    initializeSpine()
    regionsController = App.instance.regionsController
    nyc = Fixtures.nyc

  it "should have the correct actions", ->
    expect(regionsController.show).toBeAnAction()
    expect(regionsController.index).toBeAnAction()
    expect(regionsController.new).toBeAnAction()
    expect(regionsController.edit).toBeAnAction()

  describe "with the action", ->
    describe "show", ->
      it "should render the region", ->
        showAction = regionsController.show.active(id: nyc.slug)
        expect(showAction.$("p").text()).toIncludeText(nyc.name)

    describe "new", ->
      it "should render the region form", ->
        newAction = regionsController.new.active()
        expect(newAction.$("input[name=name]")).toExist()

    describe "edit", ->
      it "should render the region form", ->
        editAction = regionsController.edit.active(id: nyc.slug)
        expect(editAction.$("input[name=name]").val()).toIncludeText("New York City")

    describe "index", ->
      it "should render a list of regions", ->
        indexAction = regionsController.index.active()
        expect(indexAction.el.text()).toIncludeText("New York City")
