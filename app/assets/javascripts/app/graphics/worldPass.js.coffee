class App.WorldPass
  constructor: ( worldRenderer ) ->
    @worldRenderer = worldRenderer

    @enabled = true
    @needsSwap = false
    @renderToScreen = false

  render: ( renderer, writeBuffer, readBuffer, delta ) ->
    renderer.clear()
    renderer.clearTarget(readBuffer)

    if @renderToScreen
      renderer.render(@worldRenderer.outlineScene, @worldRenderer.camera)
      renderer.render(@worldRenderer.blockScene, @worldRenderer.camera)
    else
      # Render to the ReadBuffer since this is the first pass and no swap is necessary.
      renderer.render(@worldRenderer.outlineScene, @worldRenderer.camera, readBuffer)
      renderer.render(@worldRenderer.blockScene, @worldRenderer.camera, readBuffer)
