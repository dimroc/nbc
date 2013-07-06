class App.Controller.Tweets extends Spine.Controller
  el: "#tweets"

  constructor: ->
    super
    #@render()
    #App.Tweet.bind('refresh', @render)
    #window.addEventListener( 'resize', @onWindowResize, false )
    #App.Neighborhood.bind('selected', @_selectNeighborhood)

  render: =>
    blockAccordions = for block in App.Block.all().reverse()
      @view("blockAccordionGroup")(block)

    @html blockAccordions.join("\r")
    @onWindowResize()

  onWindowResize:  =>
    @$el.height(window.innerHeight - 100)
