$ = jQuery.sub()
World = App.World

class App.Controller.Splash extends Spine.Controller
  className: 'splash'

  constructor: ->
    super
    World.bind 'refresh change', @render
    World.bind 'loaded', @_loadedCallback
    App.WorldRenderer.one 'loaded', @_allLoadedCallback
    World.fetch()

  render: =>
    worlds = World.all()
    if !Env.isChrome23
      @html @view('splash/browserError')(worlds: worlds)
    else
      @html @view('splash/index')(worlds: worlds)
      World.fetchAllDetails()

  _loadedCallback: (world) =>
    world_class = _(world.name).underscored()
    $(".loading.#{world_class}").addClass("hidden")
    $(".icon.#{world_class}").removeClass("hidden")

  _allLoadedCallback: =>
    console.log "renderer ready"
    @navigate '/boroughs'

  activate: ->
    @el.fadeIn(=> @el.addClass("active"))
    @

  deactivate: ->
    @el.fadeOut(=> @el.removeClass("active"))
    @
