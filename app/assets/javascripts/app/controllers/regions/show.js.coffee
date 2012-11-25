$ = jQuery.sub()
Region = App.Region

class App.Controller.Regions.Show extends Spine.Controller
  events:
    'click [data-type=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id) if params

  change: (slug) ->
    @item = Region.findByAttribute("slug", slug)

  render: ->
    output = @html @view('regions/show')(@item)
    @worldRenderer.attachToDom($(output).find("#world"))
    @worldRenderer.addRegions(@item)
    @worldRenderer.animate()
    output

  back: ->
    @navigate '/regions'

  activate: ->
    super
    @worldRenderer = new App.WorldRenderer()
    @render()

  deactivate: ->
    super
    if @worldRenderer
      @worldRenderer.destroy()
      delete @worldRenderer

    @el.empty()
