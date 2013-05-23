$ = jQuery
Neighborhood = App.Neighborhood
MeshFactory = App.MeshFactory

class App.Controller.Neighborhoods extends Spine.Controller
  constructor: (worldRenderer) ->
    super
    @worldRenderer = worldRenderer
    App.NeighborhoodMesh.bind 'loaded', @addToWorldRenderer

  addToWorldRenderer: =>
    @worldRenderer.loadNeighborhoods()
