World = App.World

class App.WorldsController extends Spine.Controller
  events:
    'click [data-type=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (slug) ->
    World.findOrFetch(slug, (world) =>
      @item = world
      @item.fetchRegions => @render()
    )

  render: ->
    output = @html @view('worlds/show')(@item)
    @worldRenderer.attachToDom($(output).find("#world"))
    @worldRenderer.add_outlines(@item.outline_meshes())
    @worldRenderer.add_blocks(@item.blocks_meshes())
    @worldRenderer.animate()
    output

  back: ->
    @navigate '/'

  activate: ->
    super
    @worldRenderer = new App.WorldRenderer()

  deactivate: ->
    super
    if @worldRenderer
      @worldRenderer.destroy()
      delete @worldRenderer

    @el.empty()

