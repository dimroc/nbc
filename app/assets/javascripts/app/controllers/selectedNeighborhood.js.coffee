class App.Controller.SelectedNeighborhood extends Spine.Controller
  className: "selectedNeighborhood"

  constructor: (parentElement) ->
    super
    @parentElement = parentElement
    App.Neighborhood.bind('selected', @_selectNeighborhood)
    @activate()

  _selectNeighborhood: (neighborhood) =>
    @render(neighborhood)

  render: (neighborhood) ->
    @$el.html(@view('selectedNeighborhood')(neighborhood))

  activate: ->
    $(@parentElement).prepend(@$el)
    @

  deactivate: ->
    @$el.remove()
