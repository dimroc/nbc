class App.NeighborhoodObserver extends Spine.Module
  @extend Spine.Events

  constructor: ->
    App.Neighborhood.bind('selected', @handleSelection)

  handleSelection: (selectedNeighborhood) ->
    console.log("selected #{selectedNeighborhood.id}:#{selectedNeighborhood.name}")
    App.Neighborhood.resetSelected(selectedNeighborhood)
    App.WorldRenderer.instance().reloadNeighborhoods()

singleton = new App.NeighborhoodObserver()
