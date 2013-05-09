$ = jQuery
Neighborhood = App.Neighborhood
MeshFactory = App.MeshFactory

class App.Controller.Neighborhoods extends Spine.Controller
  constructor: ->
    super
    Neighborhood.bind 'refresh change', @addToWorldRenderer

  addToWorldRenderer: =>
    console.log("Adding neighborhoods")

    #meshes = for neighborhood in Neighborhood.all()
      #neighborhood.mesh

    # TODO: This controller should own a layer object
    # and the worldRenderer should have no knowledge of 'neighborhoods'
    # Behind the scenes it will drop and readd THREEJS.scenes.
    # eg: @worldRenderer.reloadLayer(neighborhoodScene);
    #@worldRenderer.reloadNeighborhoods(meshes)
