class App.Controller.BoroughItem extends Spine.Controller
  events:
    'click [data-type=back]':    'back'

  constructor: (worldRenderer, region) ->
    super
    @worldRenderer = worldRenderer
    @region = region
    @slug = region.slug

  render: =>

  back: ->
    @navigate '/boroughs'

  activate: ->
    @

  deactivate: ->
    @
