class App.Controller.SelectedNeighborhood extends Spine.Controller
  el: ".selectedNeighborhood"
  className: "selectedNeighborhood"

  constructor: ->
    super
    @render()
    App.Neighborhood.bind('selected', @_selectNeighborhood)
    App.Neighborhood.bind('refresh change', @_setAvailableNeighborhoods)

  _setAvailableNeighborhoods: =>
    @_availableNeighborhoods = for n in App.Neighborhood.all()
      "#{n.name}, #{n.borough}"

    @_searchInput().typeahead(
      source: @_availableNeighborhoods
      updater: @_updater
    )

  _updater: (entry) ->
    value = entry.substring(0, entry.indexOf(", ")).toLowerCase()
    App.Neighborhood.findByAttribute("slug", Helpers.slugify(value)).trigger('selected')
    entry

  _selectNeighborhood: (neighborhood) =>
    @_searchInput().val("#{neighborhood.name}, #{neighborhood.borough}")

  render: (neighborhood) ->
    @$el.html(@view('selectedNeighborhood')(@_presenter(neighborhood)))

  _presenter: (neighborhood) ->
    if neighborhood
      text = "#{neighborhood.name}, #{neighborhood.borough}"
    else
      text = "Type or click to select a neighborhood"
    label: text

  _searchInput: ->
    @$("input[name=neighborhood]")
