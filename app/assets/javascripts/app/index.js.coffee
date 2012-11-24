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
#= require ./controllers/splash
#= require ./controllers/test
#= require_tree ./controllers/worlds
#= require ./controllers/root

#= require_tree ./views

class App extends Spine.Controller
  constructor: ->
    super

    # Initialize controllers:
    #  @append(@items = new App.Items)
    #  ...

    App.World.one('allLoaded', @_loadCallback)
    @append(@rootController = new App.Controller.Root)
    @initialUrl = location.hash

    App.instance = @

  _loadCallback: =>
    # Only navigate to URL once loaded.
    Spine.Route.setup(history: true)

window.App = App
