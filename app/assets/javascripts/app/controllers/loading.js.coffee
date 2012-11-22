$ = jQuery.sub()
World = App.World

class App.Controller.Loading extends Spine.Controller
  className: 'loading'

  constructor: ->
    super
    World.bind 'refresh change', @render

  render: =>
    worlds = World.all()
    if !Env.isChrome23
      @html @view('loading/browserError')(worlds: worlds)
    else
      @html @view('loading/index')(worlds: worlds)
