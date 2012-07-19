App.worlds = []

class App.World
  @DEFAULT_OPTIONS: {
    fov: 45
    width: 1280
    height: 720
  }

  @create: (options) ->
    new World(options)

  constructor: (options)->
    options = $.extend(true, World.DEFAULT_OPTIONS, options)

    if ( ! Detector.webgl )
      Detector.addGetWebGLMessage()

    console.debug("Creating world...")
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
      @stats = new Stats()
      document.body.appendChild(@stats.domElement)

    App.worlds.push(@)

  destroy: ->
    console.debug("Destroying world...")

    @destroyed = true
    $(@stats.domElement).remove() if @stats
    cancelAnimationFrame
    App.worlds = _(App.worlds).reject (world) => world == @

  attachToDom: (domElement)->
    $(domElement).append(@renderer.domElement)
    @

  animate: (elapsedTicks)=>
    render(@)
    if @destroyed
      cancelAnimationFrame
      console.debug("Animating after destruction...")
    else
      requestAnimationFrame(@animate)

  add: (mesh)->
    @scene.add( mesh )
    @

  meshes: ->
    _.select(@scene.children, (child) -> return child.geometry)

# privates

createCamera = (options) ->
  camera = new THREE.PerspectiveCamera( options.fov, options.width / options.height, 1, 10000 )
  camera.position.z = 2000
  camera.position.x = 500
  camera.position.y = -500
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

render = (world) ->
  world.scene.children.forEach (child) ->
    child.animate() if child.animate

  world.renderer.render( world.scene, world.camera )
  world.stats.update() if world.stats
