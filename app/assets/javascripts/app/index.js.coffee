#= require json2
#= require jquery
#= require spine
#= require spine/manager
#= require spine/ajax
#= require spine/route
#= require spine/relation

#= require_tree ./lib
#= require_self

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
    @append(@regionsController = new App.RegionsController)
    Spine.Route.setup()
    App.instance = @

window.App = App
