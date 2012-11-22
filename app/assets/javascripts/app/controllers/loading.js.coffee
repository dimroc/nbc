$ = jQuery.sub()
World = App.World

class App.Controller.Loading extends Spine.Controller
  className: 'loading'
  events:
    'click [data-type=show]':    'show'

  constructor: ->
    super
    World.bind 'refresh change', @render
    World.fetch()
    # @render()

  render: =>
    worlds = World.all()
    @html @view('loading/index')(worlds: worlds)

  show: (e) ->
    @navigate '/worlds'
