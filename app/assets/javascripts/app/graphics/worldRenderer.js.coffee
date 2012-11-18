class App.WorldRenderer

  worldRenderers = []

  @all: -> worldRenderers
  @first: -> worldRenderers[0]
  @create: () -> new WorldRenderer()

  constructor: ()->
    if ( ! Detector.webgl )
      Detector.addGetWebGLMessage()

    console.debug("Creating worldRenderer...")
    @clock = new THREE.Clock()
    @block_scene = new THREE.Scene()
    @outline_scene = new THREE.Scene()

    options = calculate_options()
    @camera = createPerspectiveCamera(options)
    @cameraHelper = new THREE.CameraHelper(@camera)
    @block_scene.add(@cameraHelper)

    @renderer = createRenderer(options)
    @composer = createComposer(options, @)

    @ambientLight = createAmbientLight(options)
    @block_scene.add(@ambientLight)

    @directionalLight = createDirectionalLight(
      _.extend({}, options, {position: @camera.position})
    )

    @block_scene.add(@directionalLight)

    @stats = new App.StatsRenderer()

    worldRenderers.push(@)

  destroy: ->
    console.debug("Destroying worldRenderer...")

    @destroyed = true
    @stats.destroy()
    cancelAnimationFrame @requestId
    window.removeEventListener( 'resize', @onWindowResize, false )
    worldRenderers = _(worldRenderers).reject (worldRenderer) => worldRenderer == @

  attachToDom: (domElement)->
    $(domElement).append(@renderer.domElement)
    @stats.attachToDom()
    window.addEventListener( 'resize', @onWindowResize, false )
    @

  onWindowResize: ( event ) =>
    options = calculate_options()
    @renderer.setSize( options.width, options.height )
    @camera.aspect = options.width / options.height
    @camera.updateProjectionMatrix()
    @cameraHelper.update()

  animate: (elapsedTicks)=>
    render(@)
    if @destroyed
      cancelAnimationFrame @requestId
      console.debug("Animating after destruction...")
    else
      @requestId = requestAnimationFrame(@animate)

  add_outlines: (meshParam)->
    _.each(coerceIntoMeshes(meshParam), (mesh) ->
      @outline_scene.add( mesh )
    , @)
    @

  add_blocks: (meshParam)->
    _.each(coerceIntoMeshes(meshParam), (mesh) ->
      @block_scene.add( mesh )
    , @)
    @

  meshes: ->
    @outline_scene.children.concat @block_scene.children

# privates

coerceIntoMeshes = (meshParam) ->
  # Simply convert meshParam into an array if it isn't one already
  if _.isArray(meshParam) then meshParam else [meshParam]

createOrthographicCamera = (options) ->
  camera = new THREE.OrthographicCamera( options.width / - 2, options.width / 2, options.height / 2, options.height / - 2,  1, 100 )
  camera.position = new THREE.Vector3(250, 0, 100)
  camera.lookAt(new THREE.Vector3(250, 0, 0))
  camera

createPerspectiveCamera = (options) ->
  camera = new THREE.PerspectiveCamera( options.fov, options.width / options.height, 1, 1000 )
  position = new THREE.Vector3(45, 20, 60)
  camera.position = position
  camera.lookAt(new THREE.Vector3(position.x, position.y, 0))
  camera

createRenderer = (options) ->
  renderer = new THREE.WebGLRenderer({antialias: true})

  renderer.setSize( options.width, options.height )
  renderer.setClearColorHex( 0xffffff, 0 )
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

render = (worldRenderer) ->
  delta = worldRenderer.clock.getDelta()
  worldRenderer.meshes().forEach (child) ->
    child.animate(delta) if child.animate

  worldRenderer.composer.render(delta)
  worldRenderer.stats.update()

calculate_options = ->
  {
    fov: 45
    width: window.innerWidth
    height: window.innerHeight - 60
  }
