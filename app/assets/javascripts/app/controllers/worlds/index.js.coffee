$ = jQuery.sub()
World = App.World

$.fn.itemViaSlug = ->
  elementID   = $(@).data('slug')
  elementID or= $(@).parents('[data-slug]').data('slug')
  World.findByAttribute("slug", elementID)

class App.Controller.Worlds.Index extends Spine.Controller
  events:
    'click [data-type=show]':    'show'
    'click [data-type=back]':    'back'

  constructor: ->
    super
    World.bind 'refresh change', @render

  render: =>
    worlds = World.all()
    @html @view('worlds/index')(worlds: worlds)

  show: (e) ->
    item = $(e.target).itemViaSlug()
    @navigate '/worlds', item.slug

  back: ->
    @navigate '/'
