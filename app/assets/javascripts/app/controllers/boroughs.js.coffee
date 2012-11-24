$ = jQuery.sub()
World = App.World

$.fn.itemViaSlug = ->
  elementID   = $(@).data('slug')
  elementID or= $(@).parents('[data-slug]').data('slug')
  World.findByAttribute("slug", elementID)

class App.Controller.Boroughs extends Spine.Controller
  events:
    'click [data-type=show]':    'show'

  constructor: ->
    super
    @boroughItems = []
    @worldRenderer = new App.WorldRenderer()
    World.bind 'allLoaded', @addAllBoroughs

  addAllBoroughs: (worlds) =>
    _(worlds).each (world) =>
      @boroughItems.push(new App.Controller.BoroughItem(@worldRenderer, world))
    @render()

  render: =>
    output = @html @view('boroughs/index')(worlds: World.all())
    @worldRenderer.attachToDom($(output).find("#world"))
    output

  show: (e) ->
    item = $(e.target).itemViaSlug()
    @navigate '/boroughs', item.slug

  activate: ->
    @el.fadeIn(=> @el.addClass("active"))
    @worldRenderer.animate()
    @

  deactivate: ->
    @el.fadeOut(=> @el.removeClass("active"))
    @
