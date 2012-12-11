$ = jQuery.sub()
World = App.World
Region = App.Region
Block = App.Block

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
    @active (params) -> @change(params.id)

    @addBlockModalController = new App.Controller.AddBlockModal()
    Block.bind 'refresh change', @renderBlocks

  change: (slug) ->
    @currentBoroughItem = _(@boroughItems).detect((borough) -> borough.slug == slug)
    console.log("selected #{@currentBoroughItem.slug}") if @currentBoroughItem?

  render: =>
    @worldRenderer = new App.WorldRenderer()
    #TODO: Clean up event handlers (like dblclick) on destruction

    world = World.first()
    @worldRenderer.addWorld(world)
    Block.fetch()

    _(world.regions().all()).each (region) =>
      @boroughItems.push(new App.Controller.BoroughItem(@worldRenderer, region))

    output = @html @view('boroughs/index')(regions: world.regions().all())
    @worldRenderer.attachToDom($(output).find("#world"))
    @worldRenderer.animate()

    $(output).dblclick(=> @addBlockModalController.activate())
    $(output).find(".debug").fadeIn() if Env.debug

  renderBlocks: =>
    @worldRenderer.addBlocks(Block.all())

  index: (e) ->
    @navigate '/boroughs'

  show: (e) ->
    item = $(e.target).regionViaSlug()
    @navigate '/boroughs', item.slug

  activate: =>
    @render()
    @el.fadeIn(=> @el.addClass("active"))
    @

  deactivate: =>
    @worldRenderer.destroy() if @worldRenderer?
    @el.fadeOut(=> @el.removeClass("active"))
    @
