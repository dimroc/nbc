describe "controllers.root", ->
  rootController = null

  beforeEach ->
    initializeSpine()
    rootController = App.instance.rootController

  it "should have the correct routes", ->
    expect(rootController.splash).toBeAnAction()
    expect(rootController.worldsIndex).toBeAnAction()
    expect(rootController.worldsShow).toBeAnAction()
