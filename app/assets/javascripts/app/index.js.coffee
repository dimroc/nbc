#= require json2
#= require jquery
#= require spine
#= require spine/manager
#= require spine/ajax
#= require spine/route
#= require spine/relation

#= require_tree ./lib
#= require_self

#= require_tree ./graphics

#= require ./models/model
#= require_tree ./models

#= require ./controllers/controller
#= require_tree ./controllers/worlds
#= require ./controllers/root

#= require_tree ./views

class App extends Spine.Controller
  constructor: ->
    super

    # Initialize controllers:
    #  @append(@items = new App.Items)
    #  ...

    Spine.Log.log("Initializing Application...")
    @append(@rootController = new App.Controller.Root)
    Spine.Route.setup()
    App.instance = @

window.App = App
