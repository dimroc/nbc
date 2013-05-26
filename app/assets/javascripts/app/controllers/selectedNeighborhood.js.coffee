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
      label: "#{n.name}, #{n.borough}"
      value: n.id

    @_searchInput().autocomplete(
      source: @_availableNeighborhoods
      select: @_selectAutocompleteEntry
      context: @
    )

  _selectAutocompleteEntry: (event, object) =>
    App.Neighborhood.find(object.item.value).trigger('selected')
    false

  _selectNeighborhood: (neighborhood) =>
    @_searchInput().val("#{neighborhood.name}, #{neighborhood.borough}")

  render: (neighborhood) ->
    @$el.html(@view('selectedNeighborhood')(@_presenter(neighborhood)))
    @_disableEnterKey()

  _presenter: (neighborhood) ->
    if neighborhood
      text = "#{neighborhood.name}, #{neighborhood.borough}"
    else
      text = "Type or click to select a neighborhood"
    label: text

  _searchInput: ->
    @$("input[name=neighborhood]")

  _disableEnterKey: ->
    @_searchInput().keypress (e) ->
      code = if e.keyCode then e.keyCode else e.which
      if code is 13
        false
