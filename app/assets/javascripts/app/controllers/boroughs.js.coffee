$ = jQuery
World = App.World
Region = App.Region
Block = App.Block
Neighborhood = App.Neighborhood
NeighborhoodMesh = App.NeighborhoodMesh

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

  change: (slug) ->
    @render()
    neighborhood = App.Neighborhood.findByAttribute("slug", slug)
    neighborhood.trigger('selected') if neighborhood

  render: =>
    return if @worldRenderer?

    world = World.first()
    output = @html @view('boroughs/index')(regions: world.regions().all())

    # TODO: worldRenderer should be a singleton service and consumer should communicate
    # with it via events
    @worldRenderer = new App.WorldRenderer(world, $(output).find("#world"))
    @neighborhoodController = new App.Controller.Neighborhoods(@worldRenderer)

    _(world.regions().all()).each (region) =>
      @boroughItems.push(new App.Controller.BoroughItem(@worldRenderer, region))

    @worldRenderer.animate()
    @worldRenderer.reloadBlocks(Block.all())

    @debugController = new App.Controller.Debug(output)
    @addBlockModalController = new App.Controller.AddBlockModal(output, @worldRenderer)
    @userPanelController = new App.Controller.UserPanel()

    Spine.trigger('ready')

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
    if @worldRenderer?
      @worldRenderer.destroy() if @worldRenderer?
      delete @worldRenderer
      @el.empty()
