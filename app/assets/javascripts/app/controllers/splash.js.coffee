class App.Controller.Splash extends Spine.Controller
  className: 'splash'

  constructor: ->
    super
    console.log("In constructor")
    App.PreloadingService.preload().done(@render)

  render: =>
    console.log("In SPLASH::Render")
    world = App.World.first()

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
    @navigate '/neighborhoods' if location.pathname == "/"
