class App.CameraControlsObserver extends Spine.Module
  @extend Spine.Events

  constructor: ->
    App.CameraControls.bind('selectPoint', @selectBlockFromPoint)
    App.CameraControls.bind('selectPoint', @selectNeighborhoodFromPoint)

  selectBlockFromPoint: (pointOnSurface)=>
    selectedBlock = _(App.Block.all()).detect((block) ->
      world = App.World.current()
      block.contains(pointOnSurface, world)
    )

    selectedBlock.trigger('selected') if selectedBlock?

  selectNeighborhoodFromPoint: (pointOnSurface) =>
    lonlat = App.World.current().transformSurfaceToLonLat(pointOnSurface)

    $.ajax(
      url: "/api/neighborhoods",
      data: { longitude: lonlat.lon, latitude: lonlat.lat }
    ).done( (matchedNeighborhood) ->
      return unless matchedNeighborhood
      neighborhood = App.Neighborhood.find(matchedNeighborhood.id)
      neighborhood.trigger('selected') if neighborhood?
    )

singleton = new App.CameraControlsObserver()
