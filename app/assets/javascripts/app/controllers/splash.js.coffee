$ = jQuery
World = App.World
Block = App.Block
NeighborhoodMesh = App.NeighborhoodMesh
Neighborhood = App.Neighborhood

class App.Controller.Splash extends Spine.Controller
  className: 'splash'

  constructor: ->
    super

    worldDfd = $.Deferred()
    blockDfd = $.Deferred()
    nmeshDfd = $.Deferred()
    neighborhoodDfd = $.Deferred()

    World.bind 'refresh', -> worldDfd.resolve()
    Block.bind 'refresh', -> blockDfd.resolve()
    NeighborhoodMesh.bind 'refresh', -> nmeshDfd.resolve()
    Neighborhood.bind 'refresh', -> neighborhoodDfd.resolve()

    World.fetchFromStatic()
    Block.fetch()
    NeighborhoodMesh.fetchBatch()
    Neighborhood.fetchFromStatic()

    $.when(worldDfd, blockDfd, nmeshDfd, neighborhoodDfd).then(@render)

  render: =>
    world = World.first()

    if !Env.isChrome23
      @html @view('splash/browserError')(regionNames: world.region_names)
    else
      @html @view('splash/index')(regionNames: world.region_names)
      world.fetchRegions(@_loadCallback)

  activate: ->
    @el.fadeIn(=> @el.addClass("active"))
    @

  deactivate: ->
    @el.empty()

  _loadCallback: =>
    @navigate '/boroughs' if location.pathname == "/"
