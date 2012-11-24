$ = jQuery.sub()
World = App.World

$.fn.itemViaSlug = ->
  elementID   = $(@).data('slug')
  elementID or= $(@).parents('[data-slug]').data('slug')
  World.findByAttribute("slug", elementID)

class App.Controller.Boroughs extends Spine.Controller
  constructor: ->
    super
    @worldRenderer = new App.WorldRenderer()
    World.one 'allLoaded', @render

  render: =>
    output = @html @view('boroughs/index')
    @worldRenderer.attachToDom($(output).find("#world"))

    _(World.all()).each (world) =>
      @worldRenderer.addOutlines(world.outlineMeshes())
      @worldRenderer.addOutlines(world.modelMeshes())
      @worldRenderer.addBlocks(world.allBlockMeshes())

    App.WorldRenderer.trigger 'loaded', @worldRenderer
    output

  show: (e) ->
    item = $(e.target).itemViaSlug()
    @navigate '/boroughs', item.slug

  back: ->
    @navigate '/'

  activate: ->
    @el.addClass("active")
    @worldRenderer.animate()
    @

  deactivate: ->
    @el.removeClass("active")
    @
