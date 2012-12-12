class App.Controller.BoroughItem extends Spine.Controller
  constructor: (worldRenderer, region) ->
    super
    @worldRenderer = worldRenderer
    @region = region
    @slug = region.slug
    @worldRenderer.addRegions(region)

  render: =>

  back: ->
    @navigate '/boroughs'

  activate: ->
    @

  deactivate: ->
    @
