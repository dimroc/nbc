window.Graphics.World = class World
  @DEFAULT_OPTIONS: {
    width: 1000
    height: 600
  }

  @create: (options) ->
    new World(options)

  constructor: (options)->
    options = $.extend(true, World.DEFAULT_OPTIONS, options)

    if ( ! Detector.webgl )
      Detector.addGetWebGLMessage()

    console.debug("Creating world...")
    @scene = new THREE.Scene()

    # Create camera
    @camera = new THREE.PerspectiveCamera( 75, options.width / options.height, 1, 10000 )
    @camera.position.z = 1000
    @scene.add( @camera )

    @renderer = new THREE.WebGLRenderer()
    @renderer.setSize( options.width, options.height )

    if Env.development
      @stats = new Stats()
      document.body.appendChild(@stats.domElement)

  destroy: ->
    console.debug("Destroying world...")

    @destroyed = true
    $(@stats.domElement).remove() if @stats
    cancelAnimationFrame

  attachToDom: (domElement)->
    $(domElement).append(@renderer.domElement)
    @

  animate: =>
    @_render()
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

  # Privates

  _render: ->
    @scene.children.forEach (child) ->
      child.animate() if child.animate

    @renderer.render( @scene, @camera )
    @stats.update() if @stats
    @
