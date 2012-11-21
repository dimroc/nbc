class App.WorldPass
  constructor: ( worldRenderer ) ->
    @worldRenderer = worldRenderer

    @enabled = true
    @needsSwap = false
    @renderToScreen = false

  render: ( renderer, writeBuffer, readBuffer, delta ) ->
    renderer.clearTarget(readBuffer)

    if @renderToScreen
      renderer.render(@worldRenderer.outline_scene, @worldRenderer.camera)
      renderer.render(@worldRenderer.block_scene, @worldRenderer.camera)
    else
      # Render to the ReadBuffer since this is the first pass and no swap is necessary.
      renderer.render(@worldRenderer.outline_scene, @worldRenderer.camera, readBuffer)
      renderer.render(@worldRenderer.block_scene, @worldRenderer.camera, readBuffer)
