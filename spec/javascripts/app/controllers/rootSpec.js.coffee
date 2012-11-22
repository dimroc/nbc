describe "controllers.root", ->
  rootController = null
  nyc = null

  beforeEach ->
    initializeSpine()
    rootController = App.instance.rootController
    nyc = App.World.findByAttribute("slug", "nyc")

  it "should have the correct routes", ->
    expect(rootController.loading).toBeAnAction()
    expect(rootController.worldsIndex).toBeAnAction()
    expect(rootController.worldsShow).toBeAnAction()
