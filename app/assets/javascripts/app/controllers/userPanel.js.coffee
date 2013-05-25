class App.Controller.UserPanel extends Spine.Controller
  el: ".userPanel"

  constructor: ->
    super
    @render()
    @facebookController = new App.Controller.Facebook()
    @selectedNeighborhoodController = new App.Controller.SelectedNeighborhood()

  render: ->
    @html(@view('userPanel'))
