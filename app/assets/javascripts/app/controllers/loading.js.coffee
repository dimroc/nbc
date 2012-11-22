$ = jQuery.sub()
World = App.World

class App.Controller.Loading extends Spine.Controller
  events:
    'click [data-type=show]':    'show'

  constructor: ->
    super
    @render()

  render: =>
    worlds = World.all()
    @html @view('root/index')(worlds: worlds)

  show: (e) ->
    @navigate '/worlds'
