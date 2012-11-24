$ = jQuery.sub()
World = App.World

$.fn.itemViaSlug = ->
  elementID   = $(@).data('slug')
  elementID or= $(@).parents('[data-slug]').data('slug')
  World.findByAttribute("slug", elementID)

class App.Controller.BoroughItem extends Spine.Controller
  events:
    'click [data-type=back]':    'back'

  constructor: (worldRenderer, world) ->
    super
    @worldRenderer = worldRenderer
    @world = world
    @worldRenderer.addWorlds(@world)

  render: =>

  back: ->
    @navigate '/boroughs'

  activate: ->
    @

  deactivate: ->
    @
