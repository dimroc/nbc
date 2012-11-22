$ = jQuery.sub()
World = App.World

class Index extends Spine.Controller
  events:
    'click [data-type=show]':    'show'

  constructor: ->
    super
    @render()

  render: =>
    worlds = World.all()
    @html @view('root/index')(worlds: worlds)

  show: (e) ->
    @navigate '/worlds'#, item.slug

class App.Controller.Root extends Spine.Stack
  controllers:
    index: Index
    worldsShow:  App.Controller.Worlds.Show
    worldsIndex:  App.Controller.Worlds.Index

  routes:
    '/':                'index'
    '/worlds':          'worldsIndex'
    '/worlds/:id':      'worldsShow'

  default: 'index'
  className: 'stack root'
