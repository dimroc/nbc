class App.PreloadingService extends Spine.Module
  @extend Spine.Events

  @preload: ->
    worldDfd = $.Deferred()
    blockDfd = $.Deferred()
    nmeshDfd = $.Deferred()
    neighborhoodDfd = $.Deferred()

    App.World.bind 'refresh', -> worldDfd.resolve()
    App.Block.bind 'refresh', -> blockDfd.resolve()
    App.NeighborhoodMesh.bind 'refresh', -> nmeshDfd.resolve()
    App.Neighborhood.bind 'refresh', -> neighborhoodDfd.resolve()

    App.World.fetchFromStatic()
    App.Block.fetch()
    App.NeighborhoodMesh.fetchBatch()
    App.Neighborhood.fetchFromStatic()

    $.when(worldDfd, blockDfd, nmeshDfd, neighborhoodDfd)
