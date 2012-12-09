$ = jQuery.sub()
World = App.World
Region = App.Region

$.fn.regionViaSlug = ->
  elementID   = $(@).data('slug')
  elementID or= $(@).parents('[data-slug]').data('slug')
  Region.findByAttribute("slug", elementID)

class App.Controller.Boroughs extends Spine.Controller
  className: 'boroughs'
  events:
    'click [data-type=index]':   'index'
    'click [data-type=show]':    'show'

  constructor: ->
    super
    @boroughItems = []
    @worldRenderer = new App.WorldRenderer()
    @active (params) -> @change(params.id)

    World.bind 'loaded', @render

  change: (slug) ->
    @currentBoroughItem = _(@boroughItems).detect((borough) -> borough.slug == slug)
    console.log("selected #{@currentBoroughItem.slug}") if @currentBoroughItem?

  render: =>
    world = World.first()
    @worldRenderer.addWorld(world)

    _(world.regions().all()).each (region) =>
      @boroughItems.push(new App.Controller.BoroughItem(@worldRenderer, region))

    output = @html @view('boroughs/index')(regions: world.regions().all())
    @worldRenderer.attachToDom($(output).find("#world"))
    @worldRenderer.animate()
    $(output).find(".debug").fadeIn() if Env.debug

  index: (e) ->
    @navigate '/boroughs'

  show: (e) ->
    item = $(e.target).regionViaSlug()
    @navigate '/boroughs', item.slug

  activate: ->
    @el.fadeIn(=> @el.addClass("active"))
    @

  deactivate: ->
    @el.fadeOut(=> @el.removeClass("active"))
    @
