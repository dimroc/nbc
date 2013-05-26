class App.Controller.BoroughItem extends Spine.Controller
  constructor: (worldRenderer, region) ->
    super
    @worldRenderer = worldRenderer
    @region = region
    @slug = region.slug
    @worldRenderer.addRegions(region)

  render: =>

  back: ->
    @navigate '/neighborhoods'

  activate: ->
    @

  deactivate: ->
    @
