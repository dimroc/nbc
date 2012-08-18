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

#= require_tree ./controllers

#= require_tree ./views

class App extends Spine.Controller
  constructor: ->
    super

    # Initialize controllers:
    #  @append(@items = new App.Items)
    #  ...

    Spine.Log.log("Initializing Application...")
    @append(@worldsController = new App.WorldsController)
    Spine.Route.setup()
    App.instance = @

window.App = App
