$ = jQuery.sub()
World = App.World

$.fn.itemViaSlug = ->
  elementID   = $(@).data('slug')
  elementID or= $(@).parents('[data-slug]').data('slug')
  World.findByAttribute("slug", elementID)

class Index extends Spine.Controller
  events:
    'click [data-type=show]':    'show'

  constructor: ->
    super
    World.bind 'refresh change', @render
    World.fetch()

  render: =>
    worlds = World.all()
    @html @view('root/index')(worlds: worlds)

  show: (e) ->
    item = $(e.target).itemViaSlug()
    @navigate '/worlds', item.slug

class App.RootController extends Spine.Stack
  controllers:
    show:  App.WorldsController
    index: Index

  routes:
    '/':                'index'
    '/worlds/:id':      'show'

  default: 'index'
  className: 'stack root'
