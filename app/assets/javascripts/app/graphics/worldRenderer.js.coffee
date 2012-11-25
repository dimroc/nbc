class App.WorldRenderer extends Spine.Module
  @extend Spine.Events

  worldRenderers = []

  @all: -> worldRenderers
  @first: -> worldRenderers[0]
  @create: () -> new WorldRenderer()

  constructor: ()->
    if ( ! Detector.webgl )
      Detector.addGetWebGLMessage()

    console.debug("Creating worldRenderer...")
    @clock = new THREE.Clock()
    @blockScene = new THREE.Scene()
    @outlineScene = new THREE.Scene()
    # @outlineScene.fog = new THREE.Fog( 0xffffff, 0, 1000 )

    options = calculate_options()
    @camera = createPerspectiveCamera(options)
    @controls = new App.CameraControls(@camera)

    @renderer = createRenderer(options)
    @composer = createComposer(options, @)

    @ambientLight = createAmbientLight(options)
    @blockScene.add(@ambientLight)

    @directionalLight = createDirectionalLight(
      _.extend({}, options, {position: @camera.position})
    )

    @blockScene.add(@directionalLight)

    @projector = new THREE.Projector()
    @mouse2D = new THREE.Vector3( 0, 1000, 0.5 )
    @mouseRay = new THREE.Ray( @camera.position, null )
    @stats = new App.StatsRenderer()

    worldRenderers.push(@)

  destroy: ->
    console.debug("Destroying worldRenderer...")

    @destroyed = true
    @stats.destroy()
    cancelAnimationFrame @requestId
    window.removeEventListener( 'resize', @onWindowResize, false )
    window.removeEventListener( 'mousemove', @onDocumentMouseMove, false )
    worldRenderers = _(worldRenderers).reject (worldRenderer) => worldRenderer == @

  attachToDom: (domElement)->
    $(domElement).append(@renderer.domElement)
    @stats.attachToDom()
    window.addEventListener( 'resize', @onWindowResize, false )
    window.addEventListener( 'mousemove', @onDocumentMouseMove, false )
    @

  onWindowResize: ( event ) =>
    options = calculate_options()
    @renderer.setSize( options.width, options.height )
    updateCamera(@camera, options)
    @controls.handleResize()

  onDocumentMouseMove: ( event ) =>
    event.preventDefault()

    @mouse2D.x = ( event.clientX / window.innerWidth ) * 2 - 1
    @mouse2D.y = - ( event.clientY / window.innerHeight ) * 2 + 1

    mouse3D = @projector.unprojectVector( @mouse2D.clone(), @camera )
    @mouseRay.direction = mouse3D.subSelf( @camera.position ).normalize()

  animate: (elapsedTicks)=>
    render(@)
    if @destroyed
      cancelAnimationFrame @requestId
      console.debug("Animating after destruction...")
    else
      @requestId = requestAnimationFrame(@animate)

  addOutlines: (meshParam)->
    _.each(coerceIntoArray(meshParam), (mesh) ->
      @outlineScene.add( mesh )
    , @)
    @

  addBlocks: (meshParam)->
    _.each(coerceIntoArray(meshParam), (mesh) ->
      @blockScene.add( mesh )
    , @)
    @

  addRegions: (regions)->
    _(coerceIntoArray(regions)).each (region) =>
      # @addOutlines(region.outlineMeshes())
      @addOutlines(region.modelMesh())
      @addBlocks(region.blocksMesh())
      App.WorldRenderer.trigger 'regionAdded', region


  addWorld: (world)->
    @addRegions(world.regions().all())
    App.WorldRenderer.trigger 'worldAdded', world

  meshes: ->
    @outlineScene.children.concat @blockScene.children

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
  updateCamera(camera, options)
  camera

projector = new THREE.Projector()
# Bottom left corner of screen space
leftScreenSpaceVector = new THREE.Vector3(-1, -0.9, 0)

updateCamera = (camera, options) ->
  distanceFromWorld = 60

  camera.aspect = options.width / options.height
  camera.position = new THREE.Vector3(0,0,0)
  camera.lookAt(new THREE.Vector3(0,0,-1))
  camera.updateMatrixWorld()
  camera.updateProjectionMatrix()

  # Ray from camera down the bottom-left side of the view frustum
  ray = projector.pickingRay(leftScreenSpaceVector.clone(), camera)

  magnitudeToWorld = distanceFromWorld / ray.direction.z

  position = ray.origin.clone().addSelf(
    ray.direction.clone().multiplyScalar(magnitudeToWorld))

  camera.position = new THREE.Vector3(position.x, position.y, distanceFromWorld)
  camera.lookAt(new THREE.Vector3(position.x, position.y, 0))

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

render = (worldRenderer) ->
  delta = worldRenderer.clock.getDelta()
  worldRenderer.meshes().forEach (child) ->
    child.animate(delta) if child.animate

  worldRenderer.controls.update( delta )
  worldRenderer.composer.render(delta)
  worldRenderer.stats.update()

calculate_options = ->
  {
    fov: 45
    width: window.innerWidth
    height: window.innerHeight
  }
