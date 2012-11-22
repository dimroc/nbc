$ = jQuery.sub()
World = App.World

class App.Controller.Splash extends Spine.Controller
  className: 'splash'

  constructor: ->
    super
    World.bind 'refresh change', @render
    World.fetch()

  render: =>
    worlds = World.all()
    if !Env.isChrome23
      @html @view('splash/browserError')(worlds: worlds)
    else
      @html @view('splash/index')(worlds: worlds)
      @_asyncLoadWorlds(worlds)

  _asyncLoadWorlds: (worlds) ->
    console.log "Loading Boroughs"
    _(worlds).each (world) ->
      world.fetchRegions (world) ->
        console.log "Loaded #{world.name}"
        world_class = _(world.name).underscored()
        $(".loading.#{world_class}").addClass("hidden")

