class App.WorldRenderer

  worldRenderers = []

  @all: -> worldRenderers
  @first: -> worldRenderers[0]
  @create: () -> new WorldRenderer()

  constructor: ()->
    if ( ! Detector.webgl )
      Detector.addGetWebGLMessage()

    console.debug("Creating worldRenderer...")
    @scene = new THREE.Scene()

    options = calculate_options()
    @camera = createPerspectiveCamera(options)
    @scene.add( @camera )

    @renderer = createRenderer(options)

    @ambientLight = createAmbientLight(options)
    @scene.add(@ambientLight)

    @directionalLight = createDirectionalLight(
      _.extend({}, options, {position: @camera.position})
    )

    @scene.add(@directionalLight)

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
    console.log "Resizing..."
    options = calculate_options()
    @renderer.setSize( options.width, options.height )
    @camera.aspect = options.width / options.height
    @camera.updateProjectionMatrix()

  animate: (elapsedTicks)=>
    render(@)
    if @destroyed
      cancelAnimationFrame @requestId
      console.debug("Animating after destruction...")
    else
      @requestId = requestAnimationFrame(@animate)

  add: (meshParam)->
    meshes = if _.isArray(meshParam) then meshParam else [meshParam]

    _.each(meshes, (mesh) ->
      @scene.add( mesh )
    , @)

    @

  meshes: ->
    _.select(@scene.children, (child) -> return child.geometry)

# privates

createOrthographicCamera = (options) ->
  camera = new THREE.OrthographicCamera( options.width / - 2, options.width / 2, options.height / 2, options.height / - 2,  1, 100 )
  camera.position = new THREE.Vector3(250, 0, 100)
  camera.lookAt(new THREE.Vector3(250, 0, 0))
  camera

createPerspectiveCamera = (options) ->
  camera = new THREE.PerspectiveCamera( options.fov, options.width / options.height, 1, 1000 )
  camera.position = new THREE.Vector3(0, 0, 100)
  camera.lookAt(new THREE.Vector3(0, 0, 0))
  camera

createRenderer = (options) ->
  renderer = new THREE.WebGLRenderer({antialias: true})
  renderer.setSize( options.width, options.height )
  renderer

createDirectionalLight = (options) ->
  # White directional light at half intensity shining from the top.
  directionalLight = new THREE.DirectionalLight( 0xffffff, 0.7 )
  directionalLight.position.set(options.position.x, options.position.y, options.position.z)
  directionalLight

createAmbientLight = (options) ->
  light = new THREE.AmbientLight( 0x333333 )

render = (worldRenderer) ->
  worldRenderer.scene.children.forEach (child) ->
    child.animate() if child.animate

  worldRenderer.renderer.render( worldRenderer.scene, worldRenderer.camera )
  worldRenderer.stats.update()

calculate_options = ->
  {
    fov: 45
    width: window.innerWidth
    height: window.innerHeight - 60
  }
