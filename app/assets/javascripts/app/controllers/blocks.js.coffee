class App.Controller.Blocks extends Spine.Controller
  el: "#blocks"
  className: "accordion"

  constructor: ->
    super
    @render()
    App.Block.bind('refresh', @render)
    window.addEventListener( 'resize', @onWindowResize, false )
    #App.Neighborhood.bind('selected', @_selectNeighborhood)

  render: =>
    blockAccordions = for block in App.Block.all().reverse()
      @view("blockAccordionGroup")(block)

    @html blockAccordions.join("\r")
    @onWindowResize()

  onWindowResize:  =>
    @$el.height(window.innerHeight - 100)
