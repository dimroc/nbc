class App.WorldRenderer

  worldRenderers = []

  @DEFAULT_OPTIONS: {
    fov: 45
    width: 1280
    height: 720
  }

  @all: -> worldRenderers
  @first: -> worldRenderers[0]
  @create: (options) -> new WorldRenderer(options)

  constructor: (options)->
    options = $.extend(true, WorldRenderer.DEFAULT_OPTIONS, options)

    if ( ! Detector.webgl )
      Detector.addGetWebGLMessage()

    console.debug("Creating worldRenderer...")
    @scene = new THREE.Scene()

    @camera = createCamera(options)
    @scene.add( @camera )

    @renderer = createRenderer(options)

    @ambientLight = createAmbientLight(options)
    @scene.add(@ambientLight)

    @directionalLight = createDirectionalLight(
      _.extend({}, options, {position: @camera.position})
    )

    @scene.add(@directionalLight)

    if Env.development
      @stats = createStats()
      document.body.appendChild(@stats.domElement)

    worldRenderers.push(@)

  destroy: ->
    console.debug("Destroying worldRenderer...")

    @destroyed = true
    $(@stats.domElement).remove() if @stats
    cancelAnimationFrame @requestId
    worldRenderers = _(worldRenderers).reject (worldRenderer) => worldRenderer == @

  attachToDom: (domElement)->
    $(domElement).append(@renderer.domElement)
    @

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

createCamera = (options) ->
  camera = new THREE.PerspectiveCamera( options.fov, options.width / options.height, 1, 10000 )
  camera.position.z = 8000
  camera.position.x = 5000
  camera.position.y = 2000
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

createStats = ->
  stats = new Stats()
  stats.setMode(0)

  # Align top-left
  stats.domElement.style.position = 'absolute'
  stats.domElement.style.zIndex = 100

  stats.domElement.children[ 0 ].children[ 0 ].style.color = "#aaa"
  stats.domElement.children[ 0 ].style.background = "transparent"
  stats.domElement.children[ 0 ].children[ 1 ].style.display = "none"
  stats

render = (worldRenderer) ->
  worldRenderer.scene.children.forEach (child) ->
    child.animate() if child.animate

  worldRenderer.renderer.render( worldRenderer.scene, worldRenderer.camera )
  worldRenderer.stats.update() if worldRenderer.stats
