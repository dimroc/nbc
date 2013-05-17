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
      renderer.render(@worldRenderer.regionScene, @worldRenderer.camera) if Env.boroughs
      renderer.render(@worldRenderer.neighborhoodScene, @worldRenderer.camera) if @worldRenderer.neighborhoodScene && Env.neighborhoods
      renderer.render(@worldRenderer.blockScene, @worldRenderer.camera) if Env.blocks
      renderer.render(@worldRenderer.debugRenderer.debugScene, @worldRenderer.camera) if Env.debug
    else
      # Render to the ReadBuffer since this is the first pass and no swap is necessary.
      renderer.render(@worldRenderer.regionScene, @worldRenderer.camera, readBuffer) if Env.boroughs
      renderer.render(@worldRenderer.neighborhoodScene, @worldRenderer.camera, readBuffer) if @worldRenderer.neighborhoodScene && Env.neighborhoods
      renderer.render(@worldRenderer.blockScene, @worldRenderer.camera, readBuffer) if Env.blocks
      renderer.render(@worldRenderer.debugRenderer.debugScene, @worldRenderer.camera, readBuffer) if Env.debug
