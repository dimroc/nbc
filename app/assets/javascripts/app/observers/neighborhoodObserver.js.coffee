class App.NeighborhoodObserver extends Spine.Module
  @extend Spine.Events

  constructor: ->
    App.Neighborhood.bind('selected', @handleSelection)

  handleSelection: (selectedNeighborhood) ->
    console.log("selected #{selectedNeighborhood.id}:#{selectedNeighborhood.name}")
    App.NeighborhoodMesh.select(selectedNeighborhood.id)

singleton = new App.NeighborhoodObserver()
