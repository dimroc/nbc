# Create a classic MVC architecture for every block
# and have this control handle user interactions fired
# from the BlockMesh (aka the view)
class App.BlocksGraphicController extends Spine.Module
  constructor: (block) ->
    super
    @model = block
    @view = new App.BlockMesh(block)
