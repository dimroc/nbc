$ = jQuery
Neighborhood = App.Neighborhood
MeshFactory = App.MeshFactory

class App.Controller.Neighborhoods extends Spine.Controller
  constructor: (worldRenderer) ->
    super
    @worldRenderer = worldRenderer
    @addToWorldRenderer()

  addToWorldRenderer: =>
    @worldRenderer.loadNeighborhoods()
