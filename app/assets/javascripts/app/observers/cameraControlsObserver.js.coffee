class App.CameraControlsObserver extends Spine.Module
  @extend Spine.Events

  constructor: ->
    App.CameraControls.bind('selectPoint', @selectBlockFromPoint)

  selectBlockFromPoint: (pointOnSurface)=>
    selectedBlock = _(App.Block.all()).detect((block) ->
      world = App.World.current()
      block.contains(pointOnSurface, world)
    )

    selectedBlock.trigger('selected') if selectedBlock?

singleton = new App.CameraControlsObserver()
