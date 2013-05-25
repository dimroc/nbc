class App.NeighborhoodObserver extends Spine.Module
  @extend Spine.Events

  constructor: ->
    App.Neighborhood.bind('selected', @handleSelection)

  handleSelection: (selectedNeighborhood) =>
    App.BuildingMesh.show(selectedNeighborhood)

singleton = new App.NeighborhoodObserver()
