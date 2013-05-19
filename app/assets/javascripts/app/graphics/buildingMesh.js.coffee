class App.BuildingMesh
  @show: (neighborhood) ->
    singleton.show(neighborhood)

  constructor: ->
    @_repo = new App.BuildingGroupRepo()

  show: (neighborhood) ->
    @_repo.load(neighborhood).done(@render)

  render: (mesh) =>
    App.WorldRenderer.instance().setBuildings([mesh])

singleton = new App.BuildingMesh()
