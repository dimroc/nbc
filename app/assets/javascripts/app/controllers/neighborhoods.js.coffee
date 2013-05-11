$ = jQuery
Neighborhood = App.Neighborhood
MeshFactory = App.MeshFactory

class App.Controller.Neighborhoods extends Spine.Controller
  constructor: (worldRenderer) ->
    super
    @worldRenderer = worldRenderer
    Neighborhood.bind 'refresh change', @addToWorldRenderer

  addToWorldRenderer: =>
    console.log("START: Adding neighborhoods")

    meshes = for neighborhood in Neighborhood.all()
      neighborhood.meshes()

    # TODO: This controller should own a layer object
    # and the worldRenderer should have no knowledge of 'neighborhoods'
    # Behind the scenes it will drop and readd THREEJS.scenes.
    # eg: @worldRenderer.reloadLayer(neighborhoodScene);
    @worldRenderer.reloadNeighborhoods(_(meshes).flatten())
    console.log("FINISH: Adding neighborhoods")
