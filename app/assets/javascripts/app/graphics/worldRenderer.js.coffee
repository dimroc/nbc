class App.WorldRenderer extends Spine.Module
  @extend Spine.Events

  worldRenderers = []

  @all: -> worldRenderers
  @first: -> worldRenderers[0]
  @create: () -> new WorldRenderer()

  constructor: (world, domElement) ->
    if ( ! Detector.webgl )
      Detector.addGetWebGLMessage()

    console.debug("Creating worldRenderer...")
    @world = world
    @clock = new THREE.Clock()
    @stats = new App.StatsRenderer()
    @blockScene = new THREE.Scene()
    @regionScene = new THREE.Scene()

    options = calculate_options()
    @renderer = createRenderer(options)
    @composer = createComposer(options, @)

    @camera = createPerspectiveCamera(options)

    @ambientLight = createAmbientLight(options)
    @blockScene.add(@ambientLight)

    @directionalLight = createDirectionalLight(
      _.extend({}, options, {position: @camera.position})
    )

    @blockScene.add(@directionalLight)

    @_attachToDom(domElement)
    @controls = new App.CameraControls(@camera, domElement)
    @debugRenderer = new App.DebugRenderer(@world, @camera, @controls)

    worldRenderers.push(@)

  destroy: ->
    console.debug("Destroying worldRenderer...")

    @destroyed = true
    @controls.destroy()
    @stats.destroy()
    cancelAnimationFrame @requestId
    window.removeEventListener( 'resize', @onWindowResize, false )
    worldRenderers = _(worldRenderers).reject (worldRenderer) => worldRenderer == @

  _attachToDom: (domElement)->
    @domElement = domElement
    $(domElement).append(@renderer.domElement)
    @stats.attachToDom(domElement)
    window.addEventListener( 'resize', @onWindowResize, false )
    @

  onWindowResize: ( event ) =>
    options = calculate_options()
    @renderer.setSize( options.width, options.height )
    @controls.handleResize()

  animate: (elapsedTicks)=>
    delta = @clock.getDelta()

    @update(delta)
    @render(delta)

    if @destroyed
      cancelAnimationFrame @requestId
      console.debug("Animating after destruction...")
    else
      @requestId = requestAnimationFrame(@animate)

  update: (delta) ->
    @controls.update(delta)
    @debugRenderer.update(delta) if Env.debug
    @stats.update()

  render: (delta) ->
    @composer.render(delta)

  addRegionMeshes: (meshParam)->
    _.each(coerceIntoArray(meshParam), (mesh) ->
      @regionScene.add( mesh )
    , @)
    @

  addBlocks: (blocks) ->
    _.each(coerceIntoArray(blocks), (block) ->
      @blockScene.add(block.mesh(@world))
    , @)
    @

  addRegions: (regions)->
    _(coerceIntoArray(regions)).each (region) =>
      # @addRegions(region.outlineMeshes())
      @addRegionMeshes(region.modelMesh())

  reloadRegions: ->
    @regionScene = new THREE.Scene()
    @addRegions(@world.regions().all())

  meshes: ->
    @regionScene.children.concat @blockScene.children

# privates

coerceIntoArray = (meshParam) ->
  # Simply convert meshParam into an array if it isn't one already
  if _.isArray(meshParam) then meshParam else [meshParam]

createOrthographicCamera = (options) ->
  camera = new THREE.OrthographicCamera( options.width / - 2, options.width / 2, options.height / 2, options.height / - 2,  1, 100 )
  camera.position = new THREE.Vector3(250, 0, 100)
  camera.lookAt(new THREE.Vector3(250, 0, 0))
  camera

createPerspectiveCamera = (options) ->
  camera = new THREE.PerspectiveCamera( options.fov, options.width / options.height, 1, 1000 )
  camera

createRenderer = (options) ->
  renderer = new THREE.WebGLRenderer({antialias: true})

  renderer.setSize( options.width, options.height )
  renderer.setClearColorHex( 0xffffff, 1 )
  renderer.autoClear = false
  renderer.autoClearColor = false
  renderer.sortObjects = false
  renderer

createComposer = (options, worldRenderer) ->
  composer = new THREE.EffectComposer( worldRenderer.renderer, createRenderTarget(options) )

  worldPass = new App.WorldPass ( worldRenderer )
  worldPass.renderToScreen = true

  # pass = new THREE.ShaderPass( THREE.CopyShader )
  # pass.renderToScreen = true

  composer.addPass( worldPass )
  # composer.addPass( pass )
  composer

createRenderTarget = (options) ->
  renderTargetParameters = {
    minFilter: THREE.NearestFilter,
    magFilter: THREE.NearestFilter,
    format: THREE.RGBFormat
  }

  new THREE.WebGLRenderTarget(
    options.width,
    options.height,
    renderTargetParameters)

createDirectionalLight = (options) ->
  # White directional light at half intensity shining from the top.
  directionalLight = new THREE.DirectionalLight( 0xffffff, 0.7 )
  directionalLight.position.set(options.position.x, options.position.y, options.position.z)
  directionalLight.lookAt(new THREE.Vector3(options.position.x, options.position.y, 0))
  directionalLight

createAmbientLight = (options) ->
  light = new THREE.AmbientLight( 0x333333 )

calculate_options = ->
  {
    fov: 45
    width: window.innerWidth
    height: window.innerHeight
  }
