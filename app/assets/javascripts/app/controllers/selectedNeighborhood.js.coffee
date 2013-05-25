class App.Controller.SelectedNeighborhood extends Spine.Controller
  el: ".selectedNeighborhood"
  className: "selectedNeighborhood"

  constructor: ->
    super
    @render()
    App.Neighborhood.bind('selected', @_selectNeighborhood)

  _selectNeighborhood: (neighborhood) =>
    @render(neighborhood)

  render: (neighborhood) ->
    @$el.html(@view('selectedNeighborhood')(@_presenter(neighborhood)))

  _presenter: (neighborhood) ->
    if neighborhood
      text = "#{neighborhood.name}, #{neighborhood.borough}"
    else
      text = "Select a Neighborhood..."

    label: text
